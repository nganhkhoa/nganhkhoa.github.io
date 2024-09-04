---
title: "Rebuilding binaries (easy) with ARMv8"
subtitle: ""
summary: ""
tags: []
categories: []
published: "2024-09-04"
featured: false
draft: false
---

ARMv8 architecture and instructions is simple to understand, and very compact. Each instruction uses 4-byte, and some special instructions can be used to calculate addresses effectively. These capabilities allow us to define a complex model for rebuilding application binaries.

## What is binary rebuliding and why?

Binary rebuilding is **my own term** to reflect binary modification by breaking down components of the binary, then reassemblying them again. Readers might be more familiar with techniques such as decompilation or lifting, and could be wondering why I opt to a different term. So let's dicuss what is decompilation and lifting and understand why binary rebuilding is different.

Decompilation is a complex process, ultimately trying to convert the compiled binary into its source code representation. Because the process can be seen as a reverse from compilation, people call it de-compilation. However, because of the many optimization passes introduced during compilation, decompilation is usually a less effective method.

Lifting describes the process of converting the binary assembly into a higher representation but not completely into source code. This interpretation is able to express the same program, allows for modifications, and is able to compile back into the binary. Lifting is often a more interesting choice because the liften representation is expressive, most of the time, more expressive then assembly.

So how binary rebuilding is different? Two previously described methods does not use assembly directly, mainly because assembly does not have the high density of information. It is obvious because a given assembly code does not give enough context to the function, or module it belongs to. However, assembly combines with binary format gives more information then one would think. Rebuilding binary aims to utilize the assembly with binary format to introduce a binary modification technique by breaking them to smaller components and joins them again.

## Binary executable format

The operating system can offload cpu instructions and execute them, but the instructions must be in the form of a well structured file, telling how the operating should load them in memory, as well as dynamic libraries included. This well structured file is often called executable binary format. Any opearting system can devise themselves their own format, and to date, the commonly used format are PE (on Windows), ELF (on Linux), and Mach-O (on Apple OS).

Executable binary formats are defined to store code and data used in the program, with information for the operating system to use to prepare the binary for execution (loader, but I don't want to make this post longer). In assembly, references to code or data must be through direct address or relative address of the code or data. For instance, a call to a function `foo` must either be `call addr-of-foo` or `call offset-below-x-bytes`. For data access, the same idea is applied, although sometimes, with a relocation (another common aspect in executable binary format, not to be discussed in detailed here).

## Rebuilding Binary

Rebuilding binary should be simple in the overview. Instructions, data, and imported modules are destructured from the binary format. Modifications can be made from this destructured form, and structure them back into the binary format after modifications are made. It might sound easy, but working through the this destructured form is very complex, as references must be handled very carefully. But why do we need to do this, what are the advantages compared to decompilation and lifting?

Rebuilding the binary in this form allows one to do anything, in theory. Code can be moved up and down, data can also be moved up and down, code and (readonly) data can be merged together, imported functions can be changed, data can be changed, code can be extended or trimmed or modified.

## Why ARMv8 makes this easier?

ARMv8 instructions are 4-byte each, meaning that the assembly is easy to be patched, introduced or removed, as when a modification is introduced, we can calculate ahead how many bytes are affected, thus making the correct change of space. ARM also has some interesting instructions such as `adr`, `adrp` help with addressing.
