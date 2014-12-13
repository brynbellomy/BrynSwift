//
// this is some shit i got from https://github.com/thoughtbot/roster
//


// bind operator
infix operator >>- { associativity left precedence 150 }

public func >>-<A, B>(a: A?, f: A -> B?) -> B? {
    switch a {
    case .Some(let x): return f(x)
    case .None: return .None
    }
}


// fmap operator (functors)
infix operator <^> { associativity left precedence 101 }

public func <^><A, B>(f: A -> B, a: A?) -> B? {
    switch a {
    case .Some(let x): return f(x)
    case .None: return .None
    }
}


// apply operator (applicative functors)
infix operator <*> { associativity left precedence 101 }

public func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
    switch f {
    case .Some(let fx): return fx <^> a
    case .None: return .None
    }
}
