------------------------------------------------------------------------------
--                                                                          --
--                             GNAT EXAMPLE                                 --
--                                                                          --
--             Copyright (C) 2013, Free Software Foundation, Inc.           --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

pragma Warnings (Off);
with System.STM32F4; use System.STM32F4;
pragma Warnings (On);

with Leds; use Leds;
with Ada.Real_Time; use Ada.Real_Time;

procedure Main is
   Period : constant Time_Span := Milliseconds (200);
   Next_Start : Time := Clock;

   type Idx_Type is mod 4;
   Idx : Idx_Type := 0;
   Masks : constant array (Idx_Type) of Word :=
     (16#1_000#, 16#2_000#, 16#4_000#, 16#8_000#);
begin
   loop
      --  Off
      GPIOD.BSRR := Masks (Idx) * 2**16;

      if Get_Direction then
         Idx := Idx + 1;
      else
         Idx := Idx - 1;
      end if;

      --  On
      GPIOD.BSRR := Masks (Idx);

      Next_Start := Next_Start + Period;
      delay until Next_Start;
   end loop;
end Main;
