//
//  JavaScriptCore+BrynSwift.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Oct 18.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import JavaScriptCore


public extension JSContext
{
    typealias ID = AnyObject

    func fetch(key:NSString)->JSValue {
        return getJSVinJSC(self, key)
    }
//    func store(key:NSString, _ val:ID) {
//        setJSVinJSC(self, key, val)
//    }
    func store(key:NSString, _ blk: @objc_block (AnyObject!) -> Void) {
        setB0JSVinJSC(self, key, blk)
//        setJSVinJSC(self, key, blk)
    }
//    func store(key:NSString, _ blk:(ID)->ID) {
//        setB1JSVinJSC(self, key, blk)
//    }
//    func store(key:NSString, _ blk:(ID,ID)->ID) {
//        setB2JSVinJSC(self, key, blk)
//    }
}
