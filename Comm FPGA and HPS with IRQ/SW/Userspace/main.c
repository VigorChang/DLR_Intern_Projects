/********************************************************************
*Project: Simple Communication between FPGA and HPS with Interrupt
*Author: Jianwei Zhang, DLR
*Function: useIrq
*Description: Creat 2 thread, readDelay and sendPause. The thread of
	readDelay utilize the interrupt from FPGA by displaying delay
	number whenever an interrupt happens. The thread of sendPause
	sends 0/1 to FPGA to control the running of LED, via LWHPS2FPGA
	bridge.
********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>

#define SYSFS_FILE "/sys/bus/platform/drivers/fpga_uinput/fpga_uinput"
#define PAGE_SIZE 4096
#define LWHPS2FPGA_BRIDGE_BASE 0xff200000
#define PAUSE_OFFSET 0X1

volatile unsigned char * pause_mem;
void * bridge_map;

void * readDelay(void *);
void * sendPause(void *);

int main(int argc, char *argv[])
{
	printf("\nStart.\n");
	void * tret;

	//Creat the thread of pause and delay
	pthread_t tid_pause,tid_delay;
	int creat_pause=0,creat_delay=0;
	creat_pause=pthread_create(&tid_pause,NULL,sendPause,NULL);
	if(creat_pause!=0)
	{
		printf("Creat send pause thread failed.\n");
		return -1;
	}
	creat_delay=pthread_create(&tid_delay,NULL,readDelay,NULL);
	if(creat_delay!=0)
	{
		printf("Creat read delay thread failed.\n");
		return -1;
	}

	//Wait for pause thread exit
	pthread_join(tid_pause,&tret);
	//Then exit the delay thread
	pthread_cancel(tid_delay);

	printf("Exit main function.\n");

	return 0;
}

void * readDelay(void * arg)
{
	//Set the thread, let it can be canceled any time
	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS,NULL);  
	FILE * irqf;
	char delay;
	printf("Thread of read delay start.\n");
	while(1)
	{
		//Open SYSFS_FILE, to utilize the interrupt signal
		irqf=fopen(SYSFS_FILE, "r");
		if (irqf == NULL)
		{
			perror("Open SYSFS_FILE error!\n");
			pthread_exit(0);
		}

		int ans;
		//0 interrupt: thread will be stucked at here, until
		//    an interrupt happens
		//>=1 interrupt: var 'ans' will fetch the content in
		//    SYSFS_FILE, which is just the delay number.
		ans = fread(&delay, 1, 1, irqf);
		fclose(irqf);
		if (ans != 1) 
		{
			if (errno == EAGAIN)
			{
				printf("No data in SYSFS_FILE!\n");
				continue;
			}
			pthread_exit(0);
		}
		printf("Delay is 0x%02x.\n",delay);
	}
}

void * sendPause(void * arg)
{
	int fd;
	//Set bridge base address
	off_t bridge_base = LWHPS2FPGA_BRIDGE_BASE;
	printf("Thread of send pause start.\n");

	/* Open the memory device file */
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("open");
		pthread_exit(0);
	}
	printf("Open memory device success.\n");

	/* map the LWHPS2FPGA bridge into process memory */
	bridge_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, bridge_base);
	if (bridge_map == MAP_FAILED) {
		perror("mmap");
		goto cleanup;
	}
	printf("Map bridge into memory success.\n");

	/* get the delay_ctrl peripheral's base address */
	pause_mem = (unsigned char *) (bridge_map+PAUSE_OFFSET);

	char pause=0;
	int xx;
	while(1)
	{
		xx = 0;
		printf("Enter 9 to exit, 1 to run/pause.\n");
		scanf("%d",&xx);
		if (xx == 9) break;
		if (xx == 1)
		{
			if (pause==0) pause=1;
			else pause=0;
			printf("pause=0x%02x\n",pause);
			//Write content to delay_ctrl peripheral
			*pause_mem=pause;
		}
	}
	
	if (munmap(bridge_map, PAGE_SIZE) < 0) {
		perror("munmap");
		goto cleanup;
	}

cleanup:
	close(fd);
	pthread_exit(0);
}
