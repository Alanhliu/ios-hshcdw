//
//  Validation.h
//  Zhcx
//
//  Created by siasun on 17/7/25.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@interface Validation : NSObject

@property (nonatomic, assign) BOOL pass;
@property (nonatomic, copy) NSString *message;

+ (id)validationWithPass:(BOOL)pass message:(NSString *)message;

+ (void)validatePhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode onViewController:(UIViewController *)viewController;

@end
