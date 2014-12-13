//
//  Functional.Functions.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Dec 8.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//


/**
    Curries a binary function.
 */
public func curry<T, U, V>(f: (T, U) -> V) -> T -> U -> V {
    return { x in { y in f(x, y) }}
}

/**
    Curries a binary function and swaps the placement of the arguments.  Useful for bringing the Swift built-in collection functions into functional pipelines.  For example:

    someArray |> curry_swap(map)({ $0 ... })

    (...or whatever).
 */
public func curry_swap<T, U, V>(f: (T, U) -> V) -> U -> T -> V {
    return { x in { y in f(y, x) }}
}


public func isNil<T : AnyObject>(val:T?) -> Bool {
    return val === nil
}


public func isNil<T : NilLiteralConvertible>(val:T?) -> Bool {
    return val == nil
}


public func isNil<T>(val:T?) -> Bool {
    switch val {
        case .Some(let _): return true
        case .None: return false
    }
}


public func nonNil<T>(value:T?) -> Bool {
    if let value = value? {
        return true
    }
    return false
}


/**
    Curried function that maps a transform function over a given object and returns a 2-tuple of the form `(object, transformedObject)`.
 */
public func zip<T, U>(transform: T -> U)(object: T) -> (T, U)
{
    let transformed = transform(object)
    return (object, transformed)
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an array of 2-tuples of the form `(object, transformedObject)`.  If the transform function returns nil for a given element in the collection, the tuple for that element will not be included in the returned `Array`.
 */
public func zip_filter<C : CollectionType, T>(transform: C.Generator.Element -> T?)(source: C) -> [(C.Generator.Element, T)]
{
    let zipped_or_nil : (C.Generator.Element) -> (C.Generator.Element, T)? = zip_filter(transform)
    return source |> map_filter(zipped_or_nil)
}


/**
    Curried function that maps a transform function over a given object and returns an `Optional` 2-tuple of the form `(object, transformedObject)`.  If the transform function returns nil, this function will also return nil.
 */
public func zip_filter<T, U>(transform: T -> U?)(object: T) -> (T, U)?
{
    if let transformed = transform(object)? {
        return (object, transformed)
    }
    else { return nil }
}


/**
    Curried function that maps a transform function over a `CollectionType` and returns an `Array` of 2-tuples of the form `(object, transformedObject)`.
 */
public func zip<C : CollectionType, T>(transform: C.Generator.Element -> T)(source: C) -> [(C.Generator.Element, T)] {
    let theZip = zip(transform)
    return map(source, theZip)
}


/**
    A curried, argument-reversed version of `filter` for use in functional pipelines.
 */
public func selectr<S : SequenceType>(predicate: S.Generator.Element -> Bool)(seq: S) -> [S.Generator.Element] {
    return filter(seq, predicate)
}


/**
    A curried, argument-reversed version of `map` for use in functional pipelines.  For example:

    `let descriptions = someCollection |> mapr { $0.description }`

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The transformed collection.
*/
public func mapr<C : CollectionType, T>(transform: C.Generator.Element -> T)(source: C) -> [T] {
    return map(source, transform)
}

//func mapr<T, U>(f: (T) -> U)(x: T?) -> U? {
//    return map(x, f)
//}

/**
    Curried function that maps a transform function over a sequence and filters nil values from the resulting collection before returning it.  Note that you must specify the generic parameter `D` (the return type) explicitly.  Small pain in the ass for the lazy, but it lets you ask for any kind of `ExtensibleCollectionType` that you could possibly want.

    :param: transform The transform function.
    :param: source The sequence to map.
    :returns: An `ExtensibleCollectionType` of your choosing.
 */
public func map_filter <S: SequenceType, D: ExtensibleCollectionType> (transform: (S.Generator.Element) -> D.Generator.Element?)(source: S) -> D
{
    var result = D()
    for x in source {
        if let y = transform(x) {
            result.append(y)
        }
    }
    return result
}


/**
    Curried function that maps a transform function over a sequence and filters nil values from the resulting `Array` before returning it.

    :param: transform The transform function.
    :param: source The sequence to map.
    :returns: An `Array` with the mapped, non-nil values from the input sequence.
 */
public func map_filter <S: SequenceType, T> (transform: S.Generator.Element -> T?)(source: S) -> [T]
{
    var result = [T]()
    for x in source {
        result.append <^> transform(x)
    }
    return result
}


/**
    A curried, argument-reversed version of `each` used to create side-effects in functional
    pipelines.  Note that it returns the collection, `source`, unmodified.  This is to facilitate
    fluent chaining of such pipelines.  For example:

    someCollection |> do_each { println("the object is \($0)") }
                   |> mapr    { $0.description }
                   |> do_each { println("the object's description is \($0)") }

    :param: transform The transformation function to apply to each incoming element.
    :param: source The collection to transform.
    :returns: The collection, unmodified.
*/
public func do_each<C : SequenceType>(closure: C.Generator.Element -> Void)(source: C) -> C {
    for item in source {
        closure(item)
    }
    return source
}


/**
    Rejects nil elements from the provided collection.

    :param: collection The collection to filter.
    :returns: The collection with all `nil` elements removed.
*/
public func rejectNil<T>(collection: [T?]) -> [T] {
    //    return selectr(nonNil)(collection)
    var nonNilValues = [T]()
    for item in collection
    {
        if nonNil(item) {
            nonNilValues.append(item!)
        }
    }
    return nonNilValues
}



/**
    Returns nil if either value in the provided 2-tuple is nil.  Otherwise, returns the input tuple with its inner `Optional`s flattened (in other words, the returned tuple is guaranteed by the type-checker to have non-nil elements).

    :param: tuple The tuple to examine.
    :returns: The tuple or nil.
*/
public func rejectEitherNil<T, U>(tuple: (T?, U?)) -> (T, U)?
{
//    return eitherIsNil(tuple) ? nil : (tuple.0!, tuple.1!)
    return nonNil(tuple.0) && nonNil(tuple.1)
                ? (tuple.0!, tuple.1!)
                : nil
}


//public func eitherIsNil<T, U>(tuple: (T?, U?)) -> Bool {
//    return either({ isNil(tuple.0) }, { isNil(tuple.1) })
//}
//
//public func either(one: Void -> Bool, two: Void -> Bool) -> Bool {
//    return one() || two()
//}


/**
    Rejects tuple elements from the provided collection if either value in the tuple is nil.

    :param: collection The collection to filter.
    :returns: The provided collection with all tuples containing a `nil` element removed.
*/
public func rejectEitherNil<T, U>(collection: [(T?, U?)]) -> [(T, U)]
{
    return reduce(collection, Array<(T, U)>()) { (var nonNilValues, item) in
        if nonNil(item.0) && nonNil(item.1) {
            nonNilValues.append((item.0!, item.1!))
        }
        return nonNilValues
    }
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    :param: keySelector A function taking an element of `array` and returning the key for that element in the returned dictionary.
    :returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func toDictionary <U, E> (keySelector:E -> U)(array:[E]) -> [U: E] {
    return toDictionary(array, keySelector)
}


/**
    Converts the array to a dictionary with the keys supplied via `keySelector`.

    :param: keySelector A function taking an element of `array` and returning the key for that element in the returned dictionary.
    :returns: A dictionary comprising the key-value pairs constructed by applying `keySelector` to the values in `array`.
*/
public func toDictionary <U, E> (array:[E], keySelector:E -> U) -> [U: E]
{
    var result: [U: E] = [:]
    for item in array {
        result[keySelector(item)] = item
    }
    return result
}


/**
    Iterates through `domain` and returns the index of the first element for which `predicate(element)` returns `true`.

    :param: domain The collection to search.
    :returns: The index of the first matching item,  or `nil` if none was found.
 */
public func find<C : CollectionType where C.Generator.Element : Equatable>(domain: C, predicate: (C.Generator.Element) -> Bool) -> C.Index?
{
    var maybeIndex : C.Index? = domain.startIndex
    do
    {
        if let index = maybeIndex?
        {
            let item = domain[index]
            if predicate(item) == true {
                return index
            }

            maybeIndex = index.successor()
        }

    } while maybeIndex != nil

    return nil
}


/**
    Converts an array of tuples of type `(K, V)` to a dictionary of type `[K : V]`.

    :param: array The array to convert.
    :returns: A dictionary.
 */
public func tupleArrayToDictionary <E, F> (array:[(E, F)]) -> [E : F]
{
    var result: [E : F] = [:]
    for item in array {
        result[item.0] = item.1
    }
    return result
}




