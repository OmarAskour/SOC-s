#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>





void set_fingers(unsigned int *finger_regs)
{
int i;
	FILE *f[6];
	f[0] = fopen("/sys/devices/amba.0/43c10000.myip_servo2/finger0","r+");
	f[1] = fopen("/sys/devices/amba.0/43c10000.myip_servo2/finger1","r+");
	f[2] = fopen("/sys/devices/amba.0/43c10000.myip_servo2/finger2","r+");
	f[3] = fopen("/sys/devices/amba.0/43c10000.myip_servo2/finger3","r+");
	f[4] = fopen("/sys/devices/amba.0/43c10000.myip_servo2/finger4","r+");
	f[5] = fopen("/sys/devices/amba.0/43c10000.myip_servo2/finger5","r+");

	if(f[0]==NULL)
	{
		printf("Error opening file\n");
		return ;
	}

	for(i=0; i< 6 ;++i)
	{
		if(finger_regs[i] < 30)  finger_regs[i]=30;
		fprintf(f[i],"%d",finger_regs[i]);
		fclose(f[i]);
	}


}

int main(int argc,char** argv)
{

	unsigned int cnt_time;
	unsigned int finger_regs[6];



	struct timeval time;

	while(1){

		gettimeofday(&time, 0);
		cnt_time = (time.tv_sec) % 60;

		printf("%d seconds\n",cnt_time);



		finger_regs[0]= 0; // Daumen
		finger_regs[1]= 0;  // Gelenk 
		finger_regs[2]= 0;  // Mittelfinger
		finger_regs[3]= 0;   // Zeigefinger
		finger_regs[4]= 0;   //Ringfinger
		finger_regs[5]= 0;   // kleine Finger



		switch(cnt_time%5){

			case 1:
				// red reg , finger0 auf

				finger_regs[0]= 30; // Daumen
				finger_regs[1]= 0;  // Gelenk 
				finger_regs[2]= 0;  // Mittelfinger
				finger_regs[3]= 100;   // Zeigefinger
				finger_regs[4]= 0;   //Ringfinger
				finger_regs[5]= 0;   // kleine Finger


				break;


			case 2:
				// red reg , finger0+1 auf
				finger_regs[0]= 30; // Daumen
				finger_regs[1]= 25;  // Gelenk 
				finger_regs[2]= 100;  // Mittelfinger
				finger_regs[3]= 100;   // Zeigefinger
				finger_regs[4]= 0;   //Ringfinger
				finger_regs[5]= 0;   // kleine Finger


				break;


			case 3:
				// red reg , finger0+1+2 auf
				finger_regs[0]= 30; // Daumen
				finger_regs[1]= 50;  // Gelenk 
				finger_regs[2]= 100;  // Mittelfinger
				finger_regs[3]= 100;   // Zeigefinger
				finger_regs[4]= 100;   //Ringfinger
				finger_regs[5]= 0;   // kleine Finger


				break;

			case 4:
				// red reg , finger0+1+2+3 auf
				finger_regs[0]= 30; // Daumen
				finger_regs[1]= 75;  // Gelenk 
				finger_regs[2]= 100;  // Mittelfinger
				finger_regs[3]= 100;   // Zeigefinger
				finger_regs[4]= 100;   //Ringfinger
				finger_regs[5]= 100;   // kleine Finger

				break;

			case 5:
				// red reg , finger0+1+2+3+4 auf

				finger_regs[0]= 100; // Daumen
				finger_regs[1]= 100;  // Gelenk 
				finger_regs[2]= 100;  // Mittelfinger
				finger_regs[3]= 100;   // Zeigefinger
				finger_regs[4]= 100;   //Ringfinger
				finger_regs[5]= 100;   // kleine Finger

				break;

			default:
				// red all reg , alle finger zu

				finger_regs[0]= 100;
				finger_regs[1]= 0;
				finger_regs[2]= 0;
				finger_regs[3]= 0;
				finger_regs[4]= 0;
				finger_regs[5]= 0;


		}

		int i=0;
		printf("fingers:");
		for(i=0; i< 6;++i)
		{
			printf("%d ", finger_regs[i]);
		}
		printf("\n");


		set_fingers(finger_regs);

		usleep(500000);
	}


	return 0;
}
