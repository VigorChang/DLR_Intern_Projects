#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#define PAGE_SIZE 8192//4096
#define INPHASE_ADD 0x30000000
#define QUARDRA_ADD 0x31000000

volatile unsigned int *mem;
void *mem_map;

int main(int argc, char *argv[])
{
	printf("Start.\n");
	//Defination
	unsigned int in_addr,qu_addr;
	int fd, ret = EXIT_FAILURE;
	off_t mem_base;
	int i;
	unsigned int content;
	unsigned int * addr;
	//Value
	in_addr = INPHASE_ADD;
	qu_addr = QUARDRA_ADD;

	/******Write Inphase Data to File******/
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
	FILE * InphaseDataFile;
	if((InphaseDataFile = fopen("recInData.txt","w+"))==NULL)
	{
		printf("Cannot open the inphase data file.\n");
		return -1;
	}
	for(i = 0;i < 2048;i++)
	{
		unsigned short one, two;
		short sone, stwo;
		float fone,ftwo;
		addr = (unsigned int *)(mem_map+i*4);
		content = *addr;
		two = (unsigned short) (content/(256*256));
		one = (unsigned short) (content%(256*256));
		sone = (short) one;
		stwo = (short) two;
		fone = (float)sone/(16*2047);
		ftwo = (float)stwo/(16*2047);
		fprintf(InphaseDataFile,"%f, %f, ",fone,ftwo);
	}
	fclose(InphaseDataFile);

	//Unmap
	if (munmap(mem_map, PAGE_SIZE) < 0) {
		perror("inphase munmap");
		goto cleanup;
	}

	/******Write Quardra Data to File******/
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
	FILE * QuardraDataFile;
	if((QuardraDataFile = fopen("recQuData.txt","w+"))==NULL)
	{
		printf("Cannot open the quardra data file.\n");
		return -1;
	}
	for(i = 0;i < 2048;i++)
	{
		unsigned short one, two;
		short sone, stwo;
		float fone,ftwo;
		addr = (unsigned int *)(mem_map+i*4);
		content = *addr;
		two = (unsigned short) (content/(256*256));
		one = (unsigned short) (content%(256*256));
		sone = (short) one;
		stwo = (short) two;
		fone = (float)sone/(16*2047);
		ftwo = (float)stwo/(16*2047);
		fprintf(QuardraDataFile,"%f, %f, ",fone,ftwo);
		*addr = content;
	}
	fclose(QuardraDataFile);

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
