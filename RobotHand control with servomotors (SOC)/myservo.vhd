library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use Ieee.numeric_std.all;

entity myservo is
   generic (
      
      divisor      : positive := 780;  -- controls clock divider frequency
      Z_pos         : positive := 32; -- adjusts center position of the servo
      servo_period : positive := 1279 --20*64khz -- servo_period controls the output peroid
   );
   port (
      clk, reset  : in std_logic;
      servo_pos   : in std_logic_vector(7 downto 0);
      servo_out   : out std_logic
   );
end myservo;

architecture behavioral of myservo is

signal slow_clk : std_logic;


signal counter : integer range 0 to divisor := 0;

--signal used to generate the PWM pulse.
signal servo_counter : std_logic_vector(10 downto 0); -- Counter, from 0 to 1279.

begin

  -- a simple clock divider
  process (clk)
  begin
    if reset = '1' then
      counter <= 0; --(others => '0');
      slow_clk <= '0';
    elsif clk'event and clk = '1' then
      if counter >= divisor then
          counter <= 0 ;--(others => '0');
          slow_clk <= not slow_clk;
      else
       counter <= counter+ 1;
      end if;
    end if;
  end process;

  -- this process controls the width of the pulse being sent to the servo, proportional to servo_pos
  
  process (slow_clk)
  begin
    if reset = '1' then
      servo_counter <= (others => '0');
    elsif slow_clk'event and slow_clk = '1' then

      -- servo_period controls the period of the signal which is sent to the servo
      
      if servo_counter >= servo_period then
        servo_counter <= (others => '0');
      else
        servo_counter <= servo_counter + 1;
      end if;

      -- depending how far into the period, output a '1' or a '0'
      
      if servo_counter < (servo_pos + Z_pos) then
        servo_out <= '1';
     
      else
        servo_out <= '0';
       
      end if;
      
    end if;
  end process;
end behavioral;