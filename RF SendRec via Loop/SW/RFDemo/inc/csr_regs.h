/*
  Enhanced features off:

  Bytes     Access Type     Description
  -----     -----------     -----------
  0-3       R/Clr           Status(1)
  4-7       R/W             Control(2)
  8-12      R               Descriptor Fill Level(write fill level[15:0], read fill level[15:0])
  13-15     R               Response Fill Level[15:0]
  16-31     N/A             <Reserved>

  (1)  Writing a '1' to the interrupt bit of the status register clears the interrupt bit (when applicable), all other bits are unaffected by writes
  (2)  Writing to the software reset bit will clear the entire register (as well as all the registers for the entire SGDMA)

  Status Register:

  Bits      Description
  ----      -----------
  0         Busy
  1         Descriptor Buffer Empty
  2         Descriptor Buffer Full
  3         Response Buffer Empty
  4         Response Buffer Full
  5         Stop State
  6         Reset State
  7         Stopped on Error
  8         Stopped on Early Termination
  9         IRQ
  10-31     <Reserved>

  Control Register:

  Bits      Description
  ----      -----------
  0         Stop (will also be set if a stop on error/early termination condition occurs)
  1         Software Reset
  2         Stop on Error
  3         Stop on Early Termination
  4         Global Interrupt Enable Mask
  5         Stop dispatcher (stops the dispatcher from issuing more read/write commands)
  6-31      <Reserved>
*/

#ifndef CSR_REGS_H_
#define CSR_REGS_H_

#define CSR_STATUS_REG                          (0)
#define CSR_CONTROL_REG                         (1)
#define CSR_DESCRIPTOR_FILL_LEVEL_REG           (2)
#define CSR_RESPONSE_FILL_LEVEL_REG             (3)


// masks for the status register bits
#define CSR_BUSY_MASK                           (1)
#define CSR_BUSY_OFFSET                         (0)
#define CSR_DESCRIPTOR_BUFFER_EMPTY_MASK        (1<<1)
#define CSR_DESCRIPTOR_BUFFER_EMPTY_OFFSET      (1)
#define CSR_DESCRIPTOR_BUFFER_FULL_MASK         (1<<2)
#define CSR_DESCRIPTOR_BUFFER_FULL_OFFSET       (2)
#define CSR_RESPONSE_BUFFER_EMPTY_MASK          (1<<3)
#define CSR_RESPONSE_BUFFER_EMPTY_OFFSET        (3)
#define CSR_RESPONSE_BUFFER_FULL_MASK           (1<<4)
#define CSR_RESPONSE_BUFFER_FULL_OFFSET         (4)
#define CSR_STOP_STATE_MASK                     (1<<5)
#define CSR_STOP_STATE_OFFSET                   (5)
#define CSR_RESET_STATE_MASK                    (1<<6)
#define CSR_RESET_STATE_OFFSET                  (6)
#define CSR_STOPPED_ON_ERROR_MASK               (1<<7)
#define CSR_STOPPED_ON_ERROR_OFFSET             (7)
#define CSR_STOPPED_ON_EARLY_TERMINATION_MASK   (1<<8)
#define CSR_STOPPED_ON_EARLY_TERMINATION_OFFSET (8)
#define CSR_IRQ_SET_MASK                        (1<<9)
#define CSR_IRQ_SET_OFFSET                      (9)

// masks for the control register bits
#define CSR_STOP_MASK                           (1)
#define CSR_STOP_OFFSET                         (0)
#define CSR_RESET_MASK                          (1<<1)
#define CSR_RESET_OFFSET                        (1)
#define CSR_STOP_ON_ERROR_MASK                  (1<<2)
#define CSR_STOP_ON_ERROR_OFFSET                (2)
#define CSR_STOP_ON_EARLY_TERMINATION_MASK      (1<<3)
#define CSR_STOP_ON_EARLY_TERMINATION_OFFSET    (3)
#define CSR_GLOBAL_INTERRUPT_MASK               (1<<4)
#define CSR_GLOBAL_INTERRUPT_OFFSET             (4)
#define CSR_STOP_DESCRIPTORS_MASK               (1<<5)
#define CSR_STOP_DESCRIPTORS_OFFSET             (5)

// masks for the FIFO fill levels and sequence number
#define CSR_READ_FILL_LEVEL_MASK                (0xFFFF)
#define CSR_READ_FILL_LEVEL_OFFSET              (0)
#define CSR_WRITE_FILL_LEVEL_MASK               (0xFFFF0000)
#define CSR_WRITE_FILL_LEVEL_OFFSET             (16)
#define CSR_RESPONSE_FILL_LEVEL_MASK            (0xFFFF)
#define CSR_RESPONSE_FILL_LEVEL_OFFSET          (0)
#define CSR_READ_SEQUENCE_NUMBER_MASK           (0xFFFF)
#define CSR_READ_SEQUENCE_NUMBER_OFFSET         (0)
#define CSR_WRITE_SEQUENCE_NUMBER_MASK          (0xFFFF0000)
#define CSR_WRITE_SEQUENCE_NUMBER_OFFSET        (16)


#endif /*CSR_REGS_H_*/
