//
//  CGGeometry+BrynSwift.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Oct 17.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public let CGVectorZero = CGVector(dx:0, dy:0)

public func mapNaNComponentsToZeros(vector:CGVector) -> CGVector {
    return CGVector(dx: vector.dx.isNaN ? 0 : vector.dx, dy: vector.dy.isNaN ? 0 : vector.dy)
}

extension CGVector : Printable
{
    public var description : String { return "<CGVector {dx: \(self.dx), dy: \(self.dy)}>" }

    public func asCGPoint() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
}


public extension CGVector
{
    public var bk_shortDescription : String { return "<dx: \(self.dx), dy: \(self.dy)>" }

    public var hasNaNComponent : Bool {
        return dx.isNaN || dy.isNaN
    }
}



public extension CGRect
{
    public var bk_shortDescription : String { return "[x: \(self.origin.x), y: \(self.origin.y) / w: \(self.size.width), h: \(self.size.height)]" }
}



public extension CGPoint
{
    public static func fromDictionary(dict:[String:CGFloat]) -> CGPoint?
    {
        if dict["x"] != nil && dict["y"] != nil {
            return CGPoint(x:dict["x"]!, y:dict["y"]!)
        }
        return nil
    }

    public var bk_shortDescription : String { return "{x: \(self.x), y: \(self.y)}" }

    public func asCGVector() -> CGVector {
        return CGVector(dx: x, dy: y)
    }
}



public extension CGSize
{
    public var bk_shortDescription : String { return "{w: \(self.width), h: \(self.height)}" }

    static func fromDictionary(dict:[String:CGFloat]) -> CGSize?
    {
        if dict["width"] != nil && dict["height"] != nil {
            return CGSize(width:dict["width"]!, height:dict["height"]!)
        }
        return nil
    }
}



public extension CGPath
{
    public class func fromPoints(points:[CGPoint], closePath:Bool) -> CGPath
    {
        var poly: CGMutablePath = CGPathCreateMutable()

        if points.count > 0 {
            CGPathMoveToPoint(poly, nil, points[0].x, points[0].y)
        }
        else {
            return poly
        }

        for point in points {
            CGPathAddLineToPoint(poly, nil, point.x, point.y)
        }

        if closePath
        {
            // close the polygon
            if points.count > 0 {
                CGPathAddLineToPoint(poly, nil, points[0].x, points[0].y)
            }
        }

        return poly
    }
}



