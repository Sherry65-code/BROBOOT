build: boot/main.asm
	nasm -f bin -o main.iso boot/main.asm

run: main.iso
	qemu-system-i386 main.iso

clean: main.iso
	rm main.iso
