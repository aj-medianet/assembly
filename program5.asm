TITLE Program 5     (program5.asm)

; Author: Andrew Joseph
; Last Modified: May 28 2018
; OSU email address: josephan@oregonstate.edu
; Course number/section: cs271 - ecampus
; Project Number: 5                Due Date: May 28 2018 (with extension I asked for on the 27th)
; Description: Programming Assignment 5


INCLUDE Irvine32.inc

; constant definitions 
UPPER_LIMIT = 200 ;user input upper limit
LOWER_LIMIT = 10  ;user input lower limit

MAX = 999 ;max random number 
MIN = 100 ;min random number 

.data

; variable definitions

pName			BYTE	"Sorting Random Integers      Programmed by Andrew Joseph", 0
discription		BYTE	"This program generates random numbers in the range [100 ... 999]", 0
discription2	BYTE	"displays the original list, sorts the list, and calculates the", 0
discription3	BYTE	"median value. Finally, it displays the list sorted in decending order.", 0

enterNums		BYTE	"How many numbers should be generated? [10 .. 200] : ", 0
invalidMessage	BYTE	"Invalid input.", 0
n				DWORD	?	; user input amount of numbers to generate

list			DWORD	UPPER_LIMIT DUP (?) ; array of 200 32-bit integers
median			DWORD	? ; variable for median
half			DWORD	? ; get half value of nfor median calc

outer			BYTE	"outer ", 0
inner			BYTE	"inner ", 0
i				DWORD	0
j				DWORD	1
k				DWORD	0
nMinusOne		DWORD	?
unsortedString	BYTE	"The unsorted random numbers:", 0
medianString	BYTE	"The median is ", 0
sortedString	BYTE	"The sorted List:",0

spaces			BYTE	"   ", 0

newLine			DWORD	0	;count for new line breaks
byeMessage		BYTE	"Results certified by Andrew. Goodbye.", 0


.code
main PROC
	call	Randomize			;set seed for random number generator

	call	intro				;displays intro to user

	push	offset n			;push n to top of stack 
	call	getUserData			;prompts user to enter number of random numbers

	push	offset list			;push list to top of stack
	push	n
	call	fillArray			;prints the composite numbers

	;prints unsorted array
	mov		edx, offset unsortedString
	call	writestring
	call	crlf
	push	offset list
	push	n
	call	printList			

	;sorts array
	push	offset list
	push	n
	call	sortList	
	
	;gets median & prints it
	push	offset list
	push	n
	call	medianP				

	;prints sorted array
	mov		edx, offset sortedString
	call	writestring
	call	crlf
	push	offset list
	push	n
	call	printList			

	call	farewell			;prints goodbye message
	jmp		endProgram			;prints sorted array

;prints intro - explains program
intro PROC
	mov		edx, OFFSET pName
	call	writestring
	call	crlf
	mov		edx, offset discription
	call	writestring
	call	crlf
	mov		edx, offset discription2
	call	writestring
	call	crlf
	mov		edx, offset discription3
	call	writestring
	call	crlf
	call	crlf

	ret
intro ENDP

;prompts user to enter number of random numbers to generate
getUserData PROC
getUserInput:
	push	ebp		;set up stack frame
	mov		ebp, esp

	mov		edx, offset enterNums
	call	writestring

	;get user input for number
	call	readint

	;if less then 10, prompt user again
	mov		ebx, LOWER_LIMIT
	cmp		eax, ebx
	jl		invalid

	;if greater than 10, check less than 200
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
	mov		ebx, [ebp+8]	;get address of n to ebx
	mov		[ebx], eax		;store user input at address in ebx (which is n)
	pop		ebp				;restore stack frame
	ret		4
getUserData	ENDP

fillArray	PROC
	push	ebp		;set up stack frame
	mov		ebp, esp

	mov		edi, [ebp+12]	;set address of list into edi
	mov		ecx, [ebp+8]	;value of n in ecx

more:
	;generate random number to fill index with
	mov		eax, 989		;sets range to 0-989 so we can add 10 to it after
	call	RandomRange		
	add		eax, 10			;makes range 10-999
	
	mov		[edi], eax		;put random number into list[n]
	add		edi, 4			;puts esi in next element in array
	loop	more

	call crlf
	pop		ebp
	ret		8
fillArray	ENDP

printList	PROC
	push	ebp				;set up stack frame
	mov		ebp, esp
	mov		edi, [ebp+12]	;set address of list into edi
	mov		ecx, [ebp+8]	;put value of n in ecx

printLoop:
	mov		eax, [edi]			;put contents of list[n] in eax for printing
	call	writeint			;prints contents of index
	mov		edx, offset spaces
	call	writestring
	add		edi, 4				;put esi in next element in array

	loop	printLoop			;continue looping until n is 0

	call	crlf				;formatting 
	call	crlf

	pop		ebp
	ret		8
printList	ENDP

sortList	PROC
	push	ebp				;set up stack frame
	mov		ebp, esp
	mov		edi, [ebp+12]	;set address of list into edi
	mov		esi, [ebp+12]
	add		esi, 4			; start at k+1
	mov		ecx, [ebp+8]	;put value of n in ecx
	mov		eax, ecx
	dec		eax
	mov		nMinusOne, eax ;get n-1 for outer loop

outerLoop:
	mov		eax, k
	mov		edx, offset outer
	mov		ebx, nMinusOne
	cmp		eax, ebx
	je		done			; if k = n-1 break outer loop
	
	mov		i, eax			; set i = k like example

innerLoop:
	;if array[j] > array[i] then i = j
	mov		eax, [edi]		;edi is i
	mov		ebx, [esi]		;esi is j
	cmp		eax, ebx		;if if index i > index j then switch/exchange
	jl		noSwitch
	;else switch/exchange
	mov		[esi], eax	;move larger eax into esi index 
	mov		[edi], ebx	;mov smaller ebx into edi index 
	add		esi, 4		;send esi to next index like j would in higher language

noSwitch:
	mov		eax, j
	mov		edx, offset inner
	cmp		eax, ecx		;if j = n break out of inner loop
	je		innerLoopDone
	inc		eax
	mov		j, eax
	jmp		innerLoop

innerLoopDone:
	add		edi, 4	;increment k index in array
	mov		eax, 0	;reset j to 0 
	mov		j, eax
	mov		eax, k ;increment k for outer loop
	inc		eax
	mov		k, eax
	jmp		outerLoop
done:
	call crlf
	pop		ebp
	ret		8
sortList	ENDP

medianP		PROC
	push	ebp				;set up stack frame
	mov		ebp, esp
	mov		edi, [ebp+12]	;set address of list into edi
	mov		ecx, [ebp+8]	;put value of n in ecx

	;divide n by 2 and if edx is 0 number is even
	mov		eax, [ebp+8]	;move 
	mov		edx, 0		;zero out edx
	mov		ebx, 2
	idiv	ebx
	mov		half, eax
	mov		eax, edx
	mov		ebx, 0
	cmp		eax, ebx
	je		evenList

	;if it's odd, no jump
	mov		eax, half		; move truncated half of n into eax for mult
	mov		ebx, 4			;move 4 into ebx so i can multiply to get the correct index of the median
	mul		ebx		;give how many bytes to add to edi to get correct index
	add		edi, eax
	mov		eax, [edi]		;put contents of list[n] into eax
	mov		median, eax		;put eax into median variable
	jmp		printMedian
evenList:
	mov		eax, half
	mov		ebx, 4
	mul		ebx
	add		edi, eax 
	mov		ebx, [edi]		;move lower index into ebx
	add		edi, 4			;get next index
	mov		eax, [edi]		;move upper index into eax
	add		eax, ebx		;add upper and lower
	mov		ebx, 2
	mov		edx, 0			;zero out edx for mult
	idiv	ebx				;divide sum by 2 to get mean
	mov		median, eax		;mean is the median
printMedian:
	;print out the median
	mov		edx, offset medianString
	call	writestring
	mov		eax, median
	call	writeint
	call	crlf
	call	crlf

	pop		ebp
	ret		8
medianP		ENDP



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
