# Automated Programmer

A basic clone-in-spirit of the Automated Mathematician by Douglas Lenat[^1]. Since AM has had its Mathematician status revoked for various reasons,[^1] I call my clone Automated Programmer. The purpose of AP is to bash out programs (in a LISP-like DSL) until you find one that you like.

## Build Instructions

```
swiftc utils.swift program.swift modification.swift defaults.swift main.swift -o main
./main
```

## Expected Updates

* Switch to the Swift Package Manager
* DSL
    * implement static type checking
    * implement the execution of the language
    * expand the standard library to represent arbitrary computable functions
    * extract the DSL into a separate product
* AP
    * extend the mutation functions to generate arbitrary computable programs
    * improve UI with modes for watching the AP search, testing functions in a REPL, updating the library of functions, directing AP's attention, etc.
    * enable AP to think without user involvement, e.g. brute-forcing a user-specified problem(s)

## Future Work

* Program modifications and heuristics are themselves programs that can be searched (Eurisko[^1]).
    * modification programs should be able to access the problem statement, if applicable, as that can lead to interesting behavior and faster solutions by generalizing between different problems
* Instead of demanding an imperative solution to a problem, what if the program generates pattern objects that represent regularities found in the input? The solution can then be reconstructed by satisfying the patterns. The question is: is the space of pattern definitions and matches more suitable for learning to solve interesting problems? Though patterns have the same computational capability as Eurisko functions, they may be more suited to solving hard problems that themselves fundamentally require some guesswork, a.k.a. creativity. If this hypothesis is correct, we can expect that this algorithm will perform well on the Abstract Reasoning Corpus.[^1]

[^1]: citation needed



