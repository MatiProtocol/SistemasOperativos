with Ada.Text_IO; use Ada.Text_IO;

procedure LMC_Simulation is

   -- Constantes para definir la memoria y semáforos
   Memory_Size : constant := 128;
   Num_Semaphores : constant := 16;

   -- Tipo explícito para la memoria compartida
   type Memory_Type is array (0 .. Memory_Size - 1) of Integer;

   -- Tipo protegido para la memoria compartida
   protected type Shared_Memory is
      procedure Write(Address : Integer; Value : Integer);
      function Read(Address : Integer) return Integer;
   private
      Mem : Memory_Type := (others => 0); -- Inicialización explícita
   end Shared_Memory;

   protected body Shared_Memory is
      procedure Write(Address : Integer; Value : Integer) is
      begin
         Mem(Address) := Value;
      end Write;

      function Read(Address : Integer) return Integer is
      begin
         return Mem(Address);
      end Read;
   end Shared_Memory;

   -- Memoria compartida
   Memory : Shared_Memory;

   -- Tipo protegido para semáforos
   protected type Semaphore is
      procedure Init(Value : Integer);
      procedure Wait;
      procedure Signal;
   private
      Counter : Integer := 0;
   end Semaphore;

   protected body Semaphore is
      procedure Init(Value : Integer) is
      begin
         Counter := Value;
      end Init;

      procedure Wait is
      begin
         while Counter = 0 loop
            delay 0.01; -- Simula espera activa (puedes usar entrada/salida si se prefiere)
         end loop;
         Counter := Counter - 1;
      end Wait;

      procedure Signal is
      begin
         Counter := Counter + 1;
      end Signal;
   end Semaphore;

   -- Array de semáforos
   type Semaphore_Array is array (0 .. Num_Semaphores - 1) of Semaphore;
   Semaphores : Semaphore_Array;

   -- Tipo de registro de la CPU
   type CPU_Registers is record
      Acc : Integer := 0; -- Acumulador
      IP  : Integer := 0; -- Puntero de instrucción
      ID  : Integer := 0; -- Identificador único de CPU
   end record;

   -- Tareas de CPU
   task type CPU_Task(ID : Integer) is
      entry Start;
   end CPU_Task;

   task body CPU_Task is
      Regs : CPU_Registers := (Acc => 0, IP => 0, ID => ID);
   begin
      accept Start;
      loop
         declare
            Instruction : Integer := Memory.Read(Regs.IP);
         begin
            case Instruction is
               when 100 => -- LOAD
                  Regs.Acc := Memory.Read(Memory.Read(Regs.IP + 1));
                  Regs.IP := Regs.IP + 2;
               when 200 => -- STORE
                  Memory.Write(Memory.Read(Regs.IP + 1), Regs.Acc);
                  Regs.IP := Regs.IP + 2;
               when 300 => -- ADD
                  Regs.Acc := Regs.Acc + Memory.Read(Memory.Read(Regs.IP + 1));
                  Regs.IP := Regs.IP + 2;
               when 400 => -- SUB
                  Regs.Acc := Regs.Acc - Memory.Read(Memory.Read(Regs.IP + 1));
                  Regs.IP := Regs.IP + 2;
               when 500 => -- BRCPU
                  if Regs.ID = Memory.Read(Regs.IP + 1) then
                     Regs.IP := Memory.Read(Regs.IP + 2);
                  else
                     Regs.IP := Regs.IP + 3;
                  end if;
               when 600 => -- SEMINIT
                  Semaphores(Memory.Read(Regs.IP + 1)).Init(Memory.Read(Regs.IP + 2));
                  Regs.IP := Regs.IP + 3;
               when 700 => -- SEMWAIT
                  Semaphores(Memory.Read(Regs.IP + 1)).Wait;
                  Regs.IP := Regs.IP + 2;
               when 800 => -- SEMSIGNAL
                  Semaphores(Memory.Read(Regs.IP + 1)).Signal;
                  Regs.IP := Regs.IP + 2;
               when 900 => -- HALT
                  exit;
               when others =>
                  Put_Line("Unknown Instruction");
                  exit;
            end case;
         end;
      end loop;
   end CPU_Task;

   -- Instancias de CPU
   CPU0 : CPU_Task(0);
   CPU1 : CPU_Task(1);

begin
   -- Inicialización de memoria y semáforos
   Memory.Write(0, 100); -- LOAD 0
   Memory.Write(1, 0);
   Memory.Write(2, 300); -- ADD 1
   Memory.Write(3, 1);
   Memory.Write(4, 200); -- STORE 2
   Memory.Write(5, 2);
   Memory.Write(6, 900); -- HALT

   -- Semáforos inicializados en 0
   for I in Semaphores'Range loop
      Semaphores(I).Init(0);
   end loop;

   -- Iniciar CPUs
   CPU0.Start;
   CPU1.Start;

end LMC_Simulation;
