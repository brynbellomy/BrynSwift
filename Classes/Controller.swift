//
//  Controller.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Nov 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftDataStructures


//
// MARK: - class Controller -
//

public class Controller <K: Hashable, V>
{
    public typealias Key = K
    public typealias Value = V
    public typealias UnderlyingCollection = OrderedDictionary<Key, Value>
    public typealias Element = (Key, Value)
    public typealias Index   = UnderlyingCollection.Index

    public var enabled = true
    public var childDidMoveToController: (V -> ())?
    public var childWillMoveFromController: (V -> ())?

    public typealias MessageClosure = V -> ()
    public private(set) var messages = [String: MessageClosure]()


    public private(set) var children = UnderlyingCollection()

    public required init() {
    }

    deinit {
        removeAll(keepCapacity: false)
    }

    public func has(key:Key) -> Bool {
        return children.indexForKey(key) != nil
    }

    public func childForKey(key:Key) -> Value? {
        return children[key]
    }

    public func add(child:Value, withKey key:Key)
    {
        remove(key)

        children[key] = child
        childDidMoveToController?(child)
    }

    public func remove(key:Key) -> Value?
    {
        if let child = children[key] {
            childWillMoveFromController?(child)
            let removed = children.removeForKey(key)
            return removed.value
        }
        return nil
    }

    public func removeWhere(predicate: (Key, Value) -> Bool) {
    }

    public func removeAll(#keepCapacity:Bool)
    {
        for (key, child) in children.generateTuples() {
            childWillMoveFromController?(child)
        }
        children.removeAll(keepCapacity:keepCapacity)
    }
}



//
// MARK: - Controller: SequenceType
//

extension Controller: SequenceType
{
    public typealias Generator = GeneratorOf<Element>
    public func generate() -> Generator
    {
        var generator = children.generateTuples()
        return GeneratorOf { generator.next() }
    }
}


//
// MARK: - Controller: CollectionType
//

extension Controller: CollectionType
{
    public var startIndex : Index { return children.startIndex }
    public var endIndex   : Index { return children.endIndex }

    public subscript(index: Index) -> Element {
        get { return children.elementAtIndex(index)!.asTuple() }
    }

    public subscript(key: Key) -> Value?
    {
        get { return children.elementForKey(key)?.value }
        set {
            if let val = newValue {
                children.updateValue(val, forKey:key)
            }
            else {
                children.removeForKey(key)
            }
        }
    }
}


//
// MARK: - Controller: ExtensibleCollectionType
//

extension Controller: ExtensibleCollectionType
{
    public func reserveCapacity(n: Index.Distance) {
        children.reserveCapacity(n)
    }

    public func append(newElement: Element) {
        children.append(newElement.0, value: newElement.1)
    }

    public func extend <S: SequenceType where S.Generator.Element == Element> (sequence: S) {
        children.extendTuples(sequence)
    }
}





