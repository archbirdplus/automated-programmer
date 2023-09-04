
struct NativeProgram {
    var name: String
    var arity: Int

    init(_ name: String, _ arity: Int) {
        self.name = name
        self.arity = arity
    }
}

// eventually should gain type info
struct Arg: Equatable, Hashable {
    var id: Int

    init() {
        id = Int.random(in: Int.min..<Int.max)
    }
}

// One s-expression node (or leaf)
// An expr is a valid program iff its only args are defined as "global"
indirect enum Expr {

    case arg(Arg)           // s-exp leaf - bound variable
    case lambda(Arg, Expr)  // s-exp node - variable binding
    case ap([Expr])   // s-exp node - application
    case native(NativeProgram)

    func isValidProgram(global: [Arg], argStack: inout [Arg]) -> Bool {
        switch self {
        case let .arg(a):
            return global.contains(a) || argStack.contains(a)
        case let .lambda(a, e):
            argStack.append(a)
            let valid = e.isValidProgram(global: global, argStack: &argStack)
            argStack.removeLast()
            return valid
        case let .ap(es):
            return es.allSatisfy { e in
                e.isValidProgram(global: global, argStack: &argStack)
            }
        case .native(_):
            return true
        }
    }

    func getGlobalArgs(_ global: [Arg], _ tmp: inout [Arg]) {
        switch self {
        case let .arg(a):
            if !tmp.contains(a) && global.contains(a) { tmp.append(a) }
        case let .lambda(_, e):
            e.getGlobalArgs(global, &tmp)
        case let .ap(es):
            for e in es {
                e.getGlobalArgs(global, &tmp)
            }
        case .native(_):
            break
        }
    }

    func replace(_ old: Arg, _ new: Arg) -> Expr {
        switch self {
        case let .arg(a):
            return a == old ? .arg(new) : self
        case let .lambda(a, e):
            return .lambda(a, e.replace(old, new))
        case let .ap(es):
            return .ap(es.map { e in e.replace(old, new) })
        case .native(_):
            return self
        }
    }

    func stringify(global: [Arg: Program], stack: inout [Arg: String]) -> String {
        switch self {
        case let .arg(a):
            return global[a]?.name ?? stack[a]!
        case let .lambda(a, e):
            stack[a] = String(UnicodeScalar(97+stack.count)!)
            let str = "\\\(stack[a]!) -> \(e.stringify(global: global, stack: &stack))"
            stack[a] = nil
            return str
        case let .ap(es):
            return "(\(es.map { $0.stringify(global: global, stack: &stack) }.joined(separator: " ")))"
        case let .native(n):
            return n.name
        }
    }

    func arity() -> Int {
        if case let .lambda(_, e) = self { return 1 + e.arity() }
        else { return 0 }
    }

}

// TODO: Add parents list here, for boosting purposes
class Program {

    var name: String = ""
    var score: Double = 0.5
    var expr: Expr

    init(native: NativeProgram) {
        let args = (0..<native.arity).map { _ in Arg() }
        var e = Expr.ap([Expr.native(native)] + args.map(Expr.arg))
        for a in args {
            e = Expr.lambda(a, e)
        }
        self.expr = e
        self.name = native.name
    }

    init(expr: Expr) {
        self.expr = expr
    }

    func boost() {
        score = 0.1 + 0.9*score
    }

    func unboost() {
        score = score * 0.9
    }

    func isValidProgram(global: [Arg]) -> Bool {
        var stack: [Arg] = []
        return expr.isValidProgram(global: global, argStack: &stack)
    }

    func stringify(global: [Arg: Program]) -> String {
        var stack: [Arg: String] = [:]
        return expr.stringify(global: global, stack: &stack)
    }

    func arity() -> Int {
        return expr.arity()
    }

}

