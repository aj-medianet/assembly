TITLE Program 3     (program3.asm)

; Author: Andrew Joseph
; Last Modified: May 6 2018
; OSU email address: josephan@oregonstate.edu
; Course number/section: cs271 - ecampus
; Project Number: 3                Due Date: May 6 2018
; Description: Programming Assignment 3
; Integer Accumulator

INCLUDE Irvine32.inc

; constant definitions 
MAX = 79

.data

; variable definitions

intro			BYTE	"Welcome to the Integer Accumulator by Andrew Joseph", 0
askName			BYTE	"What's your name? ", 0
hello			BYTE	"Hello, ", 0
userName		db 80 dup (?)	;string variable for user inputted name
enterNums		BYTE	"Please enter numbers in [-100,-1].", 0
nonNeg			BYTE	"Enter a non-negative number when you are finished to see results.", 0
enterNumber		BYTE	"Enter Numbers: ", 0
inputNumber		DWORD	? ; user input number to add
sum				DWORD	0 ; initialize sum as 0
count			DWORD	0 ; count for how many numbers user adds
countPrint		BYTE	"You entered ", 0
validNumbers	BYTE	" valid numbers.", 0
sumPrint		BYTE	"The sum of your valid numbers is ", 0
avgPrint		BYTE	"The rounded average is ", 0
thanks			BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
period			BYTE	". ", 0

.code
main PROC

; display intro on the screen
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET askName
	call	WriteString

	;read string users name
	mov		edx, OFFSET userName
	mov		ecx, MAX
	call	ReadString
	call	CrLf

	;print hello, username  
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf

; tell user how to play
	mov		edx, OFFSET enterNums
	call	WriteString
	call	CrLf
	mov		edx, OFFSET nonNeg
	call	WriteString
	call	CrLf

play:
	mov		edx, oFFSET enterNumber
	call	writestring

	;get user input for number - add it to sum, mov the sum into sum variable
	call	readInt

	;check if input is non neg
	mov		ebx, 0
	cmp		eax, ebx
	jge		printStatements

	;add to sum if negative, iterate count, play again
	mov		ebx, sum
	add		eax, ebx
	mov		sum, eax
	mov		eax, count
	inc		eax
	mov		count, eax
	
	jmp		play

printStatements:
; print count
	mov		edx , offset countPrint
	call	writestring
	mov		eax, count
	call	writeint
	mov		edx, offset validNumbers
	call	writestring
	call	crlf

; print sum
	mov		edx, offset sumPrint
	call	writestring
	mov		eax, sum
	call	writeint
	call	crlf

;print average
	mov		edx, offset avgPrint
	call	writestring

	;get average - if count isn't > 0 - jump to print - else get avg
	mov		eax, count 
	mov		ebx, 0
	cmp		eax, ebx
	jle		printZero

	mov		edx, -1
	mov		eax, sum
	mov		ebx, count
	idiv	ebx
	call	writeint
	call	crlf
	jmp		theEnd

printZero:
	mov		eax, 0 
	call	writeint
	call	crlf

theEnd:

; say goodbye
	call	CrLf
	mov		edx, OFFSET thanks
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	writestring
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
