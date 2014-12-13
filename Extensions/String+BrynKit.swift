//
//  String+BrynSwift.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 6.16.14.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa


extension BrynSwift
{
    class Strings
    {
        internal class func sanitizeStringForFileURLConstructor(string:String) -> String
        {
            var newStr = string

            // remove "file://" protocol prefix if it exists.  the NSURL(fileURLWithPath:) constructor adds this for us.
            let fileURLPrefix = "file://"
            if newStr.hasPrefix(fileURLPrefix) {
                newStr = newStr.bk_substringFromIndex(fileURLPrefix.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            }

            // remove percent encodings if they exist.  probably should either 1) check to make sure these are in the string or 2) make it an option (via a function arg)
            if let withoutURLEncoding = newStr.stringByRemovingPercentEncoding? {
                newStr = withoutURLEncoding
            }

            return newStr
        }



        internal class func substringFromIndex(string:String, index: Int) -> String
        {
            let newStart = advance(string.startIndex, index)
            return string[newStart ..< string.endIndex]
        }



        internal class func substringToIndex(string:String, index: Int) -> String
        {
            let newEnd = advance(string.startIndex, index)
            return string[string.startIndex ..< newEnd]
        }

    }
}



public extension NSString
{
    public func bk_sanitizeForFileURLConstructor() -> String {
        return BrynSwift.Strings.sanitizeStringForFileURLConstructor(self)
    }

    public var bk_filename : String { return lastPathComponent }
    public var bk_basename : String { return bk_filename.stringByDeletingPathExtension }
    public var bk_dirname  : String { return stringByDeletingLastPathComponent }
}


public extension String
{
    public var bk_filename : String { return lastPathComponent }
    public var bk_basename : String { return bk_filename.stringByDeletingPathExtension }
    public var bk_dirname  : String { return stringByDeletingLastPathComponent }

    public subscript (i: Int) -> String {
        return String(Array(self)[i])
    }

    public subscript (r: Range<Int>) -> String
    {
        var start = advance(startIndex, r.startIndex)
        var end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }

    public func bk_replace(substr: String, with replacement: String) -> String
    {
        return stringByReplacingOccurrencesOfString(substr, withString:replacement, options:NSStringCompareOptions.LiteralSearch, range:nil)
    }

    public func bk_split(delim: String) -> Array<String> {
        return componentsSeparatedByString(delim)
    }

    public func bk_sanitizeForFileURLConstructor() -> String {
        return BrynSwift.Strings.sanitizeStringForFileURLConstructor(self)
    }

    public func bk_substringFromIndex(index: Int) -> String {
        return BrynSwift.Strings.substringFromIndex(self, index:index)
    }

    public func bk_substringToIndex(index: Int) -> String {
        return BrynSwift.Strings.substringToIndex(self, index:index)
    }
}








