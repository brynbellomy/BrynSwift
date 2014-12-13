//
//  SKNode+BrynSwift.m
//  BrynSwift
//
//  Created by bryn austin bellomy on 3.3.14.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

#import "SKNode+BrynSwift.h"

@implementation SKNode (BrynSwift)

- (instancetype) initWithBundleFilename:(NSString *)filename
{
//    NSString *fullFilename = [filename stringByAppendingPathExtension:@"sks"];
//    yssert_notNil(fullFilename);

    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"sks"];
//    yssert_notNil(filepath);

    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
//    yssert_notNil(object);

    return object;
}



@end
