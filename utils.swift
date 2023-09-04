import Foundation

extension Sequence {
    func weightedRandomElement(_ f: (Self.Element) -> Double) -> Self.Element {
        let weights = self.map { e in (e, f(e)) }
        let sum = weights.reduce(0.0) { r, w in r + w.1 }
        var thresh = Double.random(in: 0..<sum)
        return weights.first { w in
            thresh -= w.1
            return thresh <= 0
        }?.0 ?? weights.last!.0
    }
}

func |<A, B>(lhs: A, rhs: @escaping (A) -> B) -> B {
    return rhs(lhs)
}

func |<A, B, C>(lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> ((A) -> C) {
    return { a in rhs(lhs(a)) }
}

func force<T>(_ x: T?) -> T { x! }

func affirmative(_ str: String) -> Bool? {
    switch str.lowercased() {
    case "":
        return nil
    case "y", "yes":
        return true
    default:
        return false
    }
}

@discardableResult func prompt(_ message: String) -> String? {
    print(message, terminator: " ")
    return readLine()
}

