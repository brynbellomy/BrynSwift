//
// this is some shit i got from http://airspeedvelocity.net
//


infix operator |> {
    associativity left
}

public func |>
    <T, U>
    (t: T, f: T -> U)
    -> U
{
    return f(t)
}


infix operator • {
    associativity left
}

/**
 * The function composition operator.
 *
 * :param: g The outer function, called second and passed the return value of f(x).
 * :param: f The inner function, called first and passed some value x.
 * :returns: A function that takes some argument x, calls g(f(x)), and returns the value.
 */
public func •
    <T, U, V>
    (g: U -> V, f: T -> U)
    -> T -> V
{
    return { x in g(f(x)) }
}


//public func mapSome
//    <S: SequenceType, D: ExtensibleCollectionType>
//    (source: S, transform: (S.Generator.Element) -> (D.Generator.Element?))
//    -> D {
//        var result = D()
//        for x in source {
//            if let y = transform(x) {
//                result.append(y)
//            }
//        }
//        return result
//}

public func mapSome
    <S: SequenceType, D: ExtensibleCollectionType>
    (transform: (S.Generator.Element) -> D.Generator.Element?)(source: S)
    -> D {
        var result = D()
        for x in source {
            if let y = transform(x) {
                result.append(y)
            }
        }
        return result
}

public func mapIfIndex
    < S: SequenceType, C: ExtensibleCollectionType
      where S.Generator.Element == C.Generator.Element >
    (source: S, transform: (S.Generator.Element) -> S.Generator.Element, ifIndex: Int -> Bool)
    -> C {
        var result = C()
        for (index,value) in enumerate(source) {
            if ifIndex(index) {
                result.append(transform(value))
            }
            else {
                result.append(value)
            }
        }
        return result
}



public func mapEveryNth
    < S: SequenceType, C: ExtensibleCollectionType
      where S.Generator.Element == C.Generator.Element >
    (source: S, n: Int, transform: S.Generator.Element -> C.Generator.Element)
    -> C
{
    // enumerate starts from zero, so for this to work with the nth element,
    // and not the 0th, n+1th etc, we need to add 1 to the ifIndex check:
    let isNth = { ($0 + 1) % n == 0 }

    return mapIfIndex(source, transform, isNth)
}



public func sum
    < S: SequenceType
      where S.Generator.Element: IntegerType >
    (nums: S) -> S.Generator.Element
{
    return reduce(nums, 0) { $0.0 + $0.1 }
}

