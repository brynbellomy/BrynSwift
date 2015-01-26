//
//  VectorArithmetic.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Sep 21.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import SwiftLogger
import Foundation

import CoreGraphics

public protocol VectorOperatable  {
    init(horizontal:CGFloat,vertical:CGFloat)
    var horizontal:CGFloat { get set }
    var vertical:CGFloat { get set }
}

public protocol VectorArithmetic : VectorOperatable {
    var angleInRadians:CGFloat {get}
    var magnitude:CGFloat {get}
    var length:CGFloat {get}
    var lengthSquared:CGFloat {get}
    func dotProduct <T : VectorArithmetic>(vector:T) -> CGFloat
    func crossProduct <T : VectorArithmetic>(vector:T) -> CGFloat
    func distanceTo <T : VectorArithmetic>(vector:T) -> CGFloat
    var reversed:Self {get}
    var normalized:Self {get}
    func limited(scalar:CGFloat) -> Self
    func scaled(scalar:CGFloat) -> Self
    func angled(scalar:CGFloat) -> Self


}

//Since these structs already have != operator for themselves, but not against each we can't use a generic constraint

public func != (lhs: CGVector , rhs: CGSize) -> Bool {
    return (lhs == rhs) == false
}
public func != (lhs: CGVector , rhs: CGPoint) -> Bool {
    return (lhs == rhs) == false
}
public func != (lhs: CGSize , rhs: CGVector) -> Bool {
    return (lhs == rhs) == false
}
public func != (lhs: CGSize , rhs: CGPoint) -> Bool {
    return (lhs == rhs) == false
}
public func != (lhs: CGPoint , rhs: CGVector) -> Bool {
    return (lhs == rhs) == false
}
public func != (lhs: CGPoint , rhs: CGSize) -> Bool {
    return (lhs == rhs) == false
}

public func == <T:VectorOperatable, U:VectorOperatable> (lhs:T,rhs:U) -> Bool {
    return (lhs.horizontal == rhs.horizontal && lhs.vertical == rhs.vertical)
}
//Gives ambigious operator since the struct already does compare to its own type
//func != <T:VectorOperatable, U:VectorOperatable>(lhs: T , rhs: U) -> Bool {
//  return (lhs == rhs) == false
//}
public func <= <T:VectorOperatable, U:VectorOperatable>(lhs:T, rhs:U) -> Bool {
    return (lhs <  rhs) || (lhs == rhs)
}
public func < <T:VectorOperatable, U:VectorOperatable>(lhs: T , rhs: U) -> Bool {
    return (lhs.horizontal <  rhs.horizontal || lhs.vertical < rhs.vertical)
}
public func >= <T:VectorOperatable, U:VectorOperatable>(lhs: T , rhs: U) -> Bool {
    return (lhs > rhs) || ( lhs == rhs)
}
public func > <T:VectorOperatable, U:VectorOperatable>(lhs: T , rhs: U) -> Bool {
    return (lhs <= rhs) == false
}

public func - <T:VectorOperatable, U:VectorOperatable>(lhs: T, rhs:U) -> T  {
    return T(horizontal: lhs.horizontal-rhs.horizontal, vertical: lhs.vertical-rhs.vertical)
}
public func -= <T:VectorOperatable, U:VectorOperatable>(inout lhs: T, rhs:U)  {
    lhs = lhs - rhs
}

public func + <T:VectorOperatable, U:VectorOperatable>(lhs: T, rhs:U) -> T  {
    return T(horizontal: lhs.horizontal+rhs.horizontal, vertical: lhs.vertical+rhs.vertical)
}
public func += <T:VectorOperatable, U:VectorOperatable>(inout lhs: T, rhs:U)  {
    lhs = lhs + rhs
}

public func * <T:VectorOperatable, U:VectorOperatable>(lhs: T, rhs:U) -> T  {
    return T(horizontal: lhs.horizontal*rhs.horizontal, vertical: lhs.vertical*rhs.vertical);
}
public func *= <T:VectorOperatable, U:VectorOperatable>(inout lhs: T, rhs:U)  {
    lhs = lhs * rhs

}

public func / <T:VectorOperatable, U:VectorOperatable>(lhs:T, rhs:U) -> T  {
    return T(horizontal: lhs.horizontal/rhs.horizontal, vertical: lhs.vertical/rhs.vertical);
}
public func /= <T:VectorOperatable, U:VectorOperatable>(inout lhs:T, rhs:U) -> T  {
    lhs = lhs / rhs
    return lhs
}


public func / <T:VectorOperatable>(lhs:T, scalar:CGFloat) -> T  {
    return T(horizontal: lhs.horizontal/scalar, vertical: lhs.vertical/scalar);
}
public func /= <T:VectorOperatable>(inout lhs:T, scalar:CGFloat) -> T  {
    lhs = lhs / scalar
    return lhs
}

public func * <T:VectorOperatable>(lhs: T, scalar:CGFloat) -> T  {
    return T(horizontal: lhs.horizontal*scalar, vertical: lhs.vertical*scalar)
}
public func *= <T:VectorOperatable>(inout lhs: T, value:CGFloat)   {
    lhs = lhs * value
}



private struct InternalVectorArithmetic {

    static func angleInRadians  <T : VectorArithmetic>(vector:T) -> CGFloat {
        let normalizedVector = self.normalized(vector)

        let theta = atan2(normalizedVector.vertical, normalizedVector.horizontal)
        return theta //+ M_PI_2 * -1
    }

    static func magnitude <T : VectorArithmetic>(vector:T) -> CGFloat {
        return sqrt(self.lengthSquared(vector))
    }

    static func lengthSquared <T : VectorArithmetic>(vector:T) -> CGFloat {
        return ((vector.horizontal*vector.horizontal) + (vector.vertical*vector.vertical))
    }


    static func reversed <T : VectorArithmetic>(vector:T) -> T {
        return vector * -1
    }

    static func dotProduct <T : VectorOperatable, U : VectorOperatable > (vector:T, otherVector:U) -> CGFloat  {
        return (vector.horizontal*otherVector.horizontal) + (vector.vertical*otherVector.vertical)
    }

    static func crossProduct <T : VectorArithmetic, U : VectorArithmetic > (vector:T, otherVector:U) -> CGFloat  {
        let deltaAngle = sin(self.angleInRadians(vector) - self.angleInRadians(otherVector))
        return self.magnitude(vector) * self.magnitude(otherVector) * deltaAngle
    }


    static func distanceTo <T : VectorArithmetic, U : VectorArithmetic > (vector:T, otherVector:U) -> CGFloat {
        var deltaX = CGFloat.abs(vector.horizontal - otherVector.horizontal)
        var deltaY = CGFloat.abs(vector.vertical   - otherVector.vertical)
        return self.magnitude(T(horizontal: deltaX, vertical: deltaY))
    }

    static func normalized <T : VectorArithmetic>(vector:T) -> T {
        let length = self.magnitude(vector)
        var newPoint:T = vector
        if(length > 0.0) {
            newPoint /= length
        }
        return newPoint
    }

    static func limit <T : VectorArithmetic>(vector:T, scalar:CGFloat) -> T  {
        var newPoint = vector
        if(self.magnitude(vector) > scalar) {
            newPoint = self.normalized(newPoint) * scalar
        }
        return newPoint
    }

    static func scaled <T : VectorArithmetic>(vector:T, scalar:CGFloat) -> T {
        return vector * scalar
    }


    static func vectorWithAngle <T:VectorArithmetic>(vector:T, scalar:CGFloat) -> T {
        let length = self.magnitude(vector)
        return T(horizontal: cos(scalar) * length, vertical: sin(scalar) * length)
    }
}


extension CGPoint: VectorArithmetic  {


    public init(horizontal:CGFloat,vertical:CGFloat) {
        self.init(x: horizontal, y: vertical)
    }


    public var horizontal:CGFloat {
        get { return self.x      }
        set { self.x = newValue  }
    }
    public var vertical:CGFloat {
        get { return self.y      }
        set { self.y = newValue  }
    }


    public var angleInRadians:CGFloat { return InternalVectorArithmetic.angleInRadians(self)}
    public var magnitude:CGFloat { return InternalVectorArithmetic.magnitude(self) }
    public var length:CGFloat { return self.magnitude }
    public var lengthSquared:CGFloat { return InternalVectorArithmetic.lengthSquared(self) }
    public func dotProduct <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.dotProduct(self, otherVector: vector) }
    public func crossProduct <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.crossProduct(self, otherVector: vector) }
    public func distanceTo <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.distanceTo(self, otherVector: vector) }
    public var reversed:CGPoint { return InternalVectorArithmetic.reversed(self) }
    public var normalized:CGPoint { return InternalVectorArithmetic.normalized(self) }
    public func limited(scalar:CGFloat) -> CGPoint { return InternalVectorArithmetic.limit(self, scalar: scalar) }
    public func scaled(scalar:CGFloat) -> CGPoint { return InternalVectorArithmetic.scaled(self, scalar: scalar) }
    public func angled(scalar:CGFloat) -> CGPoint { return InternalVectorArithmetic.vectorWithAngle(self, scalar: scalar) }


}


extension CGSize: VectorArithmetic {

    public init(horizontal:CGFloat,vertical:CGFloat) {
        self.init(width: horizontal, height: vertical)
    }


    public init(width:CGFloat, height:CGFloat) {
        self.init(width:CGFloat(width), height:CGFloat(height))
    }
    public var horizontal:CGFloat {
        get { return self.width     }
        set { self.width = newValue }
    }
    public var vertical:CGFloat {
        get {return self.height      }
        set {self.height = newValue  }
    }



    public var angleInRadians:CGFloat { return InternalVectorArithmetic.angleInRadians(self) }
    public var magnitude:CGFloat { return InternalVectorArithmetic.magnitude(self) }
    public var length:CGFloat { return self.magnitude }
    public var lengthSquared:CGFloat { return InternalVectorArithmetic.lengthSquared(self) }
    public func dotProduct <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.dotProduct(self, otherVector: vector) }
    public func crossProduct <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.crossProduct(self, otherVector: vector) }

    public func distanceTo <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.distanceTo(self, otherVector: vector) }
    public var reversed:CGSize { return InternalVectorArithmetic.reversed(self) }
    public var normalized:CGSize { return InternalVectorArithmetic.normalized(self) }
    public func limited(scalar:CGFloat) -> CGSize { return InternalVectorArithmetic.limit(self, scalar: scalar) }
    public func scaled(scalar:CGFloat) -> CGSize { return InternalVectorArithmetic.scaled(self, scalar: scalar) }
    public func angled(scalar:CGFloat) -> CGSize { return InternalVectorArithmetic.vectorWithAngle(self, scalar: scalar) }


}

extension CGVector: VectorArithmetic   {

    public init(magnitude:CGFloat, angleInRadians angle:CGFloat) {
        self.dx = CGFloat(cos(angle) * magnitude)
        self.dy = CGFloat(sin(angle) * magnitude)
    }

    public init(horizontal:CGFloat,vertical:CGFloat) {
        self.dx = horizontal
        self.dy = vertical
    }


    public var horizontal:CGFloat {
        get { return self.dx     }
        set { self.dx = newValue }
    }
    public var vertical:CGFloat {
        get { return self.dy      }
        set { self.dy = newValue  }
    }


    public var angleInRadians:CGFloat { return InternalVectorArithmetic.angleInRadians(self) }
    public var magnitude:CGFloat { return InternalVectorArithmetic.magnitude(self) }
    public var length:CGFloat { return self.magnitude }
    public var lengthSquared:CGFloat { return InternalVectorArithmetic.lengthSquared(self) }
    public func dotProduct <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.dotProduct(self, otherVector: vector) }
    public func crossProduct <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.crossProduct(self, otherVector: vector) }
    public func distanceTo <T : VectorArithmetic> (vector:T) -> CGFloat { return InternalVectorArithmetic.distanceTo(self, otherVector: vector) }
    public var reversed:CGVector { return InternalVectorArithmetic.reversed(self) }
    public var normalized:CGVector { return InternalVectorArithmetic.normalized(self) }
    public func limited(scalar:CGFloat) -> CGVector { return InternalVectorArithmetic.limit(self, scalar: scalar) }
    public func scaled(scalar:CGFloat) -> CGVector { return InternalVectorArithmetic.scaled(self, scalar: scalar) }
    public func angled(scalar:CGFloat) -> CGVector { return InternalVectorArithmetic.vectorWithAngle(self, scalar: scalar) }

}
