//
//  UIAlertController+Addition.m
//  Zhcx
//
//  Created by siasun on 17/6/23.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "UIAlertController+Addition.h"

@implementation UIAlertController (Addition)

+ (UIAlertController *)alertControllerWithMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    return alertController;
}

+ (void)showAlertControllerText:(NSString *)text onViewController:(UIViewController *)viewController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlertControllerError:(NSError *)error onViewController:(UIViewController *)viewController
{

}
@end
