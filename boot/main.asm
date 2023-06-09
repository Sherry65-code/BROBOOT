%if 0; 
 * Title: A Simple Bootloader For the Mighty
 * Author: Parambir Singh AKA Hecker (Sherry65-code)[github]
 * Website: https://tuxnotesx.web.app/
%endif; 
	
	BITS 16

	jmp short _start	; Jump past disk description section
;	jmp _start
	nop	
	
; Disk description table, to make it a valid floppy
OEMLabel			db "BROBOOT " 		; Disk label
BytesPerSector		dw 512				; Bytes per sector
SectorsPerCluster	db 1				; Sectors per cluster
ReservedForBoot		dw 1				; Reserved sectors for boot record
NumberOfFats		db 2				; Number of copies of the FAT
RootDirEntries		dw 224		
LogicalSectors		dw 2880				; Number of logical sectors
MediumByte			db 0F0h				; Medium descriptor byte
SectorsPerFat		dw 9				; Sectors per FAT
SectorsPerTrack		dw 18				; Sectors per track (36/cylinder)
Sides				dw 2				; Number of sides/heads
HiddenSectors		dd 0				; Number of hidden sectors
LargeSectors		dd 0				; Number of LBA sectors
DriveNo				dw 0				; Drive No: 0
Signature			db 41				; Drive signature: 41 for floppy
VolumeID			dd 12345678h		; Volume ID: any number
VolumeLabel			db "BROBOOT    " 	; Volume Label
FileSystem			db "FAT12   "		; File system type: don't change!


%include "boot/backend.asm"

_start:
	mov ax, 07C0h		; move 0x7c00 into ax
	mov ds, ax			; set data segment to where we're loaded

	
	; A USER GUIDE TO REGISTERS
	; dh = row
	; dl = column
	; ah = color (bg+fg)
	; di = pointer for printc funtcion and printsc function
	; GUIDE ENDS HERE

	; switch to 03h video mode
	mov ah, 0
	mov al, 3
	int 0x10

	; change to video memory location
 	mov ax, 0B800h     ; Set AX to the starting address of the video memory
  	mov es, ax         ; Set ES to the video memory segment
	mov di, 0 		   ; set di to the beginning of the video memory
	
	; main()
	
	; disable the blinking attribute to get all the colors avaliable to us

	mov ah, 10h     ; Set up the video interrupt function
 	mov al, 3h      ; Function 3h is used to set the attribute mode
 	mov bh, 0h      ; Page number (usually 0 for the default page)
 	mov bl, 0h      ; Attribute mode (0h disables blinking)
 	int 10h         ; Call the video interrupt
	


	; top bar
	mov si, topbar
	mov ah, 10h
	mov di, 340
	call printc
		
	; main body
	loop1:
		mov si, topbar
		mov ah, 90h
		add di, 40
		call printc
		cmp di, 3060
		jle loop1

	; title bar heading
	mov si, bootname
	mov ah, 0x1f
	mov di, 344
	call printc
	
	; bottom text (left)
	mov si, lefttext
	mov ah, 0x9f
	mov di, 2744
	call printc
	
	; my name (left)
	mov si, trademark
	mov ah, 0x9f
	mov di, 2904
	call printc

	boot:
		mov si, pass
		mov ah, 0x9f
		mov di, 664
		call printc


	listen:
		mov ah, 0
		int 0x16
		cmp al, 'r'
		je reboot
		jmp listen

	jmp $
	
	pass db "Booting into Bromine OS...", 0
	nopass db "No OS Found", 0
	trademark db "Made by Parambir Singh :)" , 0	
	lefttext db "Press r to reboot", 0
	bootname db "BROBOOT", 0
	topbar db "                                                            ", 0

.done:
	ret
	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	db 0x55, 0xaa		; The standard PC boot signature
