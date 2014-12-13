//
//  Operators.Assignment.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Dec 10.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit


infix operator =?? { associativity left precedence 99 }
infix operator ??= { associativity left precedence 99 }

/**
    The set-if-non-nil operator.  Will only set `lhs` to `rhs` if `rhs` is non-nil.
 */
public func =?? <T>(inout lhs:T, maybeRhs: T?) {
    if let rhs = maybeRhs? {
        lhs = rhs
    }
}


/**
    The set-if-non-nil operator.  Will only set `lhs` to `rhs` if `rhs` is non-nil.
 */
public func =?? <T>(inout lhs:T?, maybeRhs: T?) {
    if let rhs = maybeRhs? {
        lhs = rhs
    }
}


/**
    The set-if-non-failure operator.  Will only set `lhs` to `rhs` if `rhs` is not a `Result<T>.Failure`.
 */
public func =?? <T>(inout lhs:T?, result: Result<T>) {
    lhs =?? result.value
}


/**
    The initialize-if-nil operator.  Will only set `lhs` to `rhs` if `lhs` is nil.
 */
public func ??= <T : Any>(inout lhs:T?, rhs: @autoclosure () -> T)
{
    if lhs == nil {
        lhs = rhs()
    }
}


/**
    The initialize-if-nil operator.  Will only set `lhs` to `rhs` if `lhs` is nil.
 */
public func ??= <T : Any>(inout lhs:T?, rhs: @autoclosure () -> T?)
{
    if lhs == nil {
        lhs = rhs()
    }
}


/**
    Nil coalescing operator extended to handle `LlamaKit`'s `Result<T>` type.
 */
public func ?? <T> (lhs:T?, rhs:Result<T>) -> Result<T>
{
    if let lhs = lhs? {
        return success(lhs)
    }
    else {
        return rhs
    }
}




