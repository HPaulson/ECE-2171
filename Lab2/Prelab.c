#include "address_map_arm.h"

int main(void) {
    /*1.) The value of LED_BASE comes from address_map_arm.h. Open address_map_arm.h 
    and determine the value of LED_BASE. Where does this value come from?*/
    volatile int *LED_ptr = (int *) LED_BASE;

    /* 2.) What does the following line of code do? What do you expect to see happen on the LEDs?
    How do you know what bits correspond to what LED?*/
    *LED_ptr = 0xF;

    volatile int delay_count; // volatile so the C compiler doesn't remove the loop

    //Run forever
    while(1) {
        
        /* 3.) When is x non-zero? What possible values can x take? */
        int x = *LED_ptr & 0x01;

        /* 4.) When would the code in the if statement execute? */
        if (x == 0x01)
        {
            /* 5.) What effect does this line of code have? */
            *LED_ptr ^= 0x40;
        }

        //Delay so your eyes can see change
        for (delay_count = 350000; delay_count != 0; --delay_count); // delay loop
    }
}