#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#define PAGE_SIZE 4096
#define SDRAM_CONTROLLER_BASE 0xFFC25000
#define RST_OFFSET 0x80
#define CFG_OFFSET 0x7c
#define DEFAULT_OFFSET 0x8c

volatile unsigned int *rst_mem;
volatile unsigned int *cfg_mem;
volatile unsigned int *portdefault_mem;
void *sdramctrl_map;

int main(int argc, char *argv[])
{
	int fd, ret = EXIT_FAILURE;
	//unsigned char value;
	off_t sdramctrl_base = SDRAM_CONTROLLER_BASE;
	
	printf("Start. Version 2\n");

	/* open the memory device file */
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("open");
		exit(EXIT_FAILURE);
	}

	/* map the LWHPS2FPGA bridge into process memory */
	sdramctrl_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, sdramctrl_base);
	if (sdramctrl_map == MAP_FAILED) {
		perror("mmap");
		goto cleanup;
	}

	/* get the delay_ctrl peripheral's base address */
	rst_mem = (unsigned int *) (sdramctrl_map + RST_OFFSET);
	cfg_mem = (unsigned int *) (sdramctrl_map + CFG_OFFSET);
	portdefault_mem = (unsigned int *) (sdramctrl_map + DEFAULT_OFFSET);

	//input flag number
	unsigned int rst_content,cfg_content,portdefault_content;
	printf("rst:\n");
	scanf("%x",&rst_content);
	printf("cfg:\n");
	scanf("%x",&cfg_content);
	printf("portdefault:\n");
	scanf("%x",&portdefault_content);
	/* write the value */
	*rst_mem = rst_content;
	*cfg_mem = cfg_content;
	*portdefault_mem = portdefault_content;
	
	rst_content = *rst_mem;
	cfg_content = *cfg_mem;
	portdefault_content = *portdefault_mem;
	printf("Display. rst: 0x%08x  cfg: 0x%08x default: 0x%08x\n",rst_content,cfg_content,portdefault_content);

	
	if (munmap(sdramctrl_map, PAGE_SIZE) < 0) {
		perror("munmap");
		goto cleanup;
	}

	ret = 0;

cleanup:
	close(fd);
	return ret;
}
