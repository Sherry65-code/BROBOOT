build: boot/main.asm
	nasm -f bin -o build/main.iso boot/main.asm

run: build/main.iso
	qemu-system-i386 build/main.iso

clean: build/main.iso
	rm -r build/main.iso
