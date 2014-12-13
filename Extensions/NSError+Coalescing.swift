//
//  NSError+Coalescing.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Dec 9.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


public extension NSError
{
    public var isMultiError : Bool {
        return (userInfo?["is multi error"] as? Bool) ?? false
    }

    public var errors : [NSError] {
        return (userInfo?["errors"] as? [NSError]) ?? []
    }

    public class func multiError(errors:[NSError]) -> NSError {
        return NSError(domain:"com.illumntr.multi-error", code:1, userInfo: ["isMultiError": true, "errors" : errors])
    }

    public var multiErrorDescription : String {
        if isMultiError {
            let strings = map(enumerate(errors)) { "\($0.0). \($0.1.localizedDescription)" }
            return join("\n", strings)
        }
        else {
            return description
        }
    }


    public class func coalesceErrors(first:NSError, other:NSError) -> NSError
    {
        var newErrors = [NSError]()

        first.isMultiError  ? newErrors.extend(first.errors)
                           : newErrors.append(first)

        other.isMultiError ? newErrors.extend(other.errors)
                           : newErrors.append(other)

        return NSError.multiError(newErrors)
    }


    public func coalesceWithError(other:NSError) -> NSError {
        return NSError.coalesceErrors(self, other:other)
    }
}
