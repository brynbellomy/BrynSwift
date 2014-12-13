//
//  SKNode+BrynSwift.h
//  BrynSwift
//
//  Created by bryn austin bellomy on 3.3.14.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

@import SpriteKit;

@interface SKNode (BrynSwift)

/** 
 * @param filename The filename (in the app's main bundle) of the serialized SKNode.  Should not include the ".sks" extension.
 */
- (instancetype) initWithBundleFilename:(NSString *)filename;
//- (void) se_moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval speed:(CGFloat)movementSpeed;
//- (void) se_moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval speed:(CGFloat)movementSpeed;

@end
