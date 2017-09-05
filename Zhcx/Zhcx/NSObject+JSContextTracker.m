//
//  NSObject+JSContextTracker.m
//  Zhcx
//
//  Created by siasun on 2017/8/29.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "NSObject+JSContextTracker.h"
#import <JavaScriptCore/JavaScriptCore.h>
@implementation NSObject (JSContextTracker)

- (void)webView:(id)unused didCreateJavaScriptContext:(JSContext *)context forFrame:(id)alsoUnused {
    if (!context)
        return;
    [[NSNotificationCenter defaultCenter] postNotificationName:JSContextTrackerNotifycation object:context];
}

@end
