library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myip_servo2_v1_0 is
	generic (
		-- Users to add parameters here
		 NUM_OUTPUTS:  integer range 1 to 6 := 6;

                       

--my servo

      divisor : positive := 780;  -- controls clock divider frequency
      Z_pos : positive := 32; -- adjusts center position of the servo
      servo_period : positive := 1279; --20*64khz -- servo_period controls the output peroid


		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 5
	);
	port (
		-- Users to add ports here
       io_out: out std_logic_vector(NUM_OUTPUTS-1 downto 0);      
        

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end myip_servo2_v1_0;

architecture arch_imp of myip_servo2_v1_0 is

	-- component declaration
	component myip_servo2_v1_0_S00_AXI is
		generic (

		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
		);
		port (
		
		
		 --changes servo
        servo_pos   : out std_logic_vector(7 downto 0);
        servo_pos_1  : out std_logic_vector(7 downto 0);
        servo_pos_2 : out std_logic_vector(7 downto 0);
        servo_pos_3  : out std_logic_vector(7 downto 0);
        servo_pos_4  : out std_logic_vector(7 downto 0);
        servo_pos_5  : out std_logic_vector(7 downto 0);

		
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component myip_servo2_v1_0_S00_AXI;
	

	
	-----my servo
	
	
	component myservo is
        generic ( 
             divisor : positive := 780;  
             Z_pos : positive := 32; 
             servo_period : positive := 1279
        
        );
            Port ( 
                   
                clk, reset  : in std_logic;
                servo_pos   : in std_logic_vector(7 downto 0);
                servo_out   : out std_logic
             );      
      end component myservo;
      
      signal reset : std_logic;
      
      signal s_servo_pos : std_logic_vector(7 downto 0);
      signal s_servo_pos_1 : std_logic_vector(7 downto 0);
      signal s_servo_pos_2 : std_logic_vector(7 downto 0);
      signal s_servo_pos_3 : std_logic_vector(7 downto 0);
      signal s_servo_pos_4 : std_logic_vector(7 downto 0);
      signal s_servo_pos_5: std_logic_vector(7 downto 0);
      
--      signal s_servo_out : std_logic;
--      signal s_servo_out_1 : std_logic;
--      signal s_servo_out_2 : std_logic;
--      signal s_servo_out_3 : std_logic;
--      signal s_servo_out_4: std_logic;
--      signal s_servo_out_5: std_logic;
	
	

begin

-- Instantiation of Axi Bus Interface S00_AXI
myip_servo2_v1_0_S00_AXI_inst : myip_servo2_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	
	-- chnges servo
	    servo_pos => s_servo_pos,
	    servo_pos_1 => s_servo_pos_1,
	    servo_pos_2 => s_servo_pos_2,
	    servo_pos_3 => s_servo_pos_3,
	    servo_pos_4 => s_servo_pos_4,
	    servo_pos_5 => s_servo_pos_5,
	   

		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
	
	reset <= not s00_axi_aresetn;
	
	-- Instantiation of servo 0
	
	servo_0: myservo
	generic map(
	divisor  => divisor,
    Z_pos => Z_pos,
    servo_period => servo_period
	
	) port map (
	
	clk => s00_axi_aclk,
	reset  => reset,
    servo_pos =>  s_servo_pos,
    servo_out => io_out(0)
	
	); 
	
	-- Instantiation of servo 1
	
	gen1: if NUM_OUTPUTS >= 1 generate
   servo_1: myservo
    generic map(
    divisor  => divisor,
    Z_pos => Z_pos,
    servo_period => servo_period
    
    ) port map (
    
    clk => s00_axi_aclk,
    reset  => reset,
    servo_pos =>  s_servo_pos_1,
    servo_out => io_out(1)
    
    ); 
    end generate;

	-- Instantiation of servo 2
	gen2: if NUM_OUTPUTS >= 2 generate
	  servo_2: myservo
      generic map(
      divisor  => divisor,
      Z_pos => Z_pos,
      servo_period => servo_period
      
      ) port map (
      
      clk => s00_axi_aclk,
      reset  => reset,
      servo_pos =>  s_servo_pos_2,
      servo_out => io_out(2)
      
      ); 
      end generate;
      
	-- Instantiation of servo 3
	gen3: if NUM_OUTPUTS >= 3 generate
   servo_3: myservo
    generic map(
    divisor  => divisor,
    Z_pos => Z_pos,
    servo_period => servo_period
    
    ) port map (
    
    clk => s00_axi_aclk,
    reset  => reset,
    servo_pos =>  s_servo_pos_3,
    servo_out => io_out(3)
    
    ); 
    end generate;
    
	-- Instantiation of servo 4
	gen4: if NUM_OUTPUTS >= 4 generate
	 servo_4: myservo
       generic map(
       divisor  => divisor,
       Z_pos => Z_pos,
       servo_period => servo_period
       
       ) port map (
       
       clk => s00_axi_aclk,
       reset  => reset,
       servo_pos =>  s_servo_pos_4,
       servo_out => io_out(4)
       ); 
       end generate;
    -- Instantiation of servo 5
	
	gen5: if NUM_OUTPUTS >= 5 generate
	servo_5: myservo
           generic map(
           divisor  => divisor,
           Z_pos => Z_pos,
           servo_period => servo_period
           
           ) port map (
           
           clk => s00_axi_aclk,
           reset  => reset,
           servo_pos =>  s_servo_pos_5,
           servo_out => io_out(5)
           ); 
           end generate;



	-- User logic ends

end arch_imp;
