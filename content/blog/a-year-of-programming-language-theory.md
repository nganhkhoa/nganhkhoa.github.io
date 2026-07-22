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

> Disclaimer: You do not need to understand complex stuffs to get started on PL. However, most ideas in PL are connected with logic and category theory. Although I said 1 year, I actually started reading PL years ago, but cannot wrap my head around. I hope that this blog can be useful as a map to getting started with PL research.

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

Set defines a collection of elements (items). Consider the set of boolean `{true,false}` is a collection of two elements. Boolean set are finite, meaning they have finite elements. The set of natural numbers `{0,1,2,...}` is a collection of infinite elements, therefore it is infinite.

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

After this, the semantics is added with a simple rule:

```
M -> M'
-------------
E[M] -> E[M']
```

This rule makes the whole program steps, and we only need to write rules that transform a single term. We need to modify the rules into using "values", so the application rules will be:

```
(lambda X. M) V -> M[X:=V]
```

We effectively remove the undeterministic rules `M N -> M' N` and `M N -> M N'` because the evaluation will be decomposed into the current to-be-evaluated term. Now the language is determnisitic.

> Theoretically, one would try to prove the following theorem: If `M -> M_1` and `M -> M_2` then `M_1 = M_2`. Although it's fuzzy what `M_1 = M_2` means, in fact this equivalance is up to alpha equivalance.

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

## Other PL Theories

This section contains short introduction of big ideas in PL research. They are provided with links for deep dive. May contain wrong facts.

Most PL research revolves around the Type System.

#### System F

The type system introduced before is limited. We cannot type `id = lambda x: ?. x` function, for example. Or if we have types `integer` and `float`, what would the type of `add = lambda x: ?. lambda y: ?. x + y` be? To solve this issue, we need polymorphism in the type system.

A simple polymorphism is to extend the language to allow for types as arguments. So instead of `addInt` and `addFloat` having the same definition with different types, we make `add integer` and `add float` where `add = lambda t. lambda x: t. lambda y: t. x + y`. Of course, the language now allows application of term to a type. In fact, the syntax that is commonly accepted is:

```
M,N = X | M N | M[T] | lambda X: T. M | Lambda X. M
T = X | forall X. T | ...

maybe wrong, need to read again
Gamma |- M : T
----------------------------------
Gamma |- Lambda X. M : forall X. T

(Lambda X. M)[T] -> M[X:=T]
```

Where `Lambda X. M` introduces a new type variable `X`, and `M[T]` applies the type `T` to `M`. Some languages will differentiate between variables for terms and types, often using `alpha,beta` for type variables.

This is called as System F.

#### System F`omega`

Previously, we introduced `Lambda X. M`, which is different from `lambda X: T. M`. What happens if we allow type of a type variable `Lambda X: ?. M`? But wait, what does this even mean? Let take a step back and see where System F breaks.

Assume our type system has list and set `T = list T | set T | ...`, can we provide a unified function to both `list` and `set`? Something that looks like `count = Lambda T. lambda X: list/set T. M`. System F breaks at this point. And System F`omega` tries to solve this by introducing a "type" for type `T`, separating from basic types to "higher" types. This notion is introduced as kinds `K`.

```
K = * | K -> K
T = int | bool | T -> T | alpha | forall alpha: K. T | lambda alpha: K. T
M,N = lambda X: T. M | Lambda alpha: K. M | M[T] | X | M N
```

This allows us to build up types that depends on other types. So we can build `count = Lambda C: * -> *. Lambda T: *. lambda X: C T. M`, with `X` has the type of some container `C` of some basic type `T`.

This type system is named System F `omega`.

#### Dependent Types

Dependent types take a different approach to the above systems. In dependent types, you can have terms inside types `T = ... | ... M ...`. This allows you to express types constrained with an expression, such as `List Int 10` is a list of 10 integer elements. Of course, it can be used flexibly, so we can provide the type for list concatenation as:

```
concat : List T n -> List T m -> List T (n + m)
```

> The 3 previously introduced System F, System F `omega`, and Dependent Types forms a Lambda Cube stems from typed lambda calculus, branching into different paths depending on the type/term relation. If a language supports all of them, we have a calculus of constructions.

#### Subtyping

Subtyping uses a relation between types. Subtyping shines mostly in Object-Oriented Programming, but it also helps with polymorphism when we define `int < float` and `add1 : float -> float = lambda x: float. x + 1` works for `add1 (int)2`. The type system allows using a "lower" type for argument and result, both will be casted correctly when used.

```
Gamma |- M : t_1 -> t_2
Gamma |- N : t_3
t_3 < t_1
-----------------------
Gamma |- M N : t_2


Gamma,X : t_1 |- M : t_3
t_3 < t_2
--------------------------------------
Gamma |- lambda X: t_1. M : t_1 -> t_2
```

#### Bidirectional Typing

Remember before we say that `Gamma |- M : t` can be understood as type checking or type inference, depending on the language we design? Usually in PL people lean towards type inference, given a program `M` and try to infer the type `t` by dissecting the program `M` and its sub-terms recursively. In coding, however, most languages use type checking, the programmers specify a function `f` of some type `t`, and the compiler/linter checks if the code of the function matches the declared type.

Bidirectional Typing unifies the workflow into checking `Gamma |- M <- t` and inferecing `Gamma |- M -> t`. They are useful for polymorphism type inference.

#### Curry-Howard-Lambek Correspondence

Type Systems are pretty much related (or rather, inspired) to Logic. Later, they also find the same correspondence to Category Theory. This equivalency is named Curry-Howard-Lambek Correspondence.

Simply typed lambda calculus can be mapped to predicates in Logic and objects in Category Theory. Because of this, if we can map things from the type system to Logic or Category Theory, then we can "use" the properties proven in Logic or Category Theory in our type system.

To be updated. Should be a table here about the equivalance of them.

#### Substructural Type Systems

The typing context `Gamma` thus far supports three structural rules: Weakening, Contraction, and Exchange. Removing any of these rules restricts how variables can be used. Because it misses some rules, it is given the name substructural.

- Weakening allows the unused variables. Removing Weakening forces every variable to be used at least once.
- Contraction allows a variable to be used multiple times. Removing Contraction forces one-time use of a variable.
- Exchange allows reordering variables. Removing Exchange forces variables to be used orderly.

People also gave names to substructural type systems to differentiate them.

| Type System | Weakening (Drop) | Contraction (Duplicate) | Exchange (Reorder) | Variable Usage Constraint |
| :--- | :---: | :---: | :---: | :--- |
| **Standard** | Yes | Yes | Yes | Any number of times, in any order. |
| **Affine** | Yes | No | Yes | **At most once.** |
| **Relevant** | No | Yes | Yes | **At least once.** |
| **Linear** | No | No | Yes | **Exactly once.** |
| **Ordered** | No | No | No | **Exactly once**, orderly. |

Usually controlling variables used is hard, that is why the design of these systems are often algorithmic. For example typing for an application `M N` will first find all variables used in `M` and let the rest be in usable in `N`. Rather than trying to iterate through all possible "disjoint" sets of context.

#### Call-By-Push-Value

A notable type system that differentiate between values and computations. Previously, our language produces no side effect, and thus a function is considered as a value. However, when a function makes side effects, calling them would produce effects, potentially altering the environment. Capturing the effects is not new, but this type system separates them by providing distinction between values and computations.



##### Gradual Type Theory

Gradual Type introduces an interaction between typed and untyped code. Languages often rely on the run-time to check if the type of an object is "compatible". Before gradual type, object proxies are used. Objects are wrapped into a proxy of some signature, and abort if the object does not have the methods/fields. Gradual type theory first started off with adding an unknown type `T = ? | ...`, and casts from one type to another `M = (T)M | ...`.



> From now we move on to stuffs that are NOT type systems, but would also benefit from type systems if you gave them one. But they are more on how the "programs" run.


### Effects

Practical programming languages have effects, such as printing or reading a file or reading from the internet. These effects when executed modify the state and environment. Most programming languages ignore this problem, Haskell approach this problem by limiting effects to its type system. A novel approach to effects is by handlers, named Effect Handlers.

This section is focused on how to encode effects into the formal language.

#### Mutable Cells (Pointers)

Mutable cells, or boxes, is like the pointers in C. The language is built-in with terms to create a new box, to get a box's value, and to set a box's value.

```
M,N = new(M) | get(M) | set(M, N)
```

The semantics are updated to "remember" boxes. We do this by assuming every `new(M)` creates a new location, and this location is "remembered" by the run-time. Assume an existence of a memory-controller `Mem` that is a mapping between locations and its value. Then we can express the semantics as:


```
Mem,new(V) -> Mem[loc:=V],loc where loc is new in Mem
Mem,get(loc) -> Mem,V where V is loc -> V in Mem
Mem,set(V,loc) -> Mem[loc:=V],loc where loc is in Mem
```

Of course, this is just a small part. The typing rules must be updated if we want to prove type safety as well.

#### Effect Typing

Gifford and Lucassen, to be updated.

#### Monad

Moggi's Monad, to be updated.

#### Handlers

Handlers are added to make Effect Handler Calculus, where the effects are just names and can be invoked similarly to an application. A handler is installed providing the run-time what to do when the effects is invoked. Originally, the calculus is based on Call-By-Push-Value, where effects are computations. However, some research adapt it to System F and evaluation contexts, making the semantics more familiar to what we discussed in here.

The language is extended with two terms: effect invocation `perform(name)` and installing a handler `handle(h, M)`. A handler is just a mapping between the operation name and its function `name -> lambda x. lambda kont. M`. The handler function takes two arguments, the operation argument and the continuation, expressed as a function, contains the code to continue after the operation returns. To invoke an effect, just perform an invocation `perform(name) M` will run the effect `name` with the value `M`. Performing an effect is a "look up" operation for handlers installed prior. To help with our semantics, we provide a metafunction that collects all handle-able effects in the evaluation context `covered(E)`.

```
E = handle(h, E) | ...

shallow:
handle(h, E[perform(name) V]) -> f V (lambda x. E[x])
  where (name -> f in h) and name not in covered(E)

deep:
handle(h, E[perform(name) V]) -> f V (lambda x. handler(h, E[x]))
  where (name -> f in h) and name not in covered(E)
```

There are two implementations of handlers, a shallow version and a deep version. Shallow handler removes the handler so the effect is executed one time only. A deep handler re-installs the handler so the effect can be invoked multiple times.

### Software Contracts

Contracts extend the language with "protected terms" `mon(M, N)` where `M` is the contract, and `N` is the term to be protected. For example `mon(lambda X. X > 10, 8)` throws an error when running the program. Using the term as contracts has some limitation, function contracts cannot be expressed easily. Therefore, the language is extended with a contract term `K`.

```
K = flat(M) | K -> K
M,N = mon(K, M) | ...
E = mon(K, E)
```

Where `flat(M)` is the contract for a simple value, and `K -> K` is the contract for functions. The semantics for contracts are quite complex because a protected function runs no contract. The common consensus is to reduce into an intermediate value `guard(K, M)` and depending on the use of guard, the reduction can step.

```
mon(flat(M), V) -> if (M V) V error
mon(K_1 -> K_2, M) -> guard(K_1 -> K_2, M)
guard(K_1 -> K_2, M) N -> mon(K_2, M mon(K_1, N))
```

Readers can see that the contract terms are "separated" from program terms. This separation has a friction, so some models adjust to allow "first-class" contracts `mon(M, N)`, so programmers can use an expression to build a contract at run-time rather than compile time.

Contracts are usually attached with locations. These locations give hints to programmers what code is responsible for the error. These locations are explicit and attached to the monitor term `mon(l_pos,l_neg, K, M)`. Practically, the programmers are not responsible for annotating these locations, and often automatically attached during compilation.

### Choreography

Language describe programs, and we want programs to talk together. What we discussed until now is just a program running on its own, and choreography is a way to build programs that talk with each other.

Choreography languages use labels/names `l`, and allow a way to send and receive between "names". To send and receive programmers write `l_1.M => l_2.(x); N` (I left out variables of system here, and use `M,N` as generic term). The program is then compiled into two versions, one for `l_1` and one for `l_2`. In this way, we can write one big program called system (or a choreography), and have the correct code for all participating programs.

The whole system "runs" by taking the next step appropriately:

```
l_1.V => l_2.(X); N -> N[l_2|X:=V] if l_1 and l_2 is allowed to run
```

The substitution is guarded to ensure the variables are modified for the correct component. Components cannot run without consideration. Imagine that `l_1` is talking to `l_3`, then `l_1` is blocked until the communication with `l_3` concludes, and only then can it communicate with `l_2`.

A single party (name) cannot run the whole system. Therefore, the system is compiled into different program for a single component. This is called Endpoint Projection (EPP). Take a system, we know the participating parties (names), and compile the program for that party.

```
compile(l_1, l_1.M => l_2.(x); N) --> send M to l_2; compile(l_1, N)
compile(l_2, l_1.M => l_2.(x); N) --> let x = receive from l_1; compile(l_2, N)
```

The compilation compiles the system into another language, that has `send` and `receive` as in the rules above. Both the system and the compiled languages have their semantics defined. The important theorem is to prove that they behave the same.

> Roughly: If the system of parties L runs and output state S, mapping of names to their local storage, then programs P_l, compiled from the system, runs and output the state S', the following is true S[l] = S' for all l in L

### Pi-Calculus

Pi-Calculus actually comes before Choreography and also try to describe program communication. Program can send and receive through names. However, they are two separated expression: send is `bar(x) y`, receive is `x(y)`. Two programs running together are expressed with a separation `M | N`, for example `bar(x) y | x(y)`.

The Pi-Calculus has one important reduction rule, that steps the program if the send and receive are pair correctly:

```
bar(x) y; M | x(z); N -> M | N[z:=y]
```

The Pi-Calculus can be typed, and it can be "upgraded" to higher-order Typed Pi-Calculus. In Pi-Calculus, the important theorem is Congruence, that is the order of the processes does not matter (concurrency), and the final states are the same.

## Implementations

This is programming language research, you need to implement the language. But not in its full potential.

In PL, we mostly write interpreter, so the language runs using the rules we defined. Usually, this would involved writing a full parser, and the running machine. I have seen research published with the language implementation, I guess it is normal in this research field. But luckily there are some other ways around.

### Racket language implementations

Racket is a language made by PL researchers for PL researchers. You can define a new language on top of Racket using macros. Basically a macro that is parsed by Racket and compile into Racket code.

### Redex PLT

Racket comes with Redex PLT, a framework to define language models, and their semantics. Using Redex PLT, languages can be defined, and run tests inside the framework. Although I would say the documentation is not intuitive, and there are not a lot of tutorials to solve certain problems.

### Mechanized Proofs

Recent PL research leans towards mechanized proofs. Coq and Agda, along with other frameworks, allow defining language models and prove their theorems. Proofs are checked automatically, type check under the dependently typed system, so it gives a strong assurance. Although the language cannot be run, but the theorem are proven so it should work as per the theorem states.

### Traditional

Still there are still a lot of PL research without an implementation, or mechanized proofs. The language theorems are proven in detailed and attached into the appendix of the extended version of the paper, usually available online.

## Advice

If you are getting started on the PL research, read the proofs for basic simply typed lambda calculus. Then move on to some easier ones. Some research models use a lot of symbols, and it is expected that you understand what those symbols are. Of course, once you know the main model, you can ignore the "familiar" parts. I have studied for some time, now I understand the lambda calculus, system F, system F `omega`, the software contract models, the effect handler models (Koka). It takes a lot of time to understand all of the models that you are working with and takes a lot more time to get into the proofs, or proving the theorem by yourself.

Maybe in the future I can get to write about proving stuffs in PL. I am struggling a lot because I only have simple math backgrounds, and there's not a lot of materials for proving complex stuffs in PL. In PL you will be doing these proof techniques:

- Induction, because we use inductive, "recursive" sets for our language
- Bisimilarity, and simulation proofs
- Logical relations

And more proof techniques that I see professors working on PL created. It is truly a lot to learn.
