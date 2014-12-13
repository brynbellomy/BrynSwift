//
//  Operators.Functional.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Dec 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import LlamaKit

/**
    Most of these operators are extension of or slightly-tweaked versions of stuff in LlamaKit.
 */


infix operator <!> { associativity left precedence 100 }

/// Applies `f` to the value in the given result.
///
/// In the context of command-line option parsing, this is used to chain
/// together the parsing of multiple arguments. See OptionsType for an example.
public func <!><T, U>(f: T -> U, value: Result<T>) -> Result<U> {
    return value.map(f)
}

/// Applies the function in `f` to the value in the given result.
///
/// In the context of command-line option parsing, this is used to chain
/// together the parsing of multiple arguments. See OptionsType for an example.
public func <!><T, U>(f: Result<(T -> U)>, value: Result<T>) -> Result<U> {
    switch (f, value) {
    case let (.Failure(left), .Failure(right)):
        let one = left as NSError
        let two = right as NSError
        return failure(one.coalesceWithError(two))


    case let (.Failure(left), .Success):
        return failure(left)

    case let (.Success, .Failure(right)):
        return failure(right)

    case let (.Success(f), .Success(value)):
        let newValue = f.unbox(value.unbox)
        return success(newValue)
    }
}

public func <!><T, U>(f: T -> U, value: T?) -> Result<U> {
    return map(value, f) ?? failure()
}

public func <!><T, U>(f: Result<(T -> U)>, maybeValue: T?) -> Result<U> {
    return f.flatMap { fn in
        map(maybeValue) { fn($0) |> success } ?? failure()
    }
}





//prefix operator ‡ {}


///**
//    The reverse-args-and-curry operator (type shift+option+7).  Useful in bringing the Swift stdlib collection functions into use in functional pipelines.
//
//    For example: `let lowercaseStrings = someStrings |> ‡(map) { $0.lowercaseString }`
//*/
//public prefix func ‡
//    <T, U, V>
//    (f: (T, U) -> V) -> U -> T -> V {
//        return curry_swap(f)
//}
//
//














