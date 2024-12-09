/********************************************************************************************
*  Lab 6 Template 
*  Hunter Paulsom
*  This template provides only a basic program structure for your reference;
*  Fill in your code throughout the entire program in appropriate places 
*  to finish the Lab 6 requirements.
*********************************************************************************************/

#include "address_map_arm.h"
#define MAX_SIZE 1000
#define ENTER_KEY 0xA
#define ESCAPE_KEY 27

/*******************************************************************************
 * This program demonstrates use of the JTAG UART port
 *
 * It performs the following:
 *	1. Gets a text string from the JTAG UART
 * 	2. Extracts the digits in the string and saves them to an array
 * 	3. Echos the digit characters back to the JTAG UART
 ******************************************************************************/
/* function prototypes */
char get_jtag(volatile int*);
void put_jtag(volatile int*, char);
void put_string(char*);
//void wait_for_char(volatile int*, char);

// State machine type; You may add/remove states as needed
typedef enum {
	IDLE,		
    START,		
    ENTER,
    PRINT
} jtag_states;
 
 
int main(void) {
    put_string("\nLab6 by Hunter Paulson \n");
    /* Declare variables and volatile pointers to I/O registers */
    volatile int* JTAG_UART_ptr = (int*) JTAG_UART_BASE;
    jtag_states state = IDLE; 		//defines a state variable and assigns the first state
    char c;							//character read from JTAG
   	char digit[MAX_SIZE];
   	int size = 0;

    while (1) {
        c = get_jtag(JTAG_UART_ptr);
        //The commnets are suggestions only; It is up to you how to use these states below
        switch(state){		//in each state, use a switch (c) to take care of different cases. 
            case IDLE: {	
                //Tell the user to press ESC to start typing a string
                //other work you may want it to do here
                //move on to the next state
                put_string("Press Esc to start:\n");
                state = START;
                break;
                
            }
            case START:{
                //Tell the user to type in a string, followed by Enter:
                //Wait for ESC; enter next state when received;
                //other work you may want it to do here;
                //move on to the next state;
                if (c == '\0') break;
                if (c != ESCAPE_KEY) break;
                put_string("Enter a string, then press [ENTER].\n");
                state = ENTER;
                break;
            }
            case ENTER:{
     			//Process the string the user typed in
                //Check for Enter; (end of string)
				//other work you may want it to do here
                //move on to the next state
            	if (c == '\0') break;
                put_jtag(JTAG_UART_ptr, c);
                if (c == ENTER_KEY) {
              		state = PRINT;
                	break;
                }
                else if (0x30 <= c && c <= (9 + 0x30)) {
                    	 digit[size] = c;
                         size++;
                     }
                break;
            }            
                
            case PRINT: {
                
            	int i = 0;
                while(i < size) {
                	char x = digit[i];
                	put_jtag(JTAG_UART_ptr, x);
                    *(digit + i) = 0; // reset array
                    ++i;
                }
                size = 0;
                state = IDLE;
                put_jtag(JTAG_UART_ptr, '\n');
               
                break;
        }
    }
    }
}

char get_jtag(volatile int* JTAG_UART_PTR) {
	int data = *JTAG_UART_PTR;
    if (data & 0x00008000) {
    	return (char)data & 0xFF;
    }
    else {
    	return '\0';
    }
}

void put_jtag(volatile int* JTAG_UART_PTR, char c) {
	int control = *(JTAG_UART_PTR + 1);
    if (control & 0xFFFF0000) *JTAG_UART_PTR = c;
}

void put_string(char* string) {
    volatile int* JTAG_UART_ptr = (int*) JTAG_UART_BASE;
	char* c_ptr = string;
    while (*c_ptr != '\0') {
    	put_jtag(JTAG_UART_ptr, *c_ptr);
        c_ptr++;
    }
}
/*
void wait_for_char(volatile int* JTAG_UART_PTR, char c) {
	int run = 1;
	while (run) {
		int found = get_jtag(JTAG_UART_PTR);
		if (found == c) run = 0;
    }
    return
}
*/
