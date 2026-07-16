---
title: "A year of Programming Language Theory"
subtitle: ""
summary: ""
tags: []
categories: []
published: "2026-07-16"
featured: false
draft: false
---

> In the past year, I have been studying (a little) programming language theory. This post is not to condense what I have studied, but a little note for myself to summary what the field is about. This post should give readers some intuition about the field, and left out proofs. PL researchers usually work through the proofs to a great extend. I am still learning how to prove stuffs formally.

## What is PL Theory?

I do not know the concrete definition of Programming Language (PL) Theory. In my own observation, PL Theory studies programming language models by the examination and experimentation of formal models. These models are often the language syntax and its semantics.

Syntax is the main component of a programming language. Usually, a PL research revolves some features or trying to solve a problem. The syntax is chosen explicitly based on this observation. For example, if we want some language that is minimal, PCF is chosen as the base language. PCF has the common features that we are used to for coding: conditionals, functions, and higher-order. However, some research might chose ML as the base language. ML, parent of OCaml, supports Algebraic Data Types (ADT) and pattern matching. Or if we want to base on some class-like language, we can use FeatherWeightJava.

After the syntax is defined, the language's semantics must be defined. It defines how would the program runs (formally, reduces). In some basic language, the runtime is simple, it takes a "running" program and reduces to the next "running" program. This simple runtime cannot express complex states. To express complex states, the language runtime is also defined with a state, an initial state, and state transition rules.

After those are defined, some core theorems are stated. Usually, they must show that the language actually runs and be deterministic (except when dealing with concurrency), and it also solves a particular problem (safety or similar).

### Examples



> I started learning through the "Intro to Type System" course taught by Professor Robby Findler. I wish that there was a "Intro to PL research" course before this because I was too focus on Type System.

## Preliminaries

Before getting into PL Theory, learners should have a good understanding of Sets and some basic logic. Because a lot of definitions are provided as set, or rules written in logic format.

### Set

Set defines a collection of elements (items). Consider the set of boolean `{true,false}` is a collection of two elements. Boolean set are closed, meaning they have finite elements. The set of natural numbers `{0,1,2,...}` is a collection of infinite elements, and the set is open.

In PL Theory, we use _inductive_ sets, or "recursive" set. The example below shows an inductive set of trees. The following are some elements in the set: `node 0`, `node 1 * node 2`, `(node 1 * node 2) * (node 3 * node 4)`. Using inductive set, we are able to express all possible contructions of the elements in the set.

```
tree = node int
     | tree * tree
```

### Basic Logic

We will often use rules to "work" with our language. A rule consists of two parts: premises and result. You can think of this as a true/false indicator. For example, a rule with premises `A > B` and `B > C`, yields `A > C`. Given `A = 3`, `B = 2`, and `C = 1`. Then `A > C` only if `3 > 2` and `2 > 1`. By law of naturals, we know this is true.


## Lambda Calculus Untyped and Typed


### Untyped

Lambda Calculus is one of the first thing that appears in PL Theory courses. It introduces a simple language that has only functions and applications (calling a function).

```
M,N := X | M N | lambda X. M
X   := variable names
```

The language syntax is defined in an inductive manner. These can be a lambda calculus program: `X`, `X Y`, `lambda X. X`, `(lambda X. X) (lambda X. X)`. The next step is to provide the semantics, which is very simple:

```
(lambda X. M) N -> M[X:=N]
```

This means that if you have a *program* which is a function calling, then it _steps_ into the body of the function, treating the parameter as name and replaces it with the argument. If you notice, I wrote program in the previous sentence. The rule above works explicitly for that form, which fails for the program below:

```
((lambda X. M) (lambda Y. N)) P
```

Intuitively, we want to first reduces the left part `((lambda X. M) (lambda Y. N))`, which yields a function, and then we can apply with `P`. Because of this, the full semantics must be extended, allowing reduction on the left and right side. Therefore, the following is the full semantics of Lambda Calculus:

```
(lambda X. M) N -> M[X:=N]
M N -> M' N if M -> M'
M N -> M N' if N -> N'
```

The semantics are almost completely defined. We still need to know what `M[X:N]` does. Consider this case `M=lambda X. P`, should `X` be replaced in `P`?

We can define subtitution:

```
X[X:=P] = P
Y[X:=P] = Y
(M N)[X:=P] = M[X:=P] N[X:=P]
(lambda X. M)[X:=P] = lambda X. M
(lambda Y. M)[X:=P] = lambda Y. M[X:=P]
```

Notice how we carefully write the rules that separate between the variable we want to replace, and not want to replace.

#### Free and Bound

Similarly to how we program, if we have a nested function, sharing the same parameter name, it is treated as its own in the function scope. This behavior is formally called _binding_ and the variable is _bonded_ to the function. If the variable is not introduced in any lambdas before, then it is called _free_.


```
lambda X. ...X... <- X is bounded
lambda X. ...Y... <- Y is free (assuming no lambda Y in between)
```

Using this notion, we can define a predicate `FV(M)` that captures all free variables.

```
FV(X) = {X}
FV(M N) = FV(M) union FV(N)
FV(lambda X. M) = FV(M) / {X}
```

#### What can we do with these programs

You might have been wondering, where are the numbers, and booleans, and where are conditionals? That is a valid question, considering that this language is actually Turing complete. Lambda Calculus is very simple, too simple that we have to "design" a higher layer. We start by defining some expression as an encoding of numbers, booleans, conditionals, and even lists.

They can be defined using Church encoding. Conditionals are the easiest, assume that true is a function that takes 2 arguments, and returns the first one; false takes 2 arguments and returns the second one.

```
true = lambda X. lambda Y. X
false = lambda X. lambda Y. Y
```

Then a conditional `if` is a simple function takes 3 argument, and applying the first to the other 2.

```
if = lambda X. lambda Y. lambda Z. ((X Y) Z)
```

You can see that if we call `if` with the first argument as `true` or `false`, then it returns the second or the third argument. This encoding simulates the intuition of a conditional.

```
if true M N -> ((true M) N) -> M
if false M N -> ((false M) N) -> N
```

Similarly to numbers and lists, Church encoding provides a "simulation" of numbers and lists together with their operations: numbers can perform addition, subtraction, multiplication, lists can perform concatenation, indexing. With these operations, we can somewhat have booleans, numbers, and lists, which is sufficient to write many many programs.


> Readers might ask how to use these encoding in a program. Remember that we can use lambdas and applications to bind a value? We make a sequence of lambdas and applications to register a name. `(lambda true. (lambda false. (lambda if. if true M N) if-definition) false-definition) true-definition`. Not a nice syntax, but operational. You may find people defining `let X = M in N` as a syntactic sugar of `(lambda X. N) M`.

### Typed

The Lambda Calculus language is too simple. That is why the "upgraded" version of it provides us more stuffs to work around. It provides types.

> Some tutorials often group this language to having int types. However, we can just assume that it only has types but no special intrinsic types.

```
t := A | B | t -> t
M,N := X | M N | lambda X: t. M
```

The language is extended with types, where we have some type named `A`, `B` and function type inductively constructed `t -> t`. The syntax is changed to include the type of the argument in a function. With types, it comes with type rules. These rules act as a filter to the set of programs. Therefore, assume a predicate `VALID(M)` which returns true if `M` is "correctly typed", the set of valid programs are then `{M | VALID(M)}`.

Let's say `M : t` is true if `M` has the type `t`. Then `VALID(M) = exists t s.t. M : t`.

For now, we can reason a simple type rule for application. Intuitively, we know that an application `M N` can only work if the first operand `M` is a function so `t_1 -> t_2`. The second operand `N` must matches the type of the function argument `t_1`. And the result should be of the result type of the function `t_2`. Then we can express the rules like below.

```
M : t_1 -> t_2
N : t_1
-------------------
M N : t_2
```

However, the current predicate `M : t` fails when variables appears inside `M`. Consider `X : t`, without a context, we do not know if `X` is the whole program, or `X` is a bounded variable. To overcome this limitation, we add information to the predicate with a context `Gamma`. `Gamma` is just a set (unordered list) of variables and their types, which can be added using the syntax `Gamma,X:t`. If the context is empty, we write `empty`. Let the full predicate be `Gamma |- M : t` and is read as "Given a context `Gamma`, the expression `M` has type `t`". Then the type rules for Typed Lambda Calculus becomes:

```
Gamma |- M : t_1 -> t_2
Gamma |- N : t_1
----------------------- Application
Gamma |- M N : t_2

Gamma,X:t_1 |- M : t_2
--------------------------------------- Lambda
Gamma |- lambda X : t_1. M : t_1 -> t_2

X : t in Gamma
-------------- Variable
Gamma |- X : t
```

The rules above instruct programmers how they can construct well-formed (valid) programs. However, the rules are still incomplete. We have not addressed the types `A`, `B` in our system, there is no expression that has these types. So we cannot do useful stuff with our language just yet.

> We can still create functions, and annotated them correctly. `empty |- (lambda X : A. lambda Y : B. X) : A -> B -> A` should return true.

The language must capable of producing terms of type `A`, `B` and provide a way of using them. Now to make things familiar, we let `A = natural numbers` and `B = boolean`. Then the language becomes:

```
t := natural | boolean | t -> t
X := variables
M,N,P := 0 | 1 | 2 | ... | true | false | X | M N | lambda X : t. M
      | M + N | M - N | M * N
      | M && N | M || N | if M N P
```

Now the language looks more alike the programming language. Because the language is added with numbers and booleans and their operations, we must extend the semantics and type rules. Type rules are easy to extend, and left out. Semantics cannot be expressed without escaping to the real world. The terms `0 | 1 | 2 | ...` are symbols, they do not carry mathematical meaning. But as humans, we know that `0 + 1` should becomes `2`. To express that we often write:

```
M + N -> P if |P| = |M| + |N|
```

The syntax uses `|M|` to "lift" the expression `M` out to the real world. You might have suspected that if `M` is not a number then the conversion cannot happen. Which is why type rules are there to limit programmers from writing program adding two non-numbers together.

### Undeterministic

A careful reader might have noticed that the current language runs undeterministically. For example the following program steps in different ways:

```
((lambda X: natural. X + X) 0) + ((lambda X: natural. X + X) 1)
```

Because the current semantics are too relaxed. If we follow the application rules above, the addition will be added as below:

```
M + N -> M' + N if M -> M'
M + N -> M + N' if N -> N'
```

Although it all yields the same result regardless of the path it takes. This "Undeterministism" behavior is undesirable. To solve this issue, we introduce values and evaluation contexts. Values first, they are things that can no longer be reduced.

```
V := 0 | 1 | 2 | ... | true | false | X | lambda X. M
```

Evaluation contexts break down the program into where it should try to reduce first. Instead of writing rules that are undeterministic like above, we specify a context that says if the current program is in some form, then we start evaluating some term first. For a left to right evaluation, we write the evaluation context like below:

```
E := [] | E M | V E
  | E + M | V + E | E - M | V - E | E * M | V * E
  | E && M | V && E | E || M | V || E
  | if E M N
```

Evaluation Context has a hole `[]`. This hole means that we can plug in an expression `M`, and `E[M]` becomes the whole program. A useful theorem that we also have: "a program can be _uniquely_ decomposed into `E[M]`".

The program should be deterministic, if we only reduces the `M` in `E[M]`. Intuitively, because a program can uniquely decompose into `E[M]`, `M` is the only option to step and gives a new program, which is then decompose into `E_1[M_1]`, so on and so on.


> Theoretically, one would try to prove the following theorem: If `M -> M_1` and `M -> M_2` then `M_1 = M_2`. Although it's fuzzy what `M_1 = M_2` means. I will not get to this, because `lambda X. X = lambda Y. Y` under alpha-conversion.

### Type Safety

With all the definitions, we can now prove that our language, if it is valid, then it runs, and it gives out a value *if it ends*. Previously we defined `VALID(M) = exists t s.t. empty |- M : t`, it is valid to ask can we find type `t` for every program? In fact, the problem is actually two ways. If you give me a type `t` and ask if `empty |- M : t` then the we are doing type checking. If you give me a program `M` and ask me to find `t` then it is type synthesis. We are familiar with type checking, because we usually define our function with types as hints and the compiler/linter validates against that hint. However, in PL Theory, we mostly define the system to do type synthesis.

Type synthesis works algorithmically bottom up. So when we do type synthesis, the algorithm walks the type rules `Gamma |- M : t`, and recursively synthesises the premisses until a valid `t` is found. Then the algorithm propagates that type `t` to the result. If the type rules are defined correctly, it should be able to do this for any program `M`.

> The distinction between type checking and type synthesis appears clearer when bidirectional typing is discussed.

Regardless, when we say that `empty |- M : t` we mean that program `M` has type `t` and we do not need to care about where `t` is obtained from. Next, we can state a theorem that says a well-typed program `M` should always "runable".


#### Type Safety Theorem

- If `empty |- M : t` then `M` is a value or `M -> M_1` for some `M_1`
- If `empty |- M : t` and `M -> M_1` then `empty |- M_1 : t`

These two clauses satisfy the type safety. The first one says that if the program is well-typed, then it either a value (program stops) or that it can make a step. The second one says that if the program is well-typed, and takes a step, then the next step is also well-typed. Together we can reason that a well-typed program `M` runs to a value or runs and never stops.

### Without types?

Life is easy with types as we have discussed from untyped to typed language. However, some research does not integrate type system into their language(s). The reason for this is we can still reason about the program runtime, by defining an evaluation function `EVAL(M)` and stuck states `STUCK`.

```
EVAL(M) = true if M -> true
EVAL(M) = false if M -> false
EVAL(M) = 0 if M -> 0
...
EVAL(M) = lambda X. N if M -> lambda X. N (with alpha-conversion)
EVAL(M) = stuck if M -> M' and M' in STUCK
```

Depending on how strong the theorem to be proven is, `EVAL(M)` can be vaguely defined:

```
EVAL(M) = opaque if M -> lambda X. N
```

## Advanced PL Theories

I want to go through the big ideas in PL research. I have read to some extend of these theories, but have not worked on them. I hope I can make it clear for myself while writing this, and clear for you when reading this.


### Mutable Cells (Pointers)

### Linear Type Systems

### Bidirectional Type Systems

### Choreography

### Pi-Calculus

### Dependent Type Theory
