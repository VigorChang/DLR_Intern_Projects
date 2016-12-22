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
#define REC_CTRL_OFFSET 0x0
#define INPHASE_DATA_WRITE_CSR_OFFSET 0x100
#define INPHASE_DATA_WRITE_DESCRIPTOR_OFFSET 0x200
#define QUARDRA_DATA_WRITE_CSR_OFFSET 0x300
#define QUARDRA_DATA_WRITE_DESCRIPTOR_OFFSET 0x400

#define PAGE_SIZE 4096
#define DATA_LENGTH 4096

#define IN_REC_DATA_MEM_ADDR 0x30000000
#define QU_REC_DATA_MEM_ADDR 0x31000000

unsigned int *in_data_write_csr_mem;
unsigned int *qu_data_write_csr_mem;
unsigned int *in_data_write_descriptor_mem;
unsigned int *qu_data_write_descriptor_mem;
unsigned int *rec_ctrl_mem;
void *bridge_map;

int main(int argc, char *argv[])
{
	printf("Start Version:1\n");
	/***********RAM Start*************/
	int ret;
	unsigned int length,control;
	//ret=startram();
	//if(ret == 0) {printf("RAM Start success.\n\n");}
	//else {printf("RAM Start failed.\n\n");return -1;}

	/********Map memory********/
	printf("MAIN mmap process ... ");
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
	in_data_write_csr_mem = (unsigned int *) (bridge_map + INPHASE_DATA_WRITE_CSR_OFFSET);
	in_data_write_descriptor_mem = (unsigned int *) (bridge_map + INPHASE_DATA_WRITE_DESCRIPTOR_OFFSET);
	qu_data_write_csr_mem = (unsigned int *) (bridge_map + QUARDRA_DATA_WRITE_CSR_OFFSET);
	qu_data_write_descriptor_mem = (unsigned int *) (bridge_map + QUARDRA_DATA_WRITE_DESCRIPTOR_OFFSET);
	rec_ctrl_mem = (unsigned int *) (bridge_map + REC_CTRL_OFFSET);

	printf("Done\n");

	/*******reset dispatcher*******/
	int smallDelay;
	rst_dispatcher(in_data_write_csr_mem);
	smallDelay = 1000;
	while(smallDelay--){}
	rst_dispatcher(qu_data_write_csr_mem);
	smallDelay = 1000;
	while(smallDelay--){}

	/********Display csr status*******/
	printf("CSR Display:\nBefore start:\nInphase ");
	csr_status_info(in_data_write_csr_mem);
	printf("Quardra ");
	csr_status_info(qu_data_write_csr_mem);

	/*****Enable Send*****/
	printf("RX Enable ...");
	char en;
	en = 1;
	//Start receive part
	*rec_ctrl_mem = en;
	printf("done\n");

	/*******Transfer RX Inphase data to memory*******/
	printf("Transfer RX InData to FIFO ... ");
	sgdma_standard_descriptor * in_data_write_descriptor;
	in_data_write_descriptor = (sgdma_standard_descriptor *) malloc(16);
	unsigned int *in_data_write_address = (unsigned int *) IN_REC_DATA_MEM_ADDR;
	control = 0;
	length = DATA_LENGTH;

	construct_st_to_mm_descriptor(in_data_write_descriptor, in_data_write_address, length, control);
	ret = write_standard_descriptor(in_data_write_csr_mem, in_data_write_descriptor_mem, in_data_write_descriptor);
	if(ret == 0) {printf("success.\n");}
	else {printf("failed.\n");return -1;}

	/*******Transfer RX Quardra data to memory*******/
	printf("Transfer RX QuData to FIFO ... ");
	sgdma_standard_descriptor * qu_data_write_descriptor;
	qu_data_write_descriptor = (sgdma_standard_descriptor *) malloc(16);
	unsigned int *qu_data_write_address = (unsigned int *) QU_REC_DATA_MEM_ADDR;
	control = 0;
	length = DATA_LENGTH;

	construct_st_to_mm_descriptor(qu_data_write_descriptor, qu_data_write_address, length, control);
	ret = write_standard_descriptor(qu_data_write_csr_mem, qu_data_write_descriptor_mem, qu_data_write_descriptor);
	if(ret == 0) {printf("success.\n");}
	else {printf("failed.\n");return -1;}

	/********Display csr status*******/
	printf("Display CSR:\nAfter start:\nInphase ");
	csr_status_info(in_data_write_csr_mem);
	printf("Quardra \n");
	csr_status_info(qu_data_write_csr_mem);

	/********munmap*******/
	if (munmap(bridge_map, PAGE_SIZE) < 0) {
		perror("MAIN munmap");
		close(fd);
		exit(EXIT_FAILURE);
	}
	close(fd);

	printf("END\n");

	return 0;
}