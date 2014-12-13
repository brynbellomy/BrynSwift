//
//  Collections+BrynSwift.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 6.16.14.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Cocoa
import SwiftLogger


public extension BrynSwift
{
    public class func logArray<T>(logLevel:DefaultLogLevel, _ prefix:String, _ array:[T], formatClosure:(T) -> String)
    {
        let formatted = map(array, formatClosure)
        let joined = join(", ", formatted)
        lllog(logLevel, "\(prefix) [ \(joined) ]")
    }

//    public class func formatArray<T>(array:[T], formatClosure:(T) -> String) -> String
//    {
//        let descriptions : [String] = map(array, formatClosure)
//        let descriptionsStr = join("\n", descriptions).bk_replace("\n", with:"\n\t")
//        return "[\n\(descriptionsStr)\n]"
//    }
//
//    public class func formatArray<T : Printable>(array:[T]) -> String
//    {
//        let descriptions : [String] = map(array) { return "\t\($0.description)" }
//
//        let descriptionsStr = "\n".join(descriptions).bk_replace("\n", with:"\n\t")
//        return "[\n\(descriptionsStr)\n]"
//    }



    public class func colorDescription(dict:[String : AnyObject]) -> String
    {
       let keysAsStrings = Array(dict.keys)
       let lengths       = map(keysAsStrings) { $0.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) }
       let maxLength     = maxElement(lengths)

       let kvTuples = map(dict.keys) { (key:$0, value:dict[$0]!) }

       let colorized : [String] = map(kvTuples) { kvTuple in
           let paddedKey = "\(kvTuple.key):".stringByPaddingToLength(maxLength + 2, withString:" ", startingAtIndex:0)
           let keyColorized = ColorLogging.Colorize.Blue("\(paddedKey)")
           let valColorized = ColorLogging.Colorize.Grey("\(kvTuple.value.description)")
           return "\t\(keyColorized)\(valColorized)"
       }

       let valuesString = (colorized as NSArray).componentsJoinedByString("\n")
       return "{\n\(valuesString)\n}"
    }
}





