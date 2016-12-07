#ifndef SGDMA_DISPATCHER_H_
#define SGDMA_DISPATCHER_H_

typedef struct {
  unsigned int *read_address;
  unsigned int *write_address;
  unsigned int transfer_length;
  unsigned int control;
} sgdma_standard_descriptor;

//Construct the st to mm (write) descriptor
int construct_st_to_mm_descriptor(sgdma_standard_descriptor *descriptor, unsigned int *write_address, unsigned int length, unsigned int control);
//Construct the mm to st (read) descriptor
int construct_mm_to_st_descriptor(sgdma_standard_descriptor *descriptor, unsigned int *read_address, unsigned int length, unsigned int control);

//Write descriptor
int write_standard_descriptor(unsigned int *csr_mem, unsigned int *descriptor_mem, sgdma_standard_descriptor *descriptor);

//Print csr status register
unsigned int csr_status_info(unsigned int *csr_mem);

//Reset the dispatcher
void rst_dispatcher(unsigned int *csr_mem);


#endif