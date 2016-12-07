#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <malloc.h>
#include "startram.h"
#include "sgdma_dispatcher.h"

#define BRIDGE_BASE 0xFF200000
#define INPHASE_DATA_READ_CSR_OFFSET 0x0
#define INPHASE_DATA_READ_DESCRIPTOR_OFFSET 0x100
#define QUARDRA_DATA_READ_CSR_OFFSET 0x200
#define QUARDRA_DATA_READ_DESCRIPTOR_OFFSET 0x300
#define SEND_CTRL_OFFSET 0x400

#define PAGE_SIZE 4096
#define DATA_LENGTH 512

unsigned int *in_data_read_csr_mem;
unsigned int *qu_data_read_csr_mem;
unsigned int *in_data_read_descriptor_mem;
unsigned int *qu_data_read_descriptor_mem;
unsigned int *send_ctrl_mem;
void *bridge_map;

int main(int argc, char *argv[])
{
	printf("Start\n");
	/***********RAM Start*************/
	int ret;
	//ret=startram();
	//if(ret == 0) {printf("RAM Start success.\n\n");}
	//else {printf("RAM Start failed.\n\n");return -1;}

	/********Map memory********/
	printf("MAIN mmap start\n");
	int fd;
	ret = EXIT_FAILURE;
	off_t bridge = BRIDGE_BASE;
	//Map memory to file
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("MAIN open");
		exit(EXIT_FAILURE);
	}
	//Map the LWHPS2FPGA bridge
	bridge_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, bridge);
	if (bridge_map == MAP_FAILED) {
		perror("MAIN mmap");
		close(fd);
		exit(EXIT_FAILURE);
	}
	//Get CSR, Descriptor and Control address
	in_data_read_csr_mem = (unsigned int *) (bridge_map + INPHASE_DATA_READ_CSR_OFFSET);
	in_data_read_descriptor_mem = (unsigned int *) (bridge_map + INPHASE_DATA_READ_DESCRIPTOR_OFFSET);
	qu_data_read_csr_mem = (unsigned int *) (bridge_map + QUARDRA_DATA_READ_CSR_OFFSET);
	qu_data_read_descriptor_mem = (unsigned int *) (bridge_map + QUARDRA_DATA_READ_DESCRIPTOR_OFFSET);
	send_ctrl_mem = (unsigned int *) (bridge_map + SEND_CTRL_OFFSET);

	printf("MAIN mmap end\n");

	/*******reset dispatcher*******/
	int smallDelay;
	rst_dispatcher(in_data_read_csr_mem);
	smallDelay = 1000;
	while(smallDelay--){}
	rst_dispatcher(qu_data_read_csr_mem);
	smallDelay = 1000;
	while(smallDelay--){}

	/*******Transfer Inphase data to fifo*******/
	printf("Transfer InData Start\n");
	sgdma_standard_descriptor * in_data_read_descriptor;
	in_data_read_descriptor = (sgdma_standard_descriptor *) malloc(16);
	unsigned int *in_data_read_address = (unsigned int *)0x28000000;
	unsigned int length;
	unsigned int control = 0;
	length = DATA_LENGTH;

	construct_mm_to_st_descriptor(in_data_read_descriptor, in_data_read_address, length, control);
	ret = write_standard_descriptor(in_data_read_csr_mem, in_data_read_descriptor_mem, in_data_read_descriptor);
	if(ret == 0) {printf("Transfer InData success.\n");}
	else {printf("Transfer InData failed.\n");return -1;}

	printf("Transfer InData End\n");

	/*******Transfer Quardra data to fifo*******/
	printf("Transfer QuData Start\n");
	sgdma_standard_descriptor * qu_data_read_descriptor;
	qu_data_read_descriptor = (sgdma_standard_descriptor *) malloc(16);
	unsigned int *qu_data_read_address = (unsigned int *)0x29000000;
	control = 0;
	length = DATA_LENGTH;

	construct_mm_to_st_descriptor(qu_data_read_descriptor, qu_data_read_address, length, control);
	ret = write_standard_descriptor(qu_data_read_csr_mem, qu_data_read_descriptor_mem, qu_data_read_descriptor);
	if(ret == 0) {printf("Transfer QuData success.\n");}
	else {printf("Transfer QuData failed.\n");return -1;}

	printf("Transfer QuData End\n");

	/********Display csr status*******/
	csr_status_info(in_data_read_csr_mem);
	csr_status_info(qu_data_read_csr_mem);

	/*****Enable Send*****/
	printf("Enable Send Start\n");
	char tx_en;
	tx_en = 1;
	*send_ctrl_mem = tx_en;
	printf("Enable Send End\n");

	/*int input;
	printf("Continue? 1-y 0-n\n");
	scanf("%d",&input);
	if(input==0) {return -1;}*/

	/********munmap*******/
	if (munmap(bridge_map, PAGE_SIZE) < 0) {
		perror("MAIN munmap");
		close(fd);
		exit(EXIT_FAILURE);
	}
	close(fd);

	printf("MAIN end\n");

	return 0;
}