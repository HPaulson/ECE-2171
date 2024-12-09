// Lab 2 part 3 Hunter Paulson ECE 2171
#include "address_map_arm.h"
#include "stdio.h"
/* This program demonstrates use of parallel ports in the Computer System
 *
 * It performs the following:
 *  1. Tunrs on one led at a time, sweeps them, and changes direction
*/
int main(void) {
    /* Declare volatile pointers to I/O registers (volatile means that IO load
     * and store instructions will be used to access these pointer locations,
     * instead of regular memory loads and stores)
    */
    volatile int * LED_ptr       = (int *)LED_BASE; // LED address

    int LED_BITS = 0x00000001; // pattern for LED lights
    int direction = 0;
    volatile int
        delay_count; // volatile so the C compiler doesn't remove the loop
	printf("\n\nHunter Paulson");
    while (1) {
    	if (LED_BITS == 0x00000200) direction = 1;
        else if (LED_BITS == 0x00000001) direction = 0;
    	if (direction == 0){
   			LED_BITS = LED_BITS << 1;
    	}
    	else if (direction == 1){
   			LED_BITS = LED_BITS >> 1;
    	}

    	*(LED_ptr) = LED_BITS;
    	for (delay_count = 1000000; delay_count != 0; --delay_count);
      }
    }
