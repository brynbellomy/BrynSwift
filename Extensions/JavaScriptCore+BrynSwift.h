//
//  JavaScriptCore+BrynSwift.h
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Oct 18.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

@import JavaScriptCore;

JSValue *getJSVinJSC(JSContext *ctx, NSString *key);
//void setJSVinJSC(JSContext *ctx, NSString *key, id val);
void setB0JSVinJSC(JSContext *ctx, NSString *key,void(^block)(id));
//void setB1JSVinJSC(JSContext *ctx, NSString *key,id(^block)(id));
//void setB2JSVinJSC(JSContext *ctx, NSString *key,id(^block)(id,id));