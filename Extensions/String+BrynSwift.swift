//
//  String+BrynSwift.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 6.16.14.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import Funky


public extension BrynSwift
{
    public struct Strings
    {
        public static func sanitizeStringForFileURLConstructor(string:String) -> String
        {
            var newStr = string

            // remove "file://" protocol prefix if it exists.  the NSURL(fileURLWithPath:) constructor adds this for us.
            let fileURLPrefix = "file://"
            if newStr.hasPrefix(fileURLPrefix) {
                newStr = newStr |> substringFromIndex(countElements(fileURLPrefix))
            }

            // remove percent encodings if they exist.  probably should either 1) check to make sure these are in the string or 2) make it an option (via a function arg)
            if let withoutURLEncoding = newStr.stringByRemovingPercentEncoding? {
                newStr = withoutURLEncoding
            }

            return newStr
        }



    }
}



public extension String
{
    public subscript (i: Int) -> String {
        return String(Array(self)[i])
    }

    public subscript (r: Range<Int>) -> String
    {
        var start = advance(startIndex, r.startIndex)
        var end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }

    public func bk_replace(substr: String, with replacement: String) -> String {
        return stringByReplacingOccurrencesOfString(substr, withString:replacement, options:NSStringCompareOptions.LiteralSearch, range:nil)
    }

    public func bk_sanitizeForFileURLConstructor() -> String {
        return BrynSwift.Strings.sanitizeStringForFileURLConstructor(self)
    }

//    public func bk_substringFromIndex(index: Int) -> String {
//        return substringFromIndex(self, index:index)
//    }
//
//    public func bk_substringToIndex(index: Int) -> String {
//        return BrynSwift.Strings.substringToIndex(self, index:index)
//    }
}








