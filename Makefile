build: boot/main.asm
	nasm -f bin -o build/main.bin boot/main.asm

run: build/main.bin
	qemu-system-i386 build/main.bin

clean: build/main.bin
	rm -r build/main.bin
