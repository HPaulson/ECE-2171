/*
Hunter Paulson - ECE 2161 Lab 3 Part 1
Questions:
1. The goal of this program is to find the max number of in a list of 7 (4,5,3,6,1,8,2) using a loop
2. Register r0 contains the final result, 8. See attached screenshot for memory table.
3. The value for -5 is represented by FFFFFFFB. To do this manually, you get the positive representation of  5, 0000 0000 ... 0000 0101, and the take its 2's compliment by inverting all the bits and adding one.
*/

// Program for Part 1.
// You may use // or /* & */ for comments.
// Labels must start at column 1 (leftmost) Programs must end with .end

.text //code follows 
.global _start

_start: //Load value of RESULT label (which is the address of that line in memory) into R4
        LDR R4, =RESULT 
        // []s denote that we go to the address inside the brackets and get the contents
        // Get the contents of address R4 (The address where result is) + 4
        // Each .word down below takes 4 bytes (so offseting from RESULT) to RESULT + 4 is the address of N
        // This instruction gets the value in memory at the address N is referring to as a label and stores it in R2
        LDR R2, [R4, #4]
        //R3 = Base address of RESULT (R4) + 8
        ADD R3, R4, #8 
        //Go to address stored in R3 (Base address of RESULT (R4) + 8) gets the contents and store in R0
        //The address at R4 + 8 is refencing the start of the list of numbers (NUMBERS) below. So R0 would get the value 4 to start
        LDR R0, [R3] 

LOOP:   SUB R2, R2, #1 // Subtract one to keep track of how many numbers are left
        //CMP is basically a substraction, but sets processor flags that tell the processor if the result was negative, zero, and an unsigned or signed overflow
        CMP R2, #0  // If R2 is 0, we have chacked all 7 numbers (We are done the loop)
        //The branch instruction uses the processor flags to determine the next instruction to execute
        //BEQ is checking if the zero of the comparison was equal (i.e. if we subtract the two and get 0)
        //If equal, then the progam jumps to the DONE label, otherwise it executes the next instruction
        BEQ DONE // exit loop. Otherwise:
        ADD R3, R3, #4 // Set R3 to the address of the next number in the list
        LDR R1, [R3] // Set R1 to contents of R3
        CMP R0, R1 // Comapre R0 (existing max) and R1 (conents of current number), so we can update the current max if needed
        // Check the ECE2170 Assembly guide for the Branch codes (i.e. GE)
        BGE LOOP // If R0 >= R1, run the loop again to keep checking
        MOV R0, R1 // Set R0 to R1 (the contents of R3) because it is larger than the current value of R0 (the current max)
        //What is the difference between a B and a B<cond>, such as BGE?
        B LOOP // Run the loop again, with no conditional. We always run again regardless of previous CMP flag.

DONE:   STR R0, [R4] // Put contents of R0 into the address of R4. Result points to R4, so this allows RESULT to store the correct max value

END:    B END

RESULT:  .word 0 //WORD = 4 bytes of memory 32-bits 
N:       .word 10
NUMBERS: .word -9,1,10,-5,4,12,-4,8,32,5
         .end