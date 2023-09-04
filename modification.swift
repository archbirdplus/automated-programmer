
class Modification {

    var score: Double = 0.5
    var name: String
    var modify: (Arg, Program, [Arg: Program]) -> Program?

    init(_ name: String, _ f: @escaping (Arg, Program, [Arg: Program]) -> Program?) {
        self.name = name
        self.modify = f
    }

    func boost() {
        score = 0.1 + 0.9*score
    }

    func unboost() {
        score = score * 0.9
    }

}

