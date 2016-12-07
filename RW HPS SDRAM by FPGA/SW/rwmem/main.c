#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#define PAGE_SIZE 4096

volatile unsigned int *mem;
void *mem_map;

int main(int argc, char *argv[])
{
	printf("Start.\n");
	unsigned int start_address;
	unsigned int content;
	int rw,number;
	printf("Start address:\n");
	scanf("%x",&start_address);
	printf("Read(1) or write(0)?\n");
	scanf("%d",&rw);
	printf("Number?\n");
	scanf("%d",&number);

	int fd, ret = EXIT_FAILURE;
	//unsigned char value;
	off_t mem_base = (off_t)start_address;

	/* open the memory device file */
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("open");
		exit(EXIT_FAILURE);
	}

	/* map the LWHPS2FPGA bridge into process memory */
	mem_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, mem_base);
	if (mem_map == MAP_FAILED) {
		perror("mmap");
		goto cleanup;
	}

	/* get the delay_ctrl peripheral's base address */
	mem = (unsigned int *) (mem_map);

	/* show the value */
	printf("Start address is 0x%08x\n",(unsigned int)mem_base);
	int i;
	unsigned int * addr;
	if(rw==1)
	{	
		for(i=0;i<number;i++)
		{
			addr = (unsigned int *)(mem_map+i*4);
			content = *addr;
			printf("No. %02d : 0x%08x\n",i,content);
		}
	}
	if(rw==0)
	{
		for(i=0;i<number;i++)
		{
			addr = (unsigned int *)(mem_map+i*4);
			*addr = (unsigned int) (i+100);
		}
	}
	
	if (munmap(mem_map, PAGE_SIZE) < 0) {
		perror("munmap");
		goto cleanup;
	}

	ret = 0;

cleanup:
	close(fd);
	return ret;
}
