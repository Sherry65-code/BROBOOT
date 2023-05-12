%if 0; 
 * Title: A Simple Bootloader For the Mighty
 * Author: Parambir Singh AKA Hecker (Sherry65-code)[github]
 * Website: http://tuxnotesx.web.app/
%endif; 	

	BITS 16

	jmp short _start	; Jump past disk description section
	nop	
	
; Disk description table, to make it a valid floppy
OEMLabel			db "BROBOOT" 		; Disk label
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
FileSystem			db "FAT12"			; File system type: don't change!

%include "boot/userwork.asm"

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
		cmp di, 3000
		jle loop1

	; title bar heading
	mov si, bootname
	mov ah, 0x1f
	mov di, 344
	call printc
	
	jmp $
	
	bootname db "BROBOOT", 0
	topbar db "                                                            ", 0

.done:
	ret
	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature
