#include "descriptor_regs.h"
#include "csr_regs.h"
#include "sgdma_dispatcher.h"

#include <stdio.h>

int construct_st_to_mm_descriptor(sgdma_standard_descriptor *descriptor, unsigned int *write_address, unsigned int length, unsigned int control)
{
	descriptor->read_address = 0;
	descriptor->write_address = write_address;
	descriptor->transfer_length = length;
	descriptor->control = control | DESCRIPTOR_CONTROL_GO_MASK;

	return 0;
}

int construct_mm_to_st_descriptor(sgdma_standard_descriptor *descriptor, unsigned int *read_address, unsigned int length, unsigned int control)
{
	descriptor->read_address = read_address;
	descriptor->write_address = 0;
	descriptor->transfer_length = length;
	descriptor->control = control | DESCRIPTOR_CONTROL_GO_MASK;

	return 0;
}

int write_standard_descriptor (unsigned int *csr_mem, unsigned int *descriptor_mem, sgdma_standard_descriptor *descriptor)
{
	unsigned int csr_status;
	csr_status = *(csr_mem+CSR_STATUS_REG);
	if((csr_status & CSR_DESCRIPTOR_BUFFER_FULL_MASK) != 0)
	{
		printf("The FIFO of descriptor is full.\n");
		return -1;
	}

	unsigned int * addr;

	addr = (unsigned int *) (descriptor_mem + DESCRIPTOR_READ_ADDRESS_REG);
	*addr = (unsigned int) descriptor->read_address;
	//printf("WRITE DISCRIPTOR read address: addr: 0x%08x, content: 0x%08x\n",(unsigned int)addr,(unsigned int)descriptor->read_address);

	addr = (unsigned int *) (descriptor_mem + DESCRIPTOR_WRITE_ADDRESS_REG);
	*addr = (unsigned int) descriptor->write_address;
	//printf("WRITE DISCRIPTOR write address: addr: 0x%08x, content: 0x%08x\n",(unsigned int)addr,(unsigned int)descriptor->write_address);

	addr = (unsigned int *) (descriptor_mem + DESCRIPTOR_LENGTH_REG);
	*addr = (unsigned int) descriptor->transfer_length;
	//printf("WRITE DISCRIPTOR length: addr: 0x%08x, content: 0x%08x\n",(unsigned int)addr,(unsigned int)descriptor->transfer_length);

	addr = (unsigned int *) (descriptor_mem + DESCRIPTOR_CONTROL_STANDARD_REG);
	*addr = (unsigned int) descriptor->control;
	//printf("WRITE DISCRIPTOR control: addr: 0x%08x, content: 0x%08x\n",(unsigned int)addr,(unsigned int)descriptor->control);

	return 0;
}

unsigned int csr_status_info(unsigned int *csr_mem)
{
	unsigned int csr_status;
	csr_status = *(csr_mem+CSR_STATUS_REG);
	printf("csr: 0x%08x\n", csr_status);
	return csr_status;
}

void rst_dispatcher(unsigned int *csr_mem)
{
	unsigned int csr_control_content = 0x2;
	unsigned int *csr_control_addr;
	csr_control_addr = (unsigned int *) (csr_mem + CSR_CONTROL_REG);
	*csr_control_addr = csr_control_content;
	//printf("\nRESET: addr: 0x%08x, content: 0x%08x\n",(unsigned int)csr_control_addr,(unsigned int)csr_control_content);
}