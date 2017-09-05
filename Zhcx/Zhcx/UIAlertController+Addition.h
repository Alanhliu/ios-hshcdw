//
//  UIAlertController+Addition.h
//  Zhcx
//
//  Created by siasun on 17/6/23.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Addition)

+ (UIAlertController *)alertControllerWithMessage:(NSString *)message;

+ (void)showAlertControllerText:(NSString *)text onViewController:(UIViewController *)viewController;

+ (void)showAlertControllerError:(NSError *)error onViewController:(UIViewController *)viewController;
@end
