TITLE Program 4     (program4.asm)

; Author: Andrew Joseph
; Last Modified: May 13 2018
; OSU email address: josephan@oregonstate.edu
; Course number/section: cs271 - ecampus
; Project Number: 4                Due Date: May 13 2018
; Description: Programming Assignment 4
; Calculate composite numbers - user enter number of composites
; user enters number, program verifies it's between 1 and 400
;program calculates and displays all composite numbers to n
;10 composites per line 3 spaces in between 

INCLUDE Irvine32.inc

; constant definitions 
UPPER_LIMIT = 400

.data

; variable definitions

pName			BYTE	"Composite Numbers      Programmed by Andrew Joseph", 0
info			BYTE	"Enter the number of composite numbers you would like to see.", 0
info2			BYTE	"I'll accept orders for up to 400 composites", 0
enterNums		BYTE	"Enter the number of composites to display [1 .. 400] :  ", 0
invalidMessage	BYTE	"Out of range. Try again.", 0
n				DWORD	? ; user input number of composites
spaces			BYTE	"   ", 0
comp			DWORD	4 ; sets first composite number at 4
newLine			DWORD	0	;count for new line breaks
byeMessage		BYTE	"Results certified by Andrew. Goodbye.", 0


.code
main PROC
	call	intro			;displays intro to user
	call	getUserData		;prompts user to enter number of composites
	call	showComposites	;prints the composite numbers
	call	farewell			;prints goodbye message
	jmp		endProgram

;prints intro - explains program
intro PROC
	mov		edx, OFFSET pName
	call	writestring
	call	crlf
	call	crlf
	mov		edx, offset info
	call	writestring
	call	crlf
	mov		edx, offset info2
	call	writestring
	call	crlf
	call	crlf

	ret
intro ENDP

;prompts user to enter number of composites - validates number is 1-400 - assigns number to n
getUserData PROC
getUserInput:
	mov		edx, offset enterNums
	call	writestring

	;get user input for number
	call	readint

	;if less then 1, prompt user again
	mov		ebx, 1
	cmp		eax, ebx
	jl		invalid

	;if greater than 1, check less than 400
	mov		ebx, UPPER_LIMIT
	cmp		eax, ebx
	jle		validNumber

; give user out of range message and send back to get input
invalid:
	mov		edx, offset invalidMessage
	call	writeString
	call	crlf
	jmp		getUserInput
	
validNumber:
	;set user input to n
	mov		n, eax
	ret
getUserData	ENDP

showComposites PROC
printLoop:
	mov		eax, comp

	;check if number is composite
	;div by 2 and check edx is 0
	mov		edx, 0 
	mov		ebx, 2
	idiv	ebx
	mov		eax, edx
	mov		ebx, 0
	cmp		eax, ebx
	je		isComp

	;divide by 3 and check if edx is 0
	mov		edx, 0
	mov		eax, comp
	mov		ebx, 3
	idiv	ebx
	mov		eax, edx
	mov		ebx, 0
	cmp		eax, ebx
	je		isComp

	;divide by 5 and check if edx is 0 - exclude 5 itself
	mov		eax, comp
	mov		ebx, 5
	cmp		eax, ebx
	je		notComp
	mov		edx, 0
	mov		eax, comp
	mov		ebx, 5
	idiv	ebx
	mov		eax, edx
	mov		ebx, 0
	cmp		eax, ebx
	je		isComp

	;else jump to not comp
	jmp		notComp

	;if passed either check print number
isComp:
	mov		eax, comp
	call	writeint
	mov		edx, offset spaces
	call	writestring
	mov		eax, n
	dec		eax			;decrement n
	mov		n, eax

	;print 10 per line statement
	mov		eax, newLine
	inc		eax
	mov		newLine, eax
	mov		ebx, 10
	cmp		eax, ebx
	jl		sameLine	;if less than 10, skip new line statement
	call	crlf
	mov		eax, 0
	mov		newLine, eax	;reset newLine to 0

sameLine:

;not composite so don't print number
notComp:

;increment comp variable to check next number
	mov		eax, comp
	inc		eax
	mov		comp, eax

;call loop to continue while loop until n is 0
	mov		eax, n
	mov		ebx, 0
	cmp		eax, ebx
	jg		printLoop

	ret
showComposites ENDP


farewell	PROC
	call	crlf
	mov		edx, offset byeMessage
	call	writestring
	call	crlf

	ret
farewell	ENDP

endProgram:

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
