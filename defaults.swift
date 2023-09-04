
let add = NativeProgram("add", 2)
let neg = NativeProgram("negative", 1)
let equals = NativeProgram("equals", 2)

let defaultPrograms = [
    Arg(): Program(native: add),
    Arg(): Program(native: neg),
    Arg(): Program(native: equals)
]

let defaultModifications = [
    // factor out all occurences of some global arg
    Modification("Abstraction") { a, p, programs in
        var args: [Arg] = []
        p.expr.getGlobalArgs(Array(programs.keys), &args)
        guard let arg = args.randomElement() else { return nil }
        let newArg = Arg()
        let newExpr = Expr.lambda(newArg, p.expr.replace(arg, newArg))
        return Program(expr: newExpr)
    },
    Modification("Composition") { a, p, programs in
        // f => a => b => g (f a) b
        let fArity = p.arity()
        var fArgs: [Arg] = (0..<fArity).map { _ in Arg() }
        let fExp = Expr.ap([.arg(a)] + fArgs.map(Expr.arg))

        let (gId, g) = programs.randomElement()!
        let gArity = g.arity()
        let gArgs = (0..<(gArity-1)).map { _ in Arg() }
        let gExp = Expr.ap([.arg(gId), fExp] + gArgs.map(Expr.arg))

        let lambda = (fArgs+gArgs).reduce(gExp, { r, a in
            Expr.lambda(a, r)
        })
        return Program(expr: lambda)
    }

]

