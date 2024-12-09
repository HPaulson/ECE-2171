#include "address_map_arm.h"
#include "interrupt_ID.h"
#include "defines.h"

void disable_A9_interrupts (void);
void set_A9_IRQ_stack (void);
void config_interrupt (int, int);
void config_GIC (void);
void config_KEYs (void);
void enable_A9_interrupts (void);

/* ********************************************************************************
 * This program demonstrates use of interrupts with C code.  The program responds 
 * to interrupts from the pushbutton KEY port in the FPGA.
 *
 * The interrupt service routine for the KEYs indicates which KEY has been pressed
 * on the display HEX0.
 ********************************************************************************/
volatile int* LED_PTR = (int*) LEDR_BASE;
int counter = 0;
int direction = 1;
int run = 1;
int display = 1;
int KEY_num = 0;

int main(void)
{
	disable_A9_interrupts();	// disable interrupts in the A9 processor
	set_A9_IRQ_stack();			// initialize the stack pointer for IRQ mode
	config_interrupt(KEYS_IRQ, CPU0); 	// configure the FPGA KEYs interrupt
	config_GIC();					// configure the general interrupt controller
	config_KEYs();				// configure pushbutton KEYs to generate interrupts

	enable_A9_interrupts ();	// enable interrupts in the A9 processor

	while (1) 	{					// wait for an interrupt
       switch (KEY_num) {
       case 0:
       	if (!run) continue;
        else {
        	        
        if (direction) {
        	counter++;
            if (counter == 0x3FF) counter = 0;
        }
        else {
        	counter--;
            if (counter == 0) counter = 0x3FF;
        }
        }
        break;
       case 1: 
        display = 1;
       	counter = direction ? 0x3FF : 0;
        break;
       case 2:
        display = 1;
       	run = !run;
        break;
       case 3:
        display = 1;
       	direction = !direction;
        break;
       case 4: 
       	display = 0;
        break;
}
       KEY_num = 0; // Always go back to running counter
       *LED_PTR = display ? counter : 0;
       printf("%d %d\n", counter, *LED_PTR);
		/*
        int i = 0;
        while (i < 100) {
        i++;
        }
        */
}
}

/* setup the KEY interrupts in the FPGA */
void config_KEYs()
{
	volatile int * KEY_ptr = (int *) KEY_BASE;	// pushbutton KEY base address

	*(KEY_ptr + 2) = 0xF; 	// enable interrupts for all four KEYs
}


/****************************************************************************************
 * Pushbutton - Interrupt Service Routine                                
 *                                                                          
 * This routine checks which KEY has been pressed. It writes to HEX0
 ***************************************************************************************/
void pushbutton_ISR( void )
{
	volatile int * KEY_ptr = (int *) KEY_BASE;
	volatile int * HEX3_HEX0_ptr = (int *) HEX3_HEX0_BASE;
	int press, HEX_bits;

	press = *(KEY_ptr + 3);					// read the pushbutton interrupt register
	*(KEY_ptr + 3) = press;					// Clear the interrupt

	if (press & 0x1) {					// KEY0
		HEX_bits = 0b00111111;
        KEY_num = 1;
    }
	else if (press & 0x2){					// KEY1
		HEX_bits = 0b00000110;
        KEY_num = 2;
    }
	else if (press & 0x4) {					// KEY2
		HEX_bits = 0b01011011;
        KEY_num = 3;
    }
	else { 											// press & 0x8, which is KEY3
		HEX_bits = 0b01001111;
        KEY_num = 4;
	}
	*HEX3_HEX0_ptr = HEX_bits;
	return;
}