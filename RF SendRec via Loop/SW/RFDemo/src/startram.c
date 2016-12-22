#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include "startram.h"

#define PAGE_SIZE 4096

volatile unsigned int *rst_mem;
volatile unsigned int *cfg_mem;
volatile unsigned int *portdefault_mem;
void *sdramctrl_map;

int startram()
{
	int fd, ret = EXIT_FAILURE;
	//unsigned char value;
	off_t sdramctrl_base = SDRAM_CONTROLLER_BASE;
	
	printf("STARTRAM Start\n");

	/* open the memory device file */
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("STARTRAM open");
		exit(EXIT_FAILURE);
	}

	/* map the LWHPS2FPGA bridge into process memory */
	sdramctrl_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, sdramctrl_base);
	if (sdramctrl_map == MAP_FAILED) {
		perror("STARTRAM mmap");
		goto cleanup;
	}

	/* get the delay_ctrl peripheral's base address */
	rst_mem = (unsigned int *) (sdramctrl_map + RST_OFFSET);
	cfg_mem = (unsigned int *) (sdramctrl_map + CFG_OFFSET);
	portdefault_mem = (unsigned int *) (sdramctrl_map + DEFAULT_OFFSET);

	/* write the value */
	*rst_mem = 0x00003FFF;
	*cfg_mem = 0x00000000;
	*portdefault_mem = 0x00000000;
	unsigned int rst_content,cfg_content,portdefault_content;
	rst_content = *rst_mem;
	cfg_content = *cfg_mem;
	portdefault_content = *portdefault_mem;
	printf("STARTRAM RST: 0x%08x  CFG: 0x%08x DEFAULT: 0x%08x\n",rst_content,cfg_content,portdefault_content);

	
	if (munmap(sdramctrl_map, PAGE_SIZE) < 0) {
		perror("STARTRAM munmap");
		goto cleanup;
	}

	ret = 0;

	printf("STARTRAM End\n");

cleanup:
	close(fd);
	return ret;
}