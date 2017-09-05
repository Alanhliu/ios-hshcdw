//
//  JSHandler.h
//  Zhcx
//
//  Created by siasun on 17/8/18.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "JSHandler.h"


#import "AESCipher.h"
#import "LocalSaveManager.h"
#import "LoginTableViewController.h"
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

static NSString *const KEY = @"8b1b9e8c9beb4407b6aeb766f515e35d";

@implementation JSHandler:NSObject

#pragma mark - 实现代理方法
- (NSString *)aesEncryptString:(NSString *)text
{
    NSString *encryptString = aesEncryptString(text,KEY);
    return encryptString;
}

- (NSString *)aesDecryptString:(NSString *)text
{
    NSString *decryptString = aesDecryptString(text,KEY);
    return decryptString;
}

- (NSString *)getToken
{
    NSString *token = [[LocalSaveManager sharedInstance] getToken];
    return token;
}

- (void)showLoginScene:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginTableViewController *loginTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        loginTableViewController.transitionMode = TransitionModePresent;
        
        UINavigationController *nav = [UINavigationController new];
        [nav setViewControllers:@[loginTableViewController]];
        
        if (message) {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [rootViewController presentViewController:nav animated:YES completion:nil];
            }];
            [alertViewController addAction:action];
            [rootViewController presentViewController:alertViewController animated:YES completion:nil];
        } else {
            [rootViewController presentViewController:nav animated:YES completion:nil];
        }
    });
}
@end
