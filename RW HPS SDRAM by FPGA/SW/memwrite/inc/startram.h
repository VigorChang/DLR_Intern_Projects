#ifndef STARTRAM_H_
#define STARTRAM_H_

#define SDRAM_CONTROLLER_BASE 0xFFC25000
#define RST_OFFSET 0x80
#define CFG_OFFSET 0x7c
#define DEFAULT_OFFSET 0x8c

int startram();

#endif