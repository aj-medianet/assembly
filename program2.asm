TITLE Program 2     (program2.asm)

; Author: Andrew Joseph
; Last Modified: April 22 2018
; OSU email address: josephan@oregonstate.edu
; Course number/section: cs271 - ecampus
; Project Number: 2                Due Date: April 22 2018
; Description: Programming Assignment 2
; Fibonacci Numbers Program - get users name - have user enter number of Fib terms between 1 & 46
; display results after validation

INCLUDE Irvine32.inc

; constant definitions 
LOWER_LIMIT = 1	;lower limit for user input terms
UPPER_LIMIT = 46	;upper limit for user input terms
MAX = 79

.data

; variable definitions

intro			BYTE	"Fibonacci Numbers", 0
intro2			BYTE	"Programmed by Andrew Joseph", 0 
askName			BYTE	"What's your name? ", 0
hello			BYTE	"Hello, ", 0
userName		db 80 dup (?)	;string variable for user inputted name
enterNumFib		BYTE	"Enter the number of Fibonaccie terms to be displayed", 0
range			BYTE	"Give the number as an integer in the range [1 .. 46].", 0
howMany			BYTE	"How many Fibonacci terms do you want? ", 0
terms			DWORD	?	;how many fib terms user enters
outOfRange		BYTE	"Out of range. Enter a number in [1 .. 46]", 0
fib1			DWORD	1 ; first fib number set to 0
fib2			DWORD	1 ; second fib number set to 1
next			DWORD	? ; next fib number - sum of prev two
count			DWORD	1 ; count for new line breaks
spaces			BYTE	"     ", 0 ; blank sapces
resultsCert		BYTE	"Results certified by Andrew Joseph", 0
bye				BYTE	"Goodbye, ", 0



.code
main PROC

; display intro on the screen
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET askName
	call	WriteString

	;read string username
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

;get user data
	;prompt user for how many fib numbers
	mov		edx, OFFSET enterNumFib
	call	WriteString
	call	CrLf
	mov		edx, OFFSET range
	call	WriteString
	call	CrLf
	call	CrLf

wrongInput:
	;ask user how many fib numbers they want, read int to terms variable
	mov		edx, OFFSET howMany
	call	WriteString
	call	ReadInt
	mov		terms, eax
	;validate number
	mov		ebx, UPPER_LIMIT
	mov		eax, terms
	cmp		eax, ebx ; if terms is lower than 46 continue, else ask for new number
	jle		isLess	
	mov		edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
	jmp		wrongInput
isLess:
	mov		eax, terms
	mov		ebx, OFFSET LOWER_LIMIT
	cmp		ebx, eax ;if terms is greater than 1 continue, else ask for new number
	jle		inputCorrect
	mov		edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
	jmp		wrongInput


inputCorrect:
;assign terms to ecx for loop count
	mov		ecx, terms
	mov		edx, OFFSET spaces

fibLoop:
	; fib sequence
	mov		eax, fib1
	add		eax, fib2
	mov		ebx, fib2
	mov		fib1, ebx
	mov		fib2, eax
	
	;print sum plus 5 white spaces
	call	WriteInt
	call	WriteString

	; see if count is 5, if so new line, if not continue and iterate count
	mov		eax, count
	cmp		eax, 5
	jne		noNew
	mov		eax, 0
	mov		count, eax
	call	CrLf
	
	;no new line - keep loop going on same line for printing
	noNew:
	add		eax, 1
	mov		count, eax

	loop	fibLoop ; subtract 1 from ecx - if ecx != 0 continue loop


; say goodbye
	call	CrLf
	mov		edx, OFFSET resultsCert
	call	WriteString
	call	CrLf
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
