with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is

   -- Tamaño de la memoria y cantidad de semáforos
   Memoria_Size : constant Integer := 128;
   Semaforo_Count : constant Integer := 16;

   -- Definición del arreglo de memoria compartida
   type Memory_Array is array (0 .. Memoria_Size - 1) of Integer;
   Shared_Memory : Memory_Array := (others => 0);

   -- Inicialización de la variable compartida en memoria
   Valor_Pos : constant Integer := 100; -- Posición de la variable `valor`

   -- Definición del tipo de tarea para los semáforos
   task type Semaforo is
      entry Init(Value : Integer);
      entry Wait;
      entry Signal;
   end Semaforo;

   task body Semaforo is
      S : Integer := 0; -- Contador del semáforo
   begin
      loop
         select
            when S > 0 =>
               accept Wait do
                  S := S - 1;
               end Wait;
         or
            accept Signal do
               S := S + 1;
            end Signal;
         or
            accept Init(Value : Integer) do
               S := Value;
            end Init;
         end select;
      end loop;
   end Semaforo;

   -- Declaración de semáforos
   Semaforo_Mutex : Semaforo; -- Para controlar la exclusión mutua
   Semaforo_Sync : Semaforo;  -- Para sincronizar las CPUs

   -- Definición del tipo de tarea para la memoria compartida
   task Memoria is
      entry Leer(Pos : in Integer; Val : out Integer);
      entry Escribir(Pos : in Integer; Val : in Integer);
   end Memoria;

   task body Memoria is
   begin
      loop
         select
            accept Leer(Pos : in Integer; Val : out Integer) do
               Val := Shared_Memory(Pos);
            end Leer;
         or
            accept Escribir(Pos : in Integer; Val : in Integer) do
               Shared_Memory(Pos) := Val;
            end Escribir;
         end select;
      end loop;
   end Memoria;

   -- Procedures SEMINIT, SEMWAIT y SEMSIGNAL
   procedure SEMINIT(Sem_Id : in Integer; Value : in Integer) is
   begin
      Semaforo_Mutex.Wait;
      if Sem_Id >= 0 and Sem_Id < Semaforo_Count then
         Semaforo_Sync.Init(Value);
      end if;
      Semaforo_Mutex.Signal;
   end SEMINIT;

   procedure SEMWAIT(Sem_Id : in Integer) is
   begin
      Semaforo_Mutex.Wait;
      if Sem_Id >= 0 and Sem_Id < Semaforo_Count then
         Semaforo_Sync.Wait;
      end if;
      Semaforo_Mutex.Signal;
   end SEMWAIT;

   procedure SEMSIGNAL(Sem_Id : in Integer) is
   begin
      Semaforo_Mutex.Wait;
      if Sem_Id >= 0 and Sem_Id < Semaforo_Count then
         Semaforo_Sync.Signal;
      end if;
      Semaforo_Mutex.Signal;
   end SEMSIGNAL;

   -- Definición del tipo de tarea para los CPUs
   task type CPU(Number : Integer) is
      entry Start;
   end CPU;

   task body CPU is
      A : Integer := 0;  -- Acumulador
      IP : Integer := 0; -- Instruction Pointer, inicializado dinámicamente
      Instruction, Operand1, Operand2 : Integer;
   begin
      accept Start do
         if Number = 0 then
            IP := 0;  -- CPU 1 comienza en las instrucciones 0-6
         elsif Number = 1 then
            IP := 7;  -- CPU 2 comienza en las instrucciones 7-13
         end if;

         loop
            Semaforo_Mutex.Wait;  -- Exclusión mutua para proteger la memoria

            -- Leer la instrucción
            Memoria.Leer(IP, Instruction);
            Memoria.Leer(IP + 1, Operand1);
            if Instruction in 7 .. 8 then
               Memoria.Leer(IP + 2, Operand2);
            end if;

            -- Ejecutar la instrucción
            case Instruction is
            when 1 =>  -- LOAD
               Memoria.Leer(Operand1, A);

            when 2 =>  -- STORE
               Memoria.Escribir(Operand1, A);

            when 3 =>  -- ADD
               Memoria.Leer(Operand1, Operand2);
               A := A + Operand2;

            when 4 =>  -- SUB
               Memoria.Leer(Operand1, Operand2);
               A := A - Operand2;

            when 5 =>  -- BRCPU
               if Number = Operand1 then
                  IP := Operand2;
               end if;

            when 6 =>  -- SEMINIT
               Semaforo_Mutex.Signal; -- Liberar exclusión mutua antes de usar semáforos
               Semaforo_Sync.Init(Operand2);
               Semaforo_Mutex.Wait;

            when 7 =>  -- SEMWAIT
               Semaforo_Mutex.Signal; -- Liberar exclusión mutua antes de usar semáforos
               Semaforo_Sync.Wait;
               Semaforo_Mutex.Wait;

            when 8 =>  -- SEMSIGNAL
               Semaforo_Mutex.Signal; -- Liberar exclusión mutua antes de usar semáforos
               Semaforo_Sync.Signal;
               Semaforo_Mutex.Wait;

            when others =>
               Semaforo_Sync.Signal; -- Notificar que la CPU ha terminado
               Semaforo_Mutex.Signal; -- Liberar el semáforo
               exit; -- Finalizar ejecución
            end case;

            -- Incrementar el IP después de cada instrucción
            IP := IP + 2;

            -- Liberar el semáforo tras finalizar la instrucción
            Semaforo_Mutex.Signal;
         end loop;
      end Start;
   end CPU;

   -- Declaración de dos CPUs concurrentes
   CPU_1 : CPU(0);
   CPU_2 : CPU(1);

begin
   -- Inicialización de semáforos
   Semaforo_Mutex.Init(1);  -- Inicialización del semáforo Mutex
   Semaforo_Sync.Init(0);   -- Inicialización del semáforo Sync

   -- Asignación inicial de la variable en la memoria
   Shared_Memory(Valor_Pos) := 8;

   -- Cargar Instrucciones Iniciales CPU 1
   Shared_Memory(0) := 1; -- LOAD valor
   Shared_Memory(1) := Valor_Pos;
   Shared_Memory(2) := 3; -- ADD
   Shared_Memory(3) := 101; -- Dirección ficticia con valor 13
   Shared_Memory(4) := 2; -- STORE
   Shared_Memory(5) := Valor_Pos;
   Shared_Memory(6) := 0;

   -- Cargar Instrucciones Iniciales CPU 2
   Shared_Memory(7) := 1; -- LOAD valor
   Shared_Memory(8) := Valor_Pos;
   Shared_Memory(9) := 3; -- ADD
   Shared_Memory(10) := 102; -- Dirección ficticia con valor 27
   Shared_Memory(11) := 2; -- STORE
   Shared_Memory(12) := Valor_Pos;
   Shared_Memory(13) := 0;

   Shared_Memory(101) := 13; -- Valor para CPU 1
   Shared_Memory(102) := 27; -- Valor para CPU 2

   Shared_Memory(14) := 0; -- Fin del programa

   -- Iniciar las CPUs
   CPU_1.Start;
   CPU_2.Start;

   -- Esperar a que ambas CPUs terminen
   Semaforo_Sync.Wait;
   Semaforo_Sync.Wait;

   -- Mostrar el resultado final
   declare
      Resultado : Integer;
   begin
      Memoria.Leer(Valor_Pos, Resultado);
      Put_Line("Resultado Final: " & Integer'Image(Resultado));
   end;
end Main;
