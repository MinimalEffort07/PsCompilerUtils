# PsCompilerUtils

## Why?

You __want__ LSP capabilities, linting, diagnostics etc.   

You __don't__ want to use CMake or some other meta build system ( which 
can generate `compile_commands.json` ) because it's probably overkill.

You __don't__ want to use Visual Studio  

You __don't__ want to manually craft `compile_commands.json` using -MJ 
and stitching output files together. Or simply you don't want to use 
clang as the compiler.  

## Example

The useage should be near identical to calling a compiler and linker 
yourself except behind the scenes PsCompilerUtils is taking care of 
building a `compile_commands.json` file for you.  

```ps1
# Single command
compile --in a.c b.c --out a.exe
```

Or  

```ps1
# Split commands
compile --in a.c --out a.obj --options /c
compile --in b.c --out b.obj --options /c
link --in a.obj b.obj --out a.exe
```

both result in a `compile_commands.json`  
```json
[
    {
        "directory": "C:\\Users\\users\\",
        "file": "a.c",
        "output": "C:\\Users\\user\\AppData\\Local\\Temp\\a-f687af.o",
        "arguments": ["C:\\Users\\user\\projects\\llvm-project\\build_ninja\\bin\\clang++.exe", "-xc++", "a.c", "-o", "C:\\Users\\user\\AppData\\Local\\Temp\\a-f687af.o", "--driver-mode=g++", "-dumpdir", "a-", "--target=x86_64-pc-windows-msvc19.44.35214"]
    },
    {
        "directory": "C:\\Users\\users\\",
        "file": "b.c",
        "output": "C:\\Users\\user\\AppData\\Local\\Temp\\b-d3e4b3.o",
        "arguments": ["C:\\Users\\user\\projects\\llvm-project\\build_ninja\\bin\\clang++.exe", "-xc++", "b.c", "-o", "C:\\Users\\user\\AppData\\Local\\Temp\\b-d3e4b3.o", "--driver-mode=g++", "-dumpdir", "a-", "--target=x86_64-pc-windows-msvc19.44.35214"]
    },
]
```
