// Hunter Paulson ECE 2171
/* ********************************************************************************
 * ECE 2045 Lab 3 Part3 Template 
 * This program displays a decimal digit on the 7-segment display HEX0. 
 * Pressing a KEY has the following result:
 * 	KEY 0. sets the display to 0
 * 	KEY 1. increments the displayed number
 * 	KEY 2. decrements the displayed number
 * 	KEY 3. sets the display to be "blank"
 ********************************************************************************/
.include    "address_map_arm.s" 

		.text
		.global	_start
_start:		
	//Places the immediate value 0 into register R4
	MOV		R4, #0
	//Loads the immediate value of KEY_BASE (0xFF200050) into R5
	LDR		R5, =KEY_BASE	// base address of KEY pushbuttons
	//Loads the immediate value of HEX3_HEX0_BASE (0xFF200020) into R6
	LDR		R6, =HEX3_HEX0_BASE	// base address of HEX3_HEX0 7-segs
	//Stores the value in R4 (0) at the address of R6 (HEX3_HEX0_BASE)
	//Results in the HEX3_HEX0_BASE register being set to 0, HEX displays are now cleared or blank
	STR		R4, [R6]	// clear the display

MAIN_LOOP:
    B KEY0 // Start at key0
    
KEY0:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR	R1, [R5]
	// R1 = R1 & 0x1 (AND the value from the KEY register with 1 to isolate the KEY0 value)
	ANDS R1, R1, #0x1
	//Check if the result of the AND operation is equal to 1 (KEY0)
	CMP R1, #0x1
	//If not pressed, jump to KEY1 check (currently empty for you to fill in)
	BNE KEY1
	//If R1 == 0x1, the following code runs (i.e. KEY0 is pressed)
	//Move the value 0 into R4 (resets the count variable to 0)
	MOV R4, #0
	//Copy R4 into the R0 register (Needs to be in R0 since SEG7_CODE subroutine expects the function argument in R0)
	//ARM calling convention dictates that R0 should be used for the first argument
	MOV R0, R4
	//Branch and link (Link register stores address of next line of code so we know where to come back to)
	//Branches to code starting at the BOUNDS_CHECK label
	BL BOUNDS_CHECK
	//Branch and Link (Link register stores address of next line of code so we know where to come back to)
	//Branches to code starting at the SEG7_CODE label
	BL SEG7_CODE
    //Binary Value to display on the HEX display now in R0
    //Store the value in R0 (representing which segments to turn on) at the address in R6 (HEX3_0_BASE = 0xFF200020)
    STR R0, [R6]
    //Wait until the KEY is released
WAIT_KEY0:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR R1, [R5]
    //Compare R1 and 0
    CMP R1, #0
    //If R1 and 0 are not equal, go to the WAIT_KEY0 label
    BNE WAIT_KEY0
KEY1:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR	R1, [R5]
	// R1 = R1 & 0x2 (AND the value from the KEY register with 2 to isolate the KEY1 value)
	ANDS R1, R1, #0x2
	//Check if the result of the AND operation is equal to 2 (KEY1)
	CMP R1, #0x2
	//If not pressed, jump to KEY2 check
	BNE KEY2
	//If R1 == 0x2, the following code runs (i.e. KEY1 is pressed)
	// Increment R4 (The current number)
	ADD R4, R4, #1
	//Copy R4 into the R0 register (Needs to be in R0 since SEG7_CODE subroutine expects the function argument in R0)
	//ARM calling convention dictates that R0 should be used for the first argument
	MOV R0, R4
	//Branch and link (Link register stores address of next line of code so we know where to come back to)
	//Branches to code starting at the BOUNDS_CHECK label
	BL BOUNDS_CHECK
	//Branch and Link (Link register stores address of next line of code so we know where to come back to)
	//Branches to code starting at the SEG7_CODE label
	BL SEG7_CODE
    //Binary Value to display on the HEX display now in R0
    //Store the value in R0 (representing which segments to turn on) at the address in R6 (HEX3_0_BASE = 0xFF200020)
    STR R0, [R6]
    //Wait until the KEY is released
WAIT_KEY1:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR R1, [R5]
    //Compare R1 and 0
    CMP R1, #0
    //If R1 and 0 are not equal, go to the WAIT_KEY1 label
    BNE WAIT_KEY1
KEY2:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR	R1, [R5]
	// R1 = R1 & 0x4 (AND the value from the KEY register with 4 to isolate the KEY2 value)
	ANDS R1, R1, #0x4
	//Check if the result of the AND operation is equal to 4 (KEY2)
	CMP R1, #0x4
	//If not pressed, jump to KEY3 check (currently empty for you to fill in)
	BNE KEY3
	//If R1 == 0x4, the following code runs (i.e. KEY2 is pressed)
	// Increment R4 (The current displayed num)
	SUB R4, R4, #1
	//Copy R4 into the R0 register (Needs to be in R0 since SEG7_CODE subroutine expects the function argument in R0)
	//ARM calling convention dictates that R0 should be used for the first argument
	MOV R0, R4
	//Branch and link (Link register stores address of next line of code so we know where to come back to)
	//Branches to code starting at the BOUNDS_CHECK label
	BL BOUNDS_CHECK
	//Branch and Link (Link register stores address of next line of code so we know where to come back to)
	//Branches to code starting at the SEG7_CODE label
	BL SEG7_CODE
    //Binary Value to display on the HEX display now in R0
    //Store the value in R0 (representing which segments to turn on) at the address in R6 (HEX3_0_BASE = 0xFF200020)
    STR R0, [R6]
    //Wait until the KEY is released
WAIT_KEY2:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR R1, [R5]
    //Compare R1 and 0
    CMP R1, #0
    //If R1 and 0 are not equal, go to the WAIT_KEY2 label
    BNE WAIT_KEY2

KEY3:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR	R1, [R5]
	// R1 = R1 & 0x8 (AND the value from the KEY register with 1 to isolate the KEY3 value)
	ANDS R1, R1, #0x8
	//Check if the result of the AND operation is equal to 8 (KEY3)
	CMP R1, #0x8
	//If not pressed, jump back to the loop and contiunue checking
	BNE MAIN_LOOP
	//If R1 == 0x8, the following code runs (i.e. KEY3 is pressed)
	//Move the value 0 into R4 (resets the count variable to 0)
	MVN R4, #0
	//Copy R4 into the R0 register (Needs to be in R0 since SEG7_CODE subroutine expects the function argument in R0)
	//ARM calling convention dictates that R0 should be used for the first argument
	MOV R0, R4
	//Branch and link (Link register stores address of next line of code so we know where to come back to)
	//Branches to code starting at the BOUNDS_CHECK label
	BL SEG7_CODE
    //Binary Value to display on the HEX display now in R0
    //Store the value in R0 (representing which segments to turn on) at the address in R6 (HEX3_0_BASE = 0xFF200020)
    STR R0, [R6]
    //Wait until the KEY is released
WAIT_KEY3:
	//Loads the contents of the address in R5 (KEY_BASE) into the register R1
	LDR R1, [R5]
    //Compare R1 and 0
    CMP R1, #0
    //If R1 and 0 are not equal, go to the WAIT_KEY3 label
    BNE WAIT_KEY3
    B MAIN_LOOP // Key 3 was pressed and unpressed, now go back to the start
    
/* Subroutine to check if the provided value is wihtin 0 - 9.
	If the value > 9, the value is set to 9	(Provided for you)
	If the value < 0, the value is set to 0 (YOU NEED to implement this)	
 */    
BOUNDS_CHECK:
	CMP R0, #9
	BLE LOWER_BOUND_CHECK
	//When R0 > 9, SET the value of R0 to 9
	MOV R0, #9
LOWER_BOUND_CHECK:
	//Add the code to complete the lower bounds check (when R0 < 0, set to 0)
	CMP R0, #0
    BGE EPILOG
    MOV R0, #0
    
EPILOG:
	//Return to address in link register (next line after the function was called)
	BX LR

// *** DO NOT EDIT *** ///	
/* Subroutine to convert the digits from 0 to 9, or blank, to be shown on a HEX display.
 * Parameters: R0 = the decimal value of the digit to be displayed
 * Returns: R0 = bit patterm to be written to the HEX display
 */
SEG7_CODE:	
		MOV		R1, #0		// blank
DISPLAY0:
		CMP		R0, #0
        BNE		DISPLAY1
		MOV		R1, #0b0111111	// 0
        B 		END_SEG7
DISPLAY1:		
		CMP		R0, #1
        BNE		DISPLAY2
		MOV		R1, #0b0000110	// 1
        B 		END_SEG7
DISPLAY2:
		CMP		R0, #2
        BNE		DISPLAY3
		MOV		R1, #0b1011011	// 2
        B	 	END_SEG7
DISPLAY3:
		CMP		R0, #3
        BNE		DISPLAY4
		MOV		R1, #0b1001111	// 3
        B	 	END_SEG7	
DISPLAY4:
		CMP		R0, #4
        BNE		DISPLAY5
		MOV		R1, #0b1100110	// 4
        B	 	END_SEG7
DISPLAY5:
		CMP		R0, #5
        BNE		DISPLAY6
		MOV		R1, #0b1101101	// 5
        B	 	END_SEG7
DISPLAY6:
		CMP		R0, #6
        BNE		DISPLAY7
		MOV		R1, #0b1111101	// 6
		B	 	END_SEG7
DISPLAY7:
		CMP		R0, #7
		BNE		DISPLAY8
		MOV		R1, #0b0000111	// 7
		B	 	END_SEG7
DISPLAY8:
		CMP		R0, #8
		BNE		DISPLAY9
		MOV		R1, #0b1111111	// 8
		B	 	END_SEG7
DISPLAY9:
		CMP		R0, #9
		BNE		END_SEG7
		MOV		R1, #0b1100111	// 9
END_SEG7:
		MOV		R0, R1		// return bit pattern
		BX 		LR
		.end    
