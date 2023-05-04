#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    unsigned v = (*reg & 1) ^ (*reg & (1 << 2)) >> 2 ^
    (*reg & (1 << 3)) >> 3 ^ (*reg & (1 << 5)) >> 5;
    (*reg) >>= 1;
    (*reg) |= (v << 15);
}

