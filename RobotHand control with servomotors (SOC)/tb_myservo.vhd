----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2020 01:53:55 PM
-- Design Name: 
-- Module Name: tb_myservo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_myservo is
--  Port ( );
end tb_myservo;


architecture Behavioral of tb_myservo is

component myservo
  port (
       clk, reset  : in std_logic;
       servo_pos   : in std_logic_vector(7 downto 0);
       servo_out   : out std_logic
 );
end component;

signal CLK, RESET, SERVO_OUT : std_logic;
signal SERVO_POS:  std_logic_vector(7 downto 0);

constant clock_period: time := 10ns;

begin

uut: myservo port map ( 
                             clk   => CLK  ,
                             reset   => RESET ,
                             servo_out =>   SERVO_OUT,
                             servo_pos => SERVO_POS
                             );


generate_sim_clock: process
     begin
     CLK<='1';
     wait for clock_period/2;
     CLK<='0';
     wait for clock_period/2;
     end process;   


stimuli: process
       begin

   RESET <=  '1';
   wait for clock_period;
   
    RESET <=  '0';
   wait for clock_period*2;

   SERVO_POS <= "00000000";
  wait for 20ms;

   SERVO_POS<= "00101000";
   wait for 20ms;
 
   SERVO_POS <= "01010000";
   wait for 20ms;
  
   SERVO_POS <= "01111000";
    wait for 20 ms;
    
    
    SERVO_POS <= "01011001";
        wait for 20 ms;
    
    SERVO_POS <= "11111111";
    
    
    
    
     wait;
       end process; 


end Behavioral;
