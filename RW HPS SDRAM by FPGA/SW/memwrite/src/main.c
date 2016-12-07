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
#define WRITE_CSR_OFFSET 0x100
#define WRITE_DESCRIPTOR_OFFSET 0x200
#define READ_CSR_OFFSET 0x300
#define READ_DESCRIPTOR_OFFSET 0x400

#define PAGE_SIZE 4096

unsigned int *write_csr_mem;
unsigned int *read_csr_mem;
unsigned int *write_descriptor_mem;
unsigned int *read_descriptor_mem;
void *bridge_map;

int main(int argc, char *argv[])
{
	printf("MAIN Start Version 13\n\n");
	int ret;
	int read_number,write_number;
	printf("Input the read number(<256):\n");
	scanf("%d",&read_number);
	printf("Input the write number(<256):\n");
	scanf("%d",&write_number);
	/***********RAM Start*************/
	/*ret=startram();
	if(ret == 0) {printf("RAM Start success.\n\n");}
	else {printf("RAM Start failed.\n\n");return -1;}*/

	/********mmap********/
	printf("MAIN mmap start\n");
	int fd;
	ret = EXIT_FAILURE;
	off_t bridge = BRIDGE_BASE;

	/* open the memory device file */
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("MAIN open");
		exit(EXIT_FAILURE);
	}

	/* map the LWHPS2FPGA bridge into process memory */
	bridge_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, bridge);
	if (bridge_map == MAP_FAILED) {
		perror("MAIN mmap");
		close(fd);
		exit(EXIT_FAILURE);
	}
	printf("Bridge base address: 0x%08x\n",(unsigned int)bridge_map);

	/* get csr and descriptor address */
	write_csr_mem = (unsigned int *) (bridge_map + WRITE_CSR_OFFSET);
	write_descriptor_mem = (unsigned int *) (bridge_map + WRITE_DESCRIPTOR_OFFSET);
	read_csr_mem = (unsigned int *) (bridge_map + READ_CSR_OFFSET);
	read_descriptor_mem = (unsigned int *) (bridge_map + READ_DESCRIPTOR_OFFSET);

	printf("MAIN mmap end\n\n");

	/*******reset dispatcher*******/
	int smallDelay;
	rst_dispatcher(write_csr_mem);
	smallDelay = 1000;
	while(smallDelay--){}
	rst_dispatcher(read_csr_mem);
	smallDelay = 1000;
	while(smallDelay--){}

	csr_status_info(write_csr_mem);
	csr_status_info(read_csr_mem);

	/**********READ PART**********/
	printf("\nREAD start\n");

	sgdma_standard_descriptor * read_descriptor;
	read_descriptor = (sgdma_standard_descriptor *) malloc(16);
	unsigned int *read_address = (unsigned int *)0x30000000;
	unsigned int length;
	unsigned int control = 0;
	length = (unsigned int) read_number;

	construct_mm_to_st_descriptor(read_descriptor, read_address, length, control);

	ret = write_standard_descriptor(read_csr_mem, read_descriptor_mem, read_descriptor);
	if(ret == 0) {printf("READ success.\n");}
	else {printf("READ failed.\n");return -1;}

	printf("READ end\n\n");

	/*******WRITE PART*******/
	printf("WRITE start\n");
	sgdma_standard_descriptor * write_descriptor;
	write_descriptor = (sgdma_standard_descriptor *) malloc(16);
	unsigned int *write_address = (unsigned int *)0x28000000;
	length = (unsigned int) write_number;
	control = 0;

	construct_st_to_mm_descriptor(write_descriptor, write_address, length, control);

	ret = write_standard_descriptor(write_csr_mem, write_descriptor_mem, write_descriptor);
	if(ret == 0) {printf("WRITE success.\n");}
	else {printf("WRITE failed.\n");return -1;}

	printf("WRITE end\n\n");

	/********Display csr status*******/
	csr_status_info(write_csr_mem);
	csr_status_info(read_csr_mem);

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