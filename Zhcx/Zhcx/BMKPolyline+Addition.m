//
//  BMKPolyline+Addition.m
//  Zhcx
//
//  Created by siasun on 17/6/28.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "BMKPolyline+Addition.h"
#import <objc/runtime.h>

@implementation BMKPolyline (Addition)

static char strTypeKey = 'a';

- (NSNumber *)type
{
    return objc_getAssociatedObject(self, &strTypeKey);
}

- (void)setType:(NSNumber *)type
{
    objc_setAssociatedObject(self, &strTypeKey, type, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
