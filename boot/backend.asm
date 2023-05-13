print:
	mov ah, 0x0e    ; mov 0x0e to ah
	lodsb 			; load single bite to al
	cmp al, 0 		; compare al to 0
	je return 		; if == then ret
	int 0x10 		; print
	jmp print 		; loop


nl:
	mov ah, 0x0e 	; switch to teletype mode
	mov al, 10 		; add al with new line character
	int 0x10 		; print it
	ret 			; return

movecursor:
	mov ah, 02h    ; Set AH = 02h (function code for moving cursor)
	mov bh, 0      ; Set BH = 0 (page number)
	mov dh, dh     ; Set DH = desired row (0-based index)
	mov dl, dl     ; Set DL = desired column (0-based index)
	int 10h        ; Call BIOS interrupt 10h to move the cursor
	ret

printc:
	lodsb
	cmp al, 0
	je return
	mov word [es:di], ax   	; Store the character and attribute byte at ES:DI
	add di, 2  				; Increment DI to move to the next chr position
	jmp printc


poweroff:
	mov ax, 0x5307   ; Set AX = 5307h (ACPI shutdown command)
	mov bx, 0x0001   ; Set BX = 0001h (ACPI shutdown type, 0001h = power off)
	int 0x15         ; Invoke the BIOS ACPI interrupt to trigger the shutdown
	ret

reboot:
	mov ah, 0
	int 19h 		; revoke reboot function	
	ret

return:
	ret
