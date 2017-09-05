//
//  Validation.m
//  Zhcx
//
//  Created by siasun on 17/7/25.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "Validation.h"
#import "UIAlertController+Addition.h"
#import "NSString+Addition.h"

@implementation Validation

+ (Validation *)validationWithPass:(BOOL)pass message:(NSString *)message
{
    Validation *validation = [Validation new];
    validation.pass = pass;
    validation.message = message;
    return validation;
}

+ (void)validatePhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode onViewController:(UIViewController *)viewController
{
    if (phone) {
        Validation *phoneValidation = [phone validatePhoneNumber];
        if (!phoneValidation.pass) {
            [UIAlertController showAlertControllerText:phoneValidation.message onViewController:viewController];
            return;
        }
    }
    
    if (password) {
        Validation *passwordValidation = [password validatePassword];
        if (!passwordValidation.pass) {
            [UIAlertController showAlertControllerText:passwordValidation.message onViewController:viewController];
            return;
        }
    }
    
    if (smsCode) {
        Validation *smsCodeValidation = [smsCode validateSMSCode];
        if (!smsCodeValidation.pass) {
            [UIAlertController showAlertControllerText:smsCodeValidation.message onViewController:viewController];
            return;
        }
    }
}
@end
