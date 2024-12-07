with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is

   total_Memo : constant Integer := 128;
   cant_Semaforos : constant Integer := 16;

   type Memory_Array is array (0 .. total_Memo - 1) of Integer;
   arr_Memo : Memory_Array := (others => 0);

   Valor_Pos : constant Integer := 100;

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

   Semaforo_Mutex : Semaforo;
   Semaforo_Sync : Semaforo;

   task Memoria is
      entry Leer(Pos : in Integer; Val : out Integer);
      entry Escribir(Pos : in Integer; Val : in Integer);
   end Memoria;

   task body Memoria is
   begin
      loop
         select
            accept Leer(Pos : in Integer; Val : out Integer) do
               Val := arr_Memo(Pos);
            end Leer;
         or
            accept Escribir(Pos : in Integer; Val : in Integer) do
               arr_Memo(Pos) := Val;
            end Escribir;
         end select;
      end loop;
   end Memoria;

   procedure SEMINIT(Sem_Id : in Integer; Value : in Integer) is
   begin
      Semaforo_Mutex.Wait;
      if Sem_Id >= 0 and Sem_Id < cant_Semaforos then
         Semaforo_Sync.Init(Value);
      end if;
      Semaforo_Mutex.Signal;
   end SEMINIT;

   procedure SEMWAIT(Sem_Id : in Integer) is
   begin
      Semaforo_Mutex.Wait;
      if Sem_Id >= 0 and Sem_Id < cant_Semaforos then
         Semaforo_Sync.Wait;
      end if;
      Semaforo_Mutex.Signal;
   end SEMWAIT;

   procedure SEMSIGNAL(Sem_Id : in Integer) is
   begin
      Semaforo_Mutex.Wait;
      if Sem_Id >= 0 and Sem_Id < cant_Semaforos then
         Semaforo_Sync.Signal;
      end if;
      Semaforo_Mutex.Signal;
   end SEMSIGNAL;

   task type CPU(Number : Integer) is
      entry Start;
   end CPU;

   task body CPU is
      A : Integer := 0;
      IP : Integer := 0;
      Instruction, Operand1, Operand2 : Integer;
   begin
      accept Start do
         if Number = 0 then
            IP := 0;
         elsif Number = 1 then
            IP := 7;
         end if;

         loop
            Semaforo_Mutex.Wait;

            Memoria.Leer(IP, Instruction);
            Memoria.Leer(IP + 1, Operand1);
            if Instruction in 7 .. 8 then
               Memoria.Leer(IP + 2, Operand2);
            end if;

            case Instruction is
            when 1 =>
               Memoria.Leer(Operand1, A);

            when 2 =>
               Memoria.Escribir(Operand1, A);

            when 3 =>
               Memoria.Leer(Operand1, Operand2);
               A := A + Operand2;

            when 4 =>
               Memoria.Leer(Operand1, Operand2);
               A := A - Operand2;

            when 5 =>
               if Number = Operand1 then
                  IP := Operand2;
               end if;

            when 6 =>
               Semaforo_Mutex.Signal;
               Semaforo_Sync.Init(Operand2);
               Semaforo_Mutex.Wait;

            when 7 =>
               Semaforo_Mutex.Signal;
               Semaforo_Sync.Wait;
               Semaforo_Mutex.Wait;

            when 8 =>
               Semaforo_Mutex.Signal;
               Semaforo_Sync.Signal;
               Semaforo_Mutex.Wait;

            when others =>
               Semaforo_Sync.Signal;
               Semaforo_Mutex.Signal;
               exit;
            end case;
            IP := IP + 2;

            Semaforo_Mutex.Signal;
         end loop;
      end Start;
   end CPU;

   CPU_1 : CPU(0);
   CPU_2 : CPU(1);

begin
   Semaforo_Mutex.Init(1);
   Semaforo_Sync.Init(0);

   arr_Memo(Valor_Pos) := 8;

   arr_Memo(0) := 1;
   arr_Memo(1) := Valor_Pos;
   arr_Memo(2) := 3;
   arr_Memo(3) := 101;
   arr_Memo(4) := 2;
   arr_Memo(5) := Valor_Pos;
   arr_Memo(6) := 0;

   arr_Memo(7) := 1;
   arr_Memo(8) := Valor_Pos;
   arr_Memo(9) := 3;
   arr_Memo(10) := 102;
   arr_Memo(11) := 2;
   arr_Memo(12) := Valor_Pos;
   arr_Memo(13) := 0;

   arr_Memo(101) := 13;
   arr_Memo(102) := 27;

   arr_Memo(14) := 0;

   CPU_1.Start;
   CPU_2.Start;

   Semaforo_Sync.Wait;
   Semaforo_Sync.Wait;

   declare
      valor : Integer;
   begin
      Memoria.Leer(Valor_Pos, valor);
      Put_Line("Variable valor =" & Integer'Image(valor));
   end;
end Main;
