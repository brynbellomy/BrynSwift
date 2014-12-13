//
//  Controller.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Nov 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


/**
* MARK: - protocol IControllerChild -
*/

public protocol IControllerChild
{
    var enabled : Bool { get set }

    func didMoveToController()
    func willMoveFromController()
}


/**
* MARK: - class Controller -
*/

public class Controller<Key : Hashable>
{
    public var enabled = true
    public private(set) var children = [Key : IControllerChild]()

    public init() {
    }

    deinit {
        removeAll()
    }

    public func has(key:Key) -> Bool {
        if let _ = children.indexForKey(key)? { return true }
        else { return false }
    }

    public func childForKey(key:Key) -> IControllerChild? {
        return children[key]
    }

    public func add(child:IControllerChild, withKey key:Key)
    {
        remove(key)

        children[key] = child
        child.didMoveToController()
    }

    public func remove(key:Key) -> IControllerChild?
    {
        if let child = children[key]? {
            child.willMoveFromController()
            return children.removeValueForKey(key)
        }
        return nil
    }

    public func removeAll()
    {
        for (key, child) in children {
            child.willMoveFromController()
        }
        children.removeAll()
    }
}



