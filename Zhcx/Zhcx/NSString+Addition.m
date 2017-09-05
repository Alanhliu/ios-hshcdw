//
//  NSString+Addition.m
//  Zhcx
//
//  Created by siasun on 17/7/25.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

- (Validation *)validatePhoneNumber
{
    BOOL pass = YES;
    NSString *message;
    
    if (self.length == 0) {
        pass = NO;
        message = @"手机号不能为空";
    } else if (self.length != 11) {
        pass = NO;
        message = @"请输入正确的11位手机号";
    }
    
    return [Validation validationWithPass:pass message:message];
}

- (Validation *)validatePassword
{
    BOOL pass = YES;
    NSString *message;
    
    if (self.length == 0) {
        pass = NO;
        message = @"密码不能为空";
    } else if (self.length < 6 || self.length > 16) {
        pass = NO;
        message = @"密码长度需要在6~16位之间";
    }
    
    return [Validation validationWithPass:pass message:message];
}

- (Validation *)validateSMSCode
{
    BOOL pass = YES;
    NSString *message;
    
    if (self.length == 0) {
        pass = NO;
        message = @"验证码不能为空";
    } else if (self.length != 4) {
        pass = NO;
        message = @"请输入正确的4位验证码";
    }
    
    return [Validation validationWithPass:pass message:message];
}

@end
