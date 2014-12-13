//
//  NSObject+BrynSwift.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Oct 23.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public extension NSObject
{
    public var bk_associatedObjects : AssociatedObjectController { return AssociatedObjectController(host:self) }
}


public class AssociatedObjectController
{
    public typealias KeyType = UnsafePointer<Void>

    public class func CreateKey() -> KeyType {
        return KeyType(malloc(1))
    }

    private weak var host : AnyObject?

    public init(host:AnyObject) {
        self.host = host
    }

    public func valueForKey(key:KeyType) -> AnyObject?
    {
        if let host : AnyObject = host? {
            return objc_getAssociatedObject(host, key)
        }
        return nil
    }

    public func setValue(value:AnyObject?, forKey key:KeyType) {
        objc_setAssociatedObject(host, key, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }

    public subscript(key:KeyType) -> AnyObject?
    {
        get { return valueForKey(key) }
        set { setValue(newValue, forKey:key) }
    }


    public func valueForKey<T : AnyObject>(key:AssociatedObjectController.KeyType, initializer:Void -> T) -> T
    {
        if let obj = valueForKey(key) as? T {
            return obj
        }
        else {
            let initializedValue = initializer()
            setValue(initializedValue, forKey:key)
            return initializedValue
        }
    }
}

