//
//  ScriptController.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Oct 18.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import JavaScriptCore
import SwiftLogger


public struct ScriptController
{
    private let context = JSContext(virtualMachine:JSVirtualMachine())

    /**
     * MARK: - Initialization
     */

    public init() {}

    private func initializeContext()
    {
        // set up an exception handler

        context.exceptionHandler = { context, exceptionVal in
            let exception = exceptionVal.toDictionary()
            lllog(.Error, "*** JS exception caught: \(exception)")

            if let stack : AnyObject = exception["stack"]? {
                lllog(.Error, "*** STACK = \(stack)")
            }
        }
    }



    /**
     * MARK: - Convenient, low-fat, pass-through subscripting
     */

    public subscript(key:String) -> AnyObject?
    {
        get { return context.objectForKeyedSubscript(key) }
        set { context.setObject(newValue, forKeyedSubscript:key) }
    }



    /**
     * MARK: - Public API
     */

    public func require(scriptName:String)
    {
        if let script = ScriptController.scriptNamed(scriptName)? {
            context.evaluateScript(script)
        }
        else { lllog(.Error, "Could not load script with name '\(scriptName).js'") }
    }


    public func callFunction(fnName:String, withArgs args:NSArray) -> JSValue?
    {
        if let fn : AnyObject = context.objectForKeyedSubscript(fnName)?
        {
            if let fn = fn as? JSValue {
                let retval = fn.callWithArguments(args)
                return retval
            }
            else { lllog(.Error, "Could not get function as non-nil JSValue.") }
        }
        else { lllog(.Error, "Could not find function in JSContext with name '\(fnName)'.") }

        return nil
    }


    //
    // MARK: - Private helper methods -
    //

    private static func scriptNamed(scriptName:String) -> String?
    {
        // load the script

        if let scriptURL = NSBundle.mainBundle().URLForResource(scriptName, withExtension:"js")?
        {
            var error : NSError? = nil
            let script = NSString(contentsOfURL:scriptURL, encoding:NSUTF8StringEncoding, error:&error)

            if let error = error? {
                lllog(.Error, "Error loading script '\(scriptName)' (url = \(scriptURL)): \(error.localizedDescription)")
                return nil
            }

            return script
        }
        else { lllog(.Error, "Could not get bundle URL for script resource '\(scriptName).js'") }

        return nil
    }



}



