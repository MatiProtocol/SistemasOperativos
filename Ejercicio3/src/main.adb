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
      S : Integer := 0;
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

   -- Definición del tipo de tarea para los CPUs
   task type CPU(Number : Integer) is
      entry Start;
   end CPU;

   task body CPU is
      A : Integer := 0;  -- Acumulador
      IP : Integer := 0; -- Instruction Pointer
      Instruction, Operand1, Operand2 : Integer;
   begin
      accept Start do
         loop
            -- Leer la instrucción desde la memoria
            Memoria.Leer(IP, Instruction);
            Memoria.Leer(IP + 1, Operand1);
            if Instruction in 6 .. 8 then
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
                  Semaforo_Mutex.Init(Operand2);
               when 7 =>  -- SEMWAIT
                  Semaforo_Mutex.Wait;
               when 8 =>  -- SEMSIGNAL
                  Semaforo_Mutex.Signal;
               when others =>
                  exit; -- Termina cuando alcanza una instrucción no válida
            end case;

            IP := IP + 2;
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

   -- Cargar Instrucciones Iniciales
   Shared_Memory(0) := 1; -- LOAD valor
   Shared_Memory(1) := Valor_Pos;
   Shared_Memory(2) := 2; -- STORE
   Shared_Memory(3) := Valor_Pos;

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
