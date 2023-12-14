---
title: "Building Programming Languages"
subtitle: ""
summary: ""
tags: []
categories: []
published: "2023-12-10"
featured: false
draft: false
---

# Building Programming Languages
Let’s look into how to build a programming language. We start with informally building a language, then moving forward to a formal representation.

Programming languages are sophisticated. It was a hard task building even a simple programming language without sufficient knowledge in multiple areas of computer science. However, it can be simplified although it will be informal and might be unsound. In this post, I want to introduce developers to the behind-the-scene of programming languages, guide you through the steps of building one informally, and at the last step, lay them out in a formal

## Informal representation of programming languages

Developers/Programmers look at programming languages differently from the point-of-view of theorists. This perception is not wrong, but it might not deliver the full meaning/context. If you are a developer or a programmer, you might already have a sense for programming languages although informally. In this section, I introduce you to the informal representation of programming languages, and how to build a simple programming languages.

### Syntax

The first and foremost important part of a programming language is the syntax. The syntax is the aspect of programming languages that is commonly criticized by programmers. For many people, a programming language’s signature is the syntax itself, and they are not wrong in some sense. The syntax describe how a series of characters can be laid out to represent parts of programs, including functions, statements and expressions.

Deciding on the syntax of a programming language of your own can be a hard task, fortunately, we have some templates from existing (famous) programming languages. One of the “easy” syntax that is often used as an example for compiler classes is the curly braces with functions declarations and statements in popular languages like C or Golang.

After choosing a syntax for a programming language, a set of special keywords should be assigned as well. These give meaning to the programming language for humans to read. These keywords are usually “var”, “let”, “int”, “const”, “if”, “else”, “for”, “while”. Suppose we want following programming language syntax:

```js
function name(a, b, c) {
	let x = 1;
	if (x = 1) {
		x += 1;
    } else {
		x += 2;
    }
	for (i = 0; i < 10; i += 1) {
		x += 1;
    }
}
```

Then we should define keywords to be: “function“, “let“, “if“, “else”, “for“. After the general syntax and all keywords are defined, we begin to write a parser. The parser simple build a compact representation of a programs from a programming language syntax. From the above example, we would want a parser to generate objects like below:

```js
// not syntatically correct
let program = new Function(new Name("name"), [new Arg("a"), new Arg("b"), new Arg("c")], [
  new Let(new Var("x"), 1),
  new If(new Var("x") = 1, [new Var("x") += 1,], [new Var("x") += 2,]),
  new For(new Var("i") = 0, new Var("i") < 10, new Var("i") += 1, [
    new Var("x") += 1,
  ])
])
```

It might not look “compact” if we write everything out, but internally, the program object is information-compact and we can use it instead of moving through a list of characters/words finding for information. This compactness representation of programs is called **Abstract Syntax Tree**, commonly called AST. It represents every parts of a program abstractly.

After successfully building the AST for a program, the program can be run given a machine (another program) capable of stepping through each statement. This is where things get complicated and I will go through these complications later.

We have been talking about functions statements, and expressions, yet their meanings have not been discussed thus far. These terms are important in understanding of programming languages and should be thoroughly explained.

Functions are familiar to programmers, initially named sub-routine to denote parts of program that can will be reused multiple times. Today, in the context of programming language, functions serve multiple purposes: (1) sub-routine that can be reused across programs; (2) perform calculation from inputs, so called arguments. Statements are the most basic parts of a program that can be executed. Example statements are performing atomic calculations (x += 1), assignment (x = 1), if statement, for statement. Usually, statements are designed so that they can be nested, this will be discussed formally in later sections. Expressions are the smallest parts that can perform calculations. These are usually mathematic operations and must return a value.

### Checking programs

Not all written programs can be run successfully. There are many factors that affect the program making it not able to run, or would yield errors. To eliminate or at least reduce the errors, checks are performed at many different stages. We will examine the common and widely used check of variable availability.

Variables are everywhere in a program, with our limited use of vocabulary, programmers often use variables with the same name across their program in different context. The task of a checker is to perform checks for a variable if it is available at the current context. The context that we are referring to is usually called the “scope”. In “curly braces” programming languages, the scope can be thought of as between a pair of “curly braces” {}. This scope is usually defined to allow inheritance, where variable in the outside scope can be accessible from the inside scope. This checker also define what variable, memory space, is used for a statement or expression.

### Optimizing programs

Optimizations are frequently applied to a program to remove surplus information that usually not affecting the program logic. They are also used to remove parts of code that does not affect the result (of a function, expression, ...). Another kind of optimization focuses on the pre-computation of programs, where some expressions are pre-calculated and replaced with a simpler (cheaper) operation or constant. A special kind of optimization focuses on the way CPU works and rewrite the program so that it performs better.

All these optimizations are applied with a simple goal in mind, making programs run faster and smaller.

### Runtime

When talking about a programming language's runtime, programmers often assume that it only valids for languages like Java, because of the Java Virtual Machine. However, a programming language's runtime is a much broader concept that involves everything that a program needs to run (this would also include the Operating System). It is worth to get through all of the components at least at the surface level to understand how programming languages run/are executed.

There are several ways to make a program run for a specific programming languages. This is often by the design of the language and its runtime. In my observation, there are three types a programming language is designed to run.

1. Interpreted
2. Virtual Machine
3. Native code

Even with 3 types of design, not all programming languages runtime are designed similarly. Often each of them has a different runtime design to support their own language. Although not commonly seen, but all of them can be designed into a general runtime that can support multiple languages, such as the case for JVM (and the more modern GraalVM).

#### Interpreted

The program is run in a controlled manner by another program called the interpreter. The interpreter reads the program, understand the statements and perform them through the defined logic. In a sense, the interpreter acts as a coordinator between the program and its logic.

Languages designed with this kind of runtime are suitable for quick development. Just write and the interpreter will run the program immediately with little time in between. Famous languages that uses this design is Python and Javascript.

Both **Python** and **Javascript** are interpreted languages by design (officially). Although in fact, for Python, it uses a custom bytecode and everything is compiled into that bytecode before running; for Javascript, it compiles frequently used functions into the machine code. Nevertheless, they are interpreted languages suitable for fast development.

#### Virtual Machine

Instead of directly read a program and run them, some languages are companied with a Virtual Machine. These Virtual Machines are a program that reads a series of (simple?) instructions and perform them. For languages designed to be used with a Virtual Machine, the compiler transforms the program in programming languages into a series of instructions. Later on, to execute the program, these instructions are fed to the Virtual Machine and are run by the machine.

Virtual Machine manages the running program in all aspect, including memory usage, variables, classes, etc. Making a Virtual Machine is hard, but having a common Virtual Machine that runs on multiple platform allows a program to be written in one language and use them across multiple platform.

Such is the idea of the JVM. When multiple platforms emerged, people would write the same program for each platform and have to manually dealt with differences between platforms. Sun Micro System designed and implemented a Virtual Machine that compatible with multiple platforms and allow people to write program in a universal language of Java.

A Virtual Machine can be targeted and design a language that uses this Virtual Machine. Which is the idea behind Kotlin and Closure. These two languages "informally" proposed a new syntax for Java and work well with the Java Virtual Machine.

#### Native code



## Why informal is not enough

## Formalize programming language
