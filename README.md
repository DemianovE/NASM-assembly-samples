# NASM-assembly-samples
Sample on the road to learn the assembler for the purpose of use in another project. 

As such the code present can be used for educational purposes. 
I have splited code not by the "steps" but by practical tasks implemented.

The main purpose of my learning of this language is for the math implementations with maximum 
usage of the SIMD instructions. This is not for actual usefulness but for the sake of learning.

> **Disclaimer:** This example is not replacement of actual literature and learning, but is supplementary


## Tasks implemented:
The task are split by how hard they are. As such here is guide:

#### basic:
 - [hello_word](basic/hello_world.asm) - hello world. What can I say more?
 - [args_add](basic/args_add.asm) - code which takes 2 arguments and adds them together
 - [reverse_string](basic/reverse_string.asm) - code which reverses a string defined in it

## How to use:

The following commands are used to build executable from assembler files:
```bash
nasm -f elf64 file.asm -o file.o -DLINUX
ld file.o -o file # if build on linux
x86_64-linux-gnu-ld scratch.o -o scratch # to build linux files in mac
```

If you want to run the code not on linux you can use docker:
```bash
docker run --rm -it -v "$PWD":/mnt ubuntu:latest bash
```
> **_NOTE:_** When building files again, no need to restart docker as it will get all changes