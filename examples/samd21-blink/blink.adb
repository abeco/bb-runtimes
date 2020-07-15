-- with Interfaces.SAM.PM; use Interfaces.SAM.PM;
with Interfaces.SAM.PORT; use Interfaces.SAM.PORT;
with Interfaces.SAM; use Interfaces.SAM;
With System.Machine_Code; use System.Machine_Code;

procedure Blink is
   PA17_MASK : constant UInt32 := 2#00000000_00000010_00000000_00000000#;
   --  PB03_Mask : constant UInt32 := 2#00000000_00000000_00000000_00001000#;
   --  PA17 is the onboard LED, PB03 is the RX LED

begin
   PORT_Periph.DIRSET0 := PA17_MASK;
   --  PORT_Periph.DIRSET1 := PB03_Mask;

   loop
      for I in 1 .. 500_000 loop
         --  null;  -- this kept getting optimized away
         Asm ("");
      end loop;

      PORT_Periph.OUTTGL0 := PA17_MASK;
      --  PORT_Periph.OUTTGL1 := PB03_Mask;
   end loop;
end Blink;

--  Notes
--  Gonna need PORT - the I/O Pin Controller
--  Each PORT Group (this means PA and PB confirmed with svd)
--  is controlled by the registers in PORT
--  Each PORT pin has 2 relevant bits: 
--  A DIR and a OUT (output value)
--  Also an IN value for when it's an input
--  Sounds like all you need to do is write a 1 to DIRSET for that pin,
--  then toggle with OUTTGL, OUTSET or OUTCLR
--  See 23.6.3.1 for more on configuring a port pin

--  Need to write bit Y of DIR reg to set DIRSET for indiv pin
--  So for pin PA17 I need to write the 18th bit of 
--  these regs to do what I want
--  Mask: 00000000_00000010_00000000_00000000
