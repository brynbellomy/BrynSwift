//
//  JavaScriptCore+BrynSwift.m
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Oct 18.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

@import Foundation;
@import JavaScriptCore;

#import "JavaScriptCore+BrynSwift.h"

JSValue *getJSVinJSC(JSContext *ctx, NSString *key) {
    return ctx[key];
}

//void setJSVinJSC(JSContext *ctx, NSString *key, id val) {
//    ctx[key] = val;
//}

void setB0JSVinJSC(JSContext *ctx, NSString *key, void(^block)(id)) {
    ctx[key] = block;
}

//void setB1JSVinJSC(JSContext *ctx, NSString *key, id (^block)(id)) {
//    ctx[key] = block;
//}
//
//void setB2JSVinJSC(JSContext *ctx, NSString *key, id (^block)(id, id)) {
//    ctx[key] = block;
//}

