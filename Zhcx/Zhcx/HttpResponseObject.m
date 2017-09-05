//
//  HttpResponseObject.m
//  Zhcx
//
//  Created by siasun on 17/7/25.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "HttpResponseObject.h"

@implementation HttpResponseObject

- (void)setBody:(NSDictionary *)body
{
    _body = body;
    
    self.di = body[@"di"];
    self.st = body[@"st"];
    self.sig = body[@"sig"];
    self.et = body[@"et"];
    self.rd = body[@"rd"];
    self.cd = body[@"cd"];
    self.msg = body[@"msg"];
}

@end
