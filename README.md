# x86-32-assembly

This repository contains a collection of exercises and practices, developed during lab sessions of the course _Estructura y Organización de Computadores_ (Computer Structure and Organization in Spanish), written in assembly language using the GNU Assembler (GAS, also known as `as`) and the GNU Linker (`ld`). It also makes use of tools like `make` for build automation and `gdb` for debugging.

## Requirements

To work with these exercises, you need the following tools installed on your system:
- GCC (GNU Compiler Collection)
- GNU Binutils (includes GNU Assembler and Linker)
- GDB (GNU Debugger)
- Make (build automation tool)

### Installing the Requirements

Below are the instructions to install the required tools on the most common GNU/Linux distributions:

#### Ubuntu / Debian
```bash
sudo apt update
sudo apt install build-essential gdb
```

#### Fedora
```bash
sudo dnf update
sudo dnf group install "Development Tools"
sudo dnf install gdb
```

#### Arch Linux / Manjaro
```bash
sudo pacman -Syu base-devel gdb
```

### Installation for Other Distributions
Check your distribution's official documentation or use its package manager to install the required tools.

## How to Use This Repository

1. Clone this repository to your computer:
    ```bash
    git clone https://github.com/Blockky/x86-32-assembly.git
    cd x86-32-assembly
    ```

2. Navigate through the practice files:
    ```bash
    cd src
    ls
    cd practice-name
    ```

3. Build an example file using `make`:
    ```bash
    make
    ```

4. Run the generated binary:
    ```bash
    ./example
    ```

5. Debug your code with GDB (optional):
    ```bash
    gdb ./example
    ```

6. Clean up the generated files:
    ```bash
    make clean
    ```

---

Enjoy working with this repository designed to improve your understanding of assembly language.
