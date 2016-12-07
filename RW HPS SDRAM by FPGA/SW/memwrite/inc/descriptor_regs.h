/*
  Descriptor formats:

  Standard Format:
  
  Offset         |             3                 2                 1                   0
  --------------------------------------------------------------------------------------
   0x0           |                              Read Address[31..0]
   0x4           |                              Write Address[31..0]
   0x8           |                                Length[31..0]
   0xC           |                                Control[31..0]


*/


#ifndef DESCRIPTOR_REGS_H_
#define DESCRIPTOR_REGS_H_

#define DESCRIPTOR_READ_ADDRESS_REG                      (0)
#define DESCRIPTOR_WRITE_ADDRESS_REG                     (1)
#define DESCRIPTOR_LENGTH_REG                            (2)
#define DESCRIPTOR_CONTROL_STANDARD_REG                  (3)

// masks and offsets for the bits in the descriptor control field
#define DESCRIPTOR_CONTROL_TRANSMIT_CHANNEL_MASK         (0xFF)
#define DESCRIPTOR_CONTROL_TRANSMIT_CHANNEL_OFFSET       (0)
#define DESCRIPTOR_CONTROL_GENERATE_SOP_MASK             (1<<8)
#define DESCRIPTOR_CONTROL_GENERATE_SOP_OFFSET           (8)
#define DESCRIPTOR_CONTROL_GENERATE_EOP_MASK             (1<<9)
#define DESCRIPTOR_CONTROL_GENERATE_EOP_OFFSET           (9)
#define DESCRIPTOR_CONTROL_PARK_READS_MASK               (1<<10)
#define DESCRIPTOR_CONTROL_PARK_READS_OFFSET             (10)
#define DESCRIPTOR_CONTROL_PARK_WRITES_MASK              (1<<11)
#define DESCRIPTOR_CONTROL_PARK_WRITES_OFFSET            (11)
#define DESCRIPTOR_CONTROL_END_ON_EOP_MASK               (1<<12)
#define DESCRIPTOR_CONTROL_END_ON_EOP_OFFSET             (12)
#define DESCRIPTOR_CONTROL_TRANSFER_COMPLETE_IRQ_MASK    (1<<14)
#define DESCRIPTOR_CONTROL_TRANSFER_COMPLETE_IRQ_OFFSET  (14)
#define DESCRIPTOR_CONTROL_EARLY_TERMINATION_IRQ_MASK    (1<<15)
#define DESCRIPTOR_CONTROL_EARLY_TERMINATION_IRQ_OFFSET  (15)
#define DESCRIPTOR_CONTROL_ERROR_IRQ_MASK                (0xFF<<16)  // the read master will use this as the transmit error, the dispatcher will use this to generate an interrupt if any of the error bits are asserted by the write master
#define DESCRIPTOR_CONTROL_ERROR_IRQ_OFFSET              (16)
#define DESCRIPTOR_CONTROL_EARLY_DONE_ENABLE_MASK        (1<<24)
#define DESCRIPTOR_CONTROL_EARLY_DONE_ENABLE_OFFSET      (24)
#define DESCRIPTOR_CONTROL_GO_MASK                       (1<<31)  // at a minimum you always have to write '1' to this bit as it commits the descriptor to the dispatcher
#define DESCRIPTOR_CONTROL_GO_OFFSET                     (31)


#endif /*DESCRIPTOR_REGS_H_*/
