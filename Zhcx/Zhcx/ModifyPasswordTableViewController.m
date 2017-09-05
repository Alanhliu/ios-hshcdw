//
//  ModifyPasswordTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/7/26.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "ModifyPasswordTableViewController.h"
#import "HttpManager.h"
#import "NSString+Addition.h"
#import "NSString+Utils.h"
#import "UIAlertController+Addition.h"
#import "LocalSaveManager.h"
#import "NotifyConstant.h"
#import <MBProgressHUD.h>
@interface ModifyPasswordTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *theNewPasswordTextField;

@end

@implementation ModifyPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)modifyPassword:(id)sender {
    NSString *oldPassword = [self.oldPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newPassword = [self.theNewPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    Validation *oldPasswordValidation = [oldPassword validatePassword];
    if (!oldPasswordValidation.pass) {
        [UIAlertController showAlertControllerText:oldPasswordValidation.message onViewController:self];
        return;
    }
    
    Validation *newPasswordValidation = [newPassword validatePassword];
    if (!newPasswordValidation.pass) {
        [UIAlertController showAlertControllerText:newPasswordValidation.message onViewController:self];
        return;
    }
    
    NSDictionary *parameter = @{@"original_pw":[oldPassword md5],
                                @"new_pw":[newPassword md5]
                                };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    __weak typeof(self)weakSelf = self;
    [[HttpManager sharedInstance] modifyPasswordWithParameter:parameter success:^(HttpResponseObject *response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if ([response.responseData[@"result"] integerValue] == 0) {
            //修改成功
            [[LocalSaveManager sharedInstance] removeToken];
            [[LocalSaveManager sharedInstance] removePhone];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZRefreshMineVCNotification object:nil];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertController addAction:action];
            [strongSelf presentViewController:alertController animated:YES completion:nil];
        } else {
            //修改失败
            [UIAlertController showAlertControllerText:response.responseData[@"msg"] onViewController:strongSelf];
        }
    } failure:^(NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        [UIAlertController showAlertControllerError:error onViewController:strongSelf];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
