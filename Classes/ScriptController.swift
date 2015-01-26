//
//  ScriptComponent.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Oct 18.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import JavaScriptCore
import SwiftLogger
import LlamaKit
import Funky


public struct ScriptComponent
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

    public func require(scriptName:String) -> Result<JSValue?>
    {
        // NOTE: it's necessary to use this longer closure notation instead of just `.map(context.evaluateScript >>> success)` because otherwise the
        // JSValue returned by context.evaluateScript() is automatically (erroneously) released by the compiler, causing an EXC_BAD_ACCESS
        return ScriptComponent.scriptNamed(scriptName)
                    >>- { s in
                            let val = self.context.evaluateScript(s)
                            if let val = val {
                                return success(val)
                            }
                            return success(nil)
                        }
    }


    public func callFunction(fnName:String, withArgs args:NSArray) -> Result<JSValue>
    {
        if let fn: AnyObject = context.objectForKeyedSubscript(fnName)
        {
            if let fn = fn as? JSValue {
                let retval = fn.callWithArguments(args)
                return success(retval)
            }
            else { return failure("Could not get function as non-nil JSValue.") }
        }
        else { return failure("Could not find function in JSContext with name '\(fnName)'.") }
    }


    //
    // MARK: - Private helper methods -
    //

    private static func scriptNamed(scriptName:String) -> Result<String>
    {
        // load the script

        if let scriptURL = NSBundle.mainBundle().URLForResource(scriptName, withExtension:"js")?
        {
            var error: NSError?
            if let script = NSString(contentsOfURL:scriptURL, encoding:NSUTF8StringEncoding, error:&error) {
                return success(script)
            }

            if let error = error {
                return failure("Error loading script '\(scriptName)' (url = \(scriptURL)): \(error.localizedDescription)")
            }
            return failure("Error loading script '\(scriptName)' (url = \(scriptURL)): unknown error.")
        }
        else { return failure("Could not get bundle URL for script resource '\(scriptName).js'") }
    }



}



