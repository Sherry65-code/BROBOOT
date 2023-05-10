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

_start:
	mov ax, 0x7c00						; move 0x7c00 to ax
	mov ds, ax 							; set data segment to where we are loaded

	mov ah, 0 							; changing to 03h video mode
	mov al, 0x03
	int 0x10 							; switched to 80x25

	; print Heading
	mov ah, 0x09 						; Set bg and fg color function
	mov al, ' ' 						; fill up character
	mov bh, 0 							; page number
	mov bl, 0xf1 						; 0xab a => bg b => fg
	mov cx, 80 							; number of characters to update
	mov dx, 0 							; column
	mov bp, 0 							; row
	int 0x10 							; done	

	; printing broboot
	mov ah, 0x0e
	mov al, 'B'
	int 0x10
	mov al, 'R'
	int 0x10
	mov al, 'O'
	int 0x10
	mov al, 'B'
	int 0x10
	mov al, 'O'
	int 0x10
	int 0x10
	mov al, 'T'
	int 0x10	
		
	; changing cursor position
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 1 							; row
	mov dl, 0 							; column
	int 0x10
	
	mov ah, 0x09
	mov al, ' '
	mov bh, 0
	mov bl, 0x1f
	mov cx, 2000
	mov dx, 0
	mov bp, 3
	int 0x10

	; change curosr position
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 3
	mov dl, 0
	int 0x10

	; write poweroff command
	mov ah, 0x0e
	mov al, 'P'
	int 0x10
	mov al, ' '
	int 0x10
	mov al, 'P'
	int 0x10
	mov al, 'o'
	int 0x10
	mov al, 'w'
	int 0x10
	mov al, 'e'
	int 0x10
	mov al, 'r'
	int 0x10
	mov al, ' '
	int 0x10
	mov al, 'O'
	int 0x10
	mov al, 'f'
	times 2 int 0x10
	
	; wait for input
	mov ah, 0
	int 0x16
	cmp al, 'p'
	je poweroff
	
	jmp $

poweroff:
	mov ah, 0
	mov dl, 0
	int 0x19
	jmp .done
.done:
	ret
	times 510-($-$$) db 0
	db 0x55, 0xaa
