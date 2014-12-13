//
//  BrynSwift.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Dec 2.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation

public class BrynSwift
{
}







public extension Float
{
    /**
        Returns a random Float value between min and max (inclusive).

        :param: min
        :param: max
        :returns: Random number
    */
    public static func random(min: Float = 0, max: Float) -> Float
    {
        let diff = max - min
        let rand = Float(arc4random() % (UInt32(RAND_MAX) + 1))
        return ((rand / Float(RAND_MAX)) * diff) + min
    }
}




