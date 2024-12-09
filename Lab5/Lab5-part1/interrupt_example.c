// Hunter Paulson
// ECE 2171 - Lab 5 part 1
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
int blink = 1;
int reset = 0;

/* setup HPS timer */
void config_HPS_timer()
{
volatile int * HPS_timer_ptr = (int *)HPS_TIMER0_BASE; // timer base address
	*(HPS_timer_ptr + 0x2) = 0; // write to control register to stop timer
	/* set the timer period */
	int counter = 25000000; // period = 1/(100 MHz) x (100 x 10^6) = 1 sec
	*(HPS_timer_ptr) = counter; // write to timer load register
	/* write to control register to start timer, with interrupts */
	*(HPS_timer_ptr + 2) = 0b011; // int mask = 0, mode = 1, enable = 1
}


/* setup the KEY interrupts in the FPGA */
void config_KEYs()
{
	volatile int * KEY_ptr = (int *) KEY_BASE;	// pushbutton KEY base address

	*(KEY_ptr + 2) = 0xF; 	// enable interrupts for all four KEYs
}


int main(void)
{
	printf("main1\n");
	disable_A9_interrupts();	// disable interrupts in the A9 processor
	set_A9_IRQ_stack();			// initialize the stack pointer for IRQ mode
	config_interrupt(KEYS_IRQ, CPU0); 	// configure the FPGA KEYs interrupt
	config_interrupt(HPS_TIMER0_IRQ, CPU0);
    config_GIC();					// configure the general interrupt controller
	config_KEYs();				// configure pushbutton KEYs to generate interrupts
	config_HPS_timer();
	enable_A9_interrupts ();	// enable interrupts in the A9 processor

	while(1) {
   		printf("while\n");
    	*LED_PTR = blink ? counter : 0;
    }
}

void HPS_timer_ISR() {
	volatile int* HSPTimer0_ptr = (volatile int*) HPS_TIMER0_BASE;
    // Clear the interrupt
    *(HSPTimer0_ptr + 3);
	if (reset) {
        // Reset counter to 0 or 0x3ff based on direction
    	counter = direction ? 0x3FF : 0;
        reset = 0;      
    }
    if (run) {
    	// If running. inc/dec counter appropriately
		direction ? --counter : ++counter;    
    }
    // Reset counter if it hits max
    if (counter == 0x3FF) counter = 0;
    if (counter == 0) counter = 0x3FF;
}

void pushbutton_ISR( void )
{
	volatile int * KEY_ptr = (int *) KEY_BASE;
	volatile int * HEX3_HEX0_ptr = (int *) HEX3_HEX0_BASE;
	int press, HEX_bits;

	press = *(KEY_ptr + 3);					// read the pushbutton interrupt register
	*(KEY_ptr + 3) = press;					// Clear the interrupt

	// Sets apropriate global then sets hex display to button's number
	if (press & 0x1) {					// KEY0
    	reset = 1;
		HEX_bits = 0b00111111;
    }
	else if (press & 0x2){					// KEY1
    	run = !run;
		HEX_bits = 0b00000110;
    }
	else if (press & 0x4) {					// KEY2
   		direction = !direction;
		HEX_bits = 0b01011011;
    }
	else { 											// press & 0x8, which is KEY3
		blink = !blink;
        HEX_bits = 0b01001111;
	}
	*HEX3_HEX0_ptr = HEX_bits;
	return;
}
