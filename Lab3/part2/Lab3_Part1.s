/*
Hunter Paulson - ECE 2161 Lab 3 Part 2
*/
.text
.global _start
_start: 
LDR R4, =RESULT
ADD R1, R4, #8 
LDR R0, [R4, #4]
LDR R3, [R1]
BL SUB1 //call subroutine at SUB1
STR R0, [R4] // Set Result to R0 since the routine returns via R0
END: B END //stop here
// Your subroutine starts below

// R0 - iterator
// R1 - Address of current iteration
// R2 - Content of current iteration
// R3 - Current max value (Will be put into R0 after routine)

SUB1:
//instructions for SUB1 go here
	SUB R0, R0, #1 // Subtract one to keep track of how many numbers are left
	CMP R0, #0  // If R0 is 0, we have chacked all N numbers (We are done the loop)
	BEQ DONE // Return value via R0 (Place contents of R3, current max, in R0). Otherwise:
	ADD R1, R1, #4 // Set R1 to the address of the next number in the list
	LDR R2, [R1] // Set R2 to contents of R3
	CMP R3, R2 // Comapre R3 (existing max) and R2 (conents of current iteration), so we can update the current max if needed
	BGE SUB1 // If R3 >= R2, run the loop again to keep checking. Otherwise:
	MOV R3, R2 // Set R3 to R2 because the current iteration is larger than the previous max
	B SUB1 // Run the loop again, with no conditional. We always run again regardless of previous CMP flag.

DONE: MOV R0, R3 // Return via R0
BX LR // End of the subroutine; goes back
// to the instruction immediately
// after BL

RESULT: .word 0
N: .word 7 // number of entries in the list
NUMBERS: .word 4, 5, 3, 6, 1, 8, 2 // the data
.end
