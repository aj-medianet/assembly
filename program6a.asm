TITLE Program 6a     (program6a.asm)

; Author: Andrew Joseph
; Last Modified: June 10 2018
; OSU email address: josephan@oregonstate.edu
; Course number/section: cs271 - ecampus
; Project Number: 6a                Due Date: June 10 2018 
; Description: Programming Assignment 6a

; implement and test own readval and writeval procedures for unsigned ints
; implement macros getString and displayString
; program gets 10 valid integers from user, stores the numeric values in an array
; program then displays integers, sums, and average


INCLUDE Irvine32.inc

; constant definitions 
UPPER_LIMIT = 10 ;  array upper limit
STRING_MAX = 100

;getString macros
getString MACRO stringInput, prompt
	push	ecx
	push	edx

	mov		edx, prompt
	call	writestring

	mov		edx, offset stringInput
	mov		ecx, (SIZEOF stringInput) - 1
	call	readstring
	pop		edx,
	pop		ecx
ENDM

;displayString macros
displayString MACRO	buffer
	push	edx
	mov		edx, buffer
	call	writestring
	pop		edx
ENDM


.data
; variable definitions

pName			BYTE	"PROGRAMMING ASSIGNMENT 6A: Designing low-level I/O procedures", 0
pName2			BYTE	"Written by: Andrew Joseph", 0
discription		BYTE	"Please provide 10 unsigned decimal integers.", 0
discription2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register", 0
discription3	BYTE	"After you have finished inputting the raw numbers I will display a list", 0
discription4	BYTE	"of the integers, their sum, and their average value.", 0

enterNums		BYTE	"Please enter and unsigned number: ", 0
invalidMessage	BYTE	"ERROR: You did not enter and unsigned number or your number was too big.", 0
invalidTryAgain	BYTE	"Please try again: ", 0

testingtesting			BYTE	"testingtesting", 0
converted		BYTE	"Converted: ",0

list			DWORD	UPPER_LIMIT DUP (?) ; array of 10 32-bit integers
inputArray		DWORD	STRING_MAX DUP	(?)	;array for getting user input strings
sum				DWORD	? ; variable for sum
average			DWORD	? ; variable for average
sLength			DWORD	0
inString		BYTE	STRING_MAX DUP (?)
outString		BYTE	STRING_MAX DUP (?)
num				DWORD	?	;stores number to put into array

arrayMessage	BYTE	"You entered the following numbers: ", 0
sumMessage		BYTE	"The sum of these numbers is: ", 0
avgMessage		BYTE	"The average is: ", 0

spaces			BYTE	"  ", 0

byeMessage		BYTE	"Thanks for playing!", 0


.code
main PROC
	push	offset pName
	push	offset pName2
	push	offset	discription
	push	offset	discription2
	push	offset	discription3
	push	offset	discription4
	call	intro				;displays intro to user

	push	offset list
	call	fillArray

	push	offset list
	push	offset arrayMessage
	call	printList

	push	offset list
	push	offset sumMessage
	call	getSum

	push	offset list
	push	offset avgMessage
	call	getAverage
			

	call	farewell			;prints goodbye message
	jmp		endProgram			;prints sorted array



writeVal PROC 

writeVal ENDP



;prints intro - explains program
intro PROC
	push	ebp		;set up stack frame
	mov		ebp, esp

	mov				edx, [ebp+28]	; sets message to edx
	displayString	edx
	call			crlf
	mov				edx, [ebp+24]	;  sets message to edx
	displayString	edx
	call			crlf
	call			crlf
	mov				edx, [ebp+20]	;  sets message to edx
	displayString	edx
	call			crlf
	mov				edx, [ebp+16]	;  sets message to edx
	displayString	edx
	call			crlf
	mov				edx, [ebp+12]	;  sets message to edx
	displayString	edx
	call			crlf
	mov				edx, [ebp+8]	;  sets message to edx
	displayString	edx
	call			crlf

	pop		ebp
	ret		24
intro ENDP

fillArray	PROC
	push	ebp		;set up stack frame
	mov		ebp, esp

	mov		edi, [ebp+8]	;set address of list into esi
	mov		ecx, lengthof list

more:
	call	readVal			; calls readVal function
	mov		[edi], eax		; adds number to array 
	add		edi, 4			;puts esi in next element in array
	loop	more

	call	crlf
	pop		ebp
	ret		8
fillArray	ENDP

;readVal - invoke getString macro to get users string of digits
;convert the digit string to numberic, validate user input
readVal PROC
	push	ecx	;pushes ecx to stack so we don't lose loop count

tryAgain:
	;get user input
	mov		edx, offset enterNums
	call	writestring

	mov		edx, offset inString
	mov		ecx, STRING_MAX
	call	readstring
	cmp		eax, 10
	jg		invalidInput

	
	;set up loop counter, put string addresses in source & index regusters
	;clear direction flag
	mov		sLength, eax
	mov		ecx, eax
	mov		esi, offset inString
	cld

	;check each char to see if it's between 0 & 9 (48-57 ascii)
loadString:
	lodsb
	cmp		al, 48
	jl		invalidInput
	cmp		al, 57
	jg		invalidInput

	;input is valid
	stosb
	;change char to corresponding int
	mov		ebx, 48
	sub		eax, ebx
	loop	loadString
	jmp		finishReadIn


invalidInput:
	mov		edx, offset invalidMessage
	call	writestring
	call	crlf
	jmp		tryAgain

finishReadIn:
	pop		ecx		; pops ecx back to use in loop count
	ret		
readVal	ENDP

printList	PROC
	push	ebp				;set up stack frame
	mov		ebp, esp
	mov		edi, [ebp+12]		;set address of list into edi
	mov		ecx, lengthof list	;sets length of array in ecx for looping

	mov				edx, [ebp+8]	; sets message to edx
	displayString	edx
	call			crlf

printLoop:
	mov		eax, [edi]			;put contents of list[n] in eax for printing
	call	writedec			;prints contents of index
	mov		edx, offset spaces
	call	writestring
	add		edi, 4				;put esi in next element in array

	loop	printLoop			;continue looping until n is 0

	call	crlf				;formatting 
	call	crlf

	pop		ebp
	ret		8
printList	ENDP

getSum	PROC
	push	ebp				;set up stack frame
	mov		ebp, esp
	mov		edi, [ebp+12]		;set address of list into edi
	mov		ecx, lengthof list	;sets length of array in ecx for looping

	mov				edx, [ebp+8]	; sets message to edx
	displayString	edx

sumLoop:	
	mov		eax, sum	;put contents of sum into eax for adding
	mov		ebx, [edi]	;put contents of edi into ebx to add to sum
	add		eax, ebx	; add current sum to array index
	mov		sum, eax	; mov new sum to sum variable
	add		edi, 4		; mov edi to next index in array

	loop	sumLoop

	call	writedec
	call	crlf

	pop		ebp
	ret		8
getSum	ENDP

getAverage PROC
	push	ebp				;set up stack frame
	mov		ebp, esp

	mov				edx, [ebp+8]	; sets message to edx
	displayString	edx

	mov		edx, 0					; zero out edx
	mov		eax, sum				; put sum in eax
	mov		ebx, lengthof list		; put number of elements in array in ebx
	idiv	ebx						; divide sum by length
	call	writedec				; print the average
	call	crlf

	pop		ebp	
	ret		8
getAverage ENDP

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
