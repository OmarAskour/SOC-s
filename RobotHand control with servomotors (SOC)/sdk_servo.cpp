
#include "xil_io.h"
#include "xparameters.h"
#include <unistd.h>

int main()
{
	u32 var;
    u32 angle=0;


	while(1){

	var = Xil_In32(XPAR_MYIP_0_S_AXI_BASEADDR+7*4);
	//Xil_Out32(XPAR_MYIP_0_S_AXI_BASEADDR,var);
	if(var>0)
	{

		if(var&1 && angle < 254)
			angle+=1;
		if(var&2 && angle > 0)
			angle -=1;

		Xil_Out32(XPAR_MYIP_SERVO2_0_S00_AXI_BASEADDR,angle);
		Xil_Out32(XPAR_MYIP_SERVO2_0_S00_AXI_BASEADDR+1*4,angle+ 10);
		Xil_Out32(XPAR_MYIP_SERVO2_0_S00_AXI_BASEADDR+2*4,angle+15);
		Xil_Out32(XPAR_MYIP_SERVO2_0_S00_AXI_BASEADDR+3*4,angle+20);
		Xil_Out32(XPAR_MYIP_SERVO2_0_S00_AXI_BASEADDR+4*4,angle+25);
		Xil_Out32(XPAR_MYIP_SERVO2_0_S00_AXI_BASEADDR+5*4,angle+30);

		usleep(50000);
	}



}
}
