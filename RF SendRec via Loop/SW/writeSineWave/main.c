#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#define PAGE_SIZE 4096
#define INPHASE_ADD 0x28000000
#define QUARDRA_ADD 0x29000000

const short sineWave[] = {0x0000,0x30F0,0x5A70,0x7630,
                          0x7FF0,0x7630,0x5A70,0x30F0,
                          0x0000,0xCF10,0xA590,0x89D0,
                          0x8010,0x89D0,0xA590,0xCF10};

volatile unsigned int *mem;
void *mem_map;

int main(int argc, char *argv[])
{
	printf("Start.\n");
	//Defination
	unsigned int in_addr,qu_addr;
	int fd, ret = EXIT_FAILURE;
	off_t mem_base;
	int i,tag;
	short one,two;
	unsigned int content;
	unsigned int * addr;
	//Value
	in_addr = INPHASE_ADD;
	qu_addr = QUARDRA_ADD;

	/******Write Inphase Data******/
	mem_base = (off_t)in_addr;
	//Open the memory device file
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("inphase open");
		exit(EXIT_FAILURE);
	}
	//Map memory to file
	mem_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, mem_base);
	if (mem_map == MAP_FAILED) {
		perror("inphase mmap");
		goto cleanup;
	}
	//Get address
	mem = (unsigned int *) (mem_map);
	//Start write memeory
	printf("Inphase data writing start.\n");
	for(i=0;i<512;i++)
	{
		tag = i%8;
		one = sineWave[tag*2];
		two = sineWave[tag*2+1];
		content = (two << 16) + one;
		addr = (unsigned int *)(mem_map+i*4);
		*addr = content;
	}
	//Unmap
	if (munmap(mem_map, PAGE_SIZE) < 0) {
		perror("inphase munmap");
		goto cleanup;
	}

	/******Write Quardra Data******/
	mem_base = (off_t)qu_addr;
	//Map memory to file
	mem_map = mmap(NULL, PAGE_SIZE, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, mem_base);
	if (mem_map == MAP_FAILED) {
		perror("quardra mmap");
		goto cleanup;
	}
	//Get address
	mem = (unsigned int *) (mem_map);
	//Start write memeory
	printf("Quardra data writing start.\n");
	for(i=0;i<512;i++)
	{
		tag = i%8;
		one = sineWave[tag*2];
		two = sineWave[tag*2+1];
		content = (two << 16) + one;
		addr = (unsigned int *)(mem_map+i*4);
		*addr = content;
	}
	//Unmap
	if (munmap(mem_map, PAGE_SIZE) < 0) {
		perror("quardra munmap");
		goto cleanup;
	}

	ret = 0;

cleanup:
	close(fd);
	return ret;
}
