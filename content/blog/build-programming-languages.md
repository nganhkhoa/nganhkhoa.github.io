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

The original way programming languages were created. All code is compiled into machine code and executed through loading the code to the chip. Usually the code execution is performed and "directed" by the kernel to transfer execution to the CPU.

Native code is faster, but there is no "runtime". Languages like C are created with no runtime. However, being left with no runtime is very limited, and not easy to write programs like that. Luckily, the Operating System provides a somewhat-runtime for all programs to be used. This runtime, we should refer to them as the standard library of the Operating System, notable the libc or libstd in Linux/XNU or the nt library in Windows.

#### Summary

The runtime interaction will be explained in another post (or later updated here) because of its complexity. But in overall, the runtime is prety much an inseparable when building a programming language because it is what the program is run with and depended on. The purpose for a runtime is to provide multiple aspect of a program at run time. The control flow of a program, variable storage are example aspects that will be controlled by having a runtime.

## Why informal is not enough

We talk through how to build a programming language in an informal way. It seems easy to build a programming language from what we just described, and indeed it is easy to build a new programming language. However, we have not talk about one of the most important aspect of programming language design, the soundness or corectness.

Given a programming language with a particular syntax, how should we interpret a specific statement or expression? The answer must be formally defined because it greatly affects how a program runs. If no formal definition is given, whoever implements the programming language (compiler, and runtime components, ...) will be unsure and might introduce undefined behavior in their implementation.

To answer the above question, we need to define semantics for the programming language. Semantics specify how a (abstract) statement should perform, what it does, what it returns, etc. This gives a definitive instructions on how a program is run.

Another big question that we have not discussed upon, types. Abstractly, things are untyped, but we all know that a boolean value cannot perform mathematical operation with a number, i.g., what is the meaning of "true + 1". This can be implemented as a program check and does not permit any "wrong"/"unacceptable" expression. But what if we consider the following case: let $x$ be a variable representing the value $true$, and $y$ be a variable representing the value $1$, what is the meaning of $x + y$. Obviously, the expression should be checked and rejected, but under what rule? To let these checks be performed, both $x$ and $y$ should be given a type, saying they are **values under a certain set of values**. The set of boolean values are $\\{true, false\\}$ and the set of integers are $\\{x | x \in \mathbb{N}, -2,147,483,648 <= x, x <= 2,147,483,647\\}$, and other similar types. The types are defined in a type system with their rules called typing rules. In modern programming languages, types are more complex with very advanced type system, including algebraic types, affine types, dependent types, etc.

To make our program sound, we have to give the programming language a formal definition. These often include operational semantics, denotational semantics, and a type system.

## Formalize programming language

### Operational Semantics

Operational semantics for a programming language define what the result is when an expression is applied. It should allows you to bind a certain operation in the programming language syntax with the real world effects. The below example is a simple rule for the add operator, roughly speaking: if $x$ evaluates to $X$ and $y$ evaluates to $Y$, then the expression $x + y$ evalues to $X + Y$, where $x$ and $y$ are variables.

$$\dfrac{x \Downarrow X \quad  y \Downarrow Y}{x + y \Downarrow X + Y}{(Add)}$$

> I might be confused with small-step semantics and big-step semantics.

Often, the program are executed with a given environment, and the statements/expressions can modify the environment. If that is the case, the operational semantics should be accompanied by an environment or a state. For the below example, roughly speaking: if expression $a$ evaulates to $n$ in the environment $\sigma$, then the statement $x := a$ modifies the environment to where $x = n$.

$$\dfrac{\langle a,\sigma \rangle \Downarrow n}{\langle x := a,\sigma\rangle \Downarrow \sigma[x \mapsto n]}{(Assignment)}$$

The above formular are given out of context to give an illustrated example of operational semantics. In a strictly designed programming language, all syntax must be defined using operational semantics to know what the program should do for a statement/expression.

### Denotational Semantics

> Still reading

### Type System

All programs must be typed, whether in compile time or run time (you may argue with me on this). Thus a type system is always present, the difference is when it is needed when building a program.

If the program is designed to control types in its syntax, high chance that the program is a statically typed language. These types of languages are checked at their compile time with the type system to see if there are any wrong-doings on types. The faults could be passing a wrong type to the function or performing a certain operation between two incompatible types.

On the contrary, if the language omits the types in its syntax, there is a high chance that the language is dynamically typed. Dynamically typed languages do not check with their typing rules at any point in time, but they have an assertion that yields errors if the variable is used with a different expected type. For example, a variable $x$ should be of type $int$ in the expression $x + 1$, but at runtime, when evaluating $x + 1$, the type of $x$ is $boolean$, then an error is thrown saying expecting an $int$ value but is given a $boolean$ value.

To perform these checks, a series of typing rules must be defined. One such typing rule could be as below, roughly speaking: if $cond$ is an expression of type $boolean$, $a$ is an expression of type $T$ and $b$ is an expression of type $T$ (also), then the expression $\texttt{if cond then a else b}$ is an expression of type $T$.

$$\dfrac{cond : boolean \quad a : T \quad b : T}{\texttt{if cond then a else b} : T}{(If)}$$

Through deduction rules, the whole program can be type check for errors. There is a proof saying that "Well typed programs cannot go wrong" - Robin Milner. In simple terms, as long as the program can be typed and successfuly type checked (well typed), then the program is sound. At least to the same logic defined by the language, it cannot be helped if you write the wrong logic, lol.

It is appealing, but in practice to make a well typed program is harder than you might think. Mostly due to many things that we could use to program, such as clsses, closure, multi-threading, parallelism, etc. All of these are hard to type, and people are still researching for ways to efficient, and sound typing rules.

## The future of programming language

At the present, programming language can be built in one day. However, these languages are very simple and they usually have the same problems prominent in other languages. The future that programming language research is heading is solving the current problems of software engineering, as well as introducing a better approach for programming complex systems. None the less, safety in programs through the analysis of programming language is also a big concern. 

Modern programming languages are designed mostly with an industrial point of view. Their syntax are simple at first but as time goes on and multiple features are added, more syntax are introduced with extrafluous keywords (I'm looking at you C++ and Java). Frankly, the programming language landscape is shifting back to the functional language era with languages like Kotlin and Rust.

There are also an abundance of problems on multiple aspects of programming language behavior. Most of them are related to the computational effects. In pure programming language, where there are only computations between values, effects is non-existent. But that language is impractical, as we have to work with the outside environment. Effects we often use are memory access (storage), keyboard inputs, file reads (IO operations), exceptions, etc. Computational effects **handling** are currently weakly (unsound) defined in modern programming languages. We still do not know how to effectively handle an effect.

> Notable mentions: Call-By-Push-Value (CBPV), Algebraic effects, Monadic effects, Effect handlers.

Type systems are getting more and more research to effectively type a program, or enable more flexibility in a programming language.

> Notable mentions: Algebraic Data Types, Row polymorphism (Record Types), Refinement Types, Gradual Types, Affine Types, Graded Types.

In the realm of types, they are currently being used to solve theorems. This kind of research develops the Dependent Types and currently they are evolved into Homotopy Type Theory.

Programming languages are currently being developed in a smaller scale to solve a more specific field, e.g., Database management (SQL, GraphQL), Parallel language, Distributed system, Quantum computing, etc. These are Domain Specific Language (DSL) and allows writers to focus on the problem without having to go through a series of different steps in a more generic language, thus lowering the accessibility.

An interesting field of research on programming language theory is program synthesis. Where programs can be built automatically through the use of many technologies combined. We expect that program synthesis can produce a program given enough information, or it can find bugs and fixes itself. There are also research to imply certain parts of program to elevate writers from writing specific code instructions.

And lastly, for security, there are plenty of research directions. They are available under the name of "program verification". Through deducing of a program's logic, as defined through the syntax and source code, some characteristics can be found and can be automatically filter as good or bad. There are two kinds of verifications, the automatic system checking everything through a predefined model (model checking), or the manual method using conditions and guard the programs inputs as well as outputs by checking if the input set violates the output conditions when the program is executed.

> Notable mentions: Floyd-Hoare logic, Horn clause, Weakest precondition, Incorrectness logic, Separation logic
