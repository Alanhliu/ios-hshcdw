//
//  ResetPasswordTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/7/26.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "ResetPasswordTableViewController.h"
#import "LoginTableViewController.h"
#import "SMSCodeButton.h"
#import "HttpManager.h"
#import "UIAlertController+Addition.h"
#import "NSString+Addition.h"
#import "NSString+Utils.h"
#import <MBProgressHUD.h>

@interface ResetPasswordTableViewController ()
@property (weak, nonatomic) IBOutlet SMSCodeButton *smsCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ResetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendSMSCode:nil];
}

- (IBAction)sendSMSCode:(id)sender {
    NSString *phone = [self.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    Validation *phoneValidation = [phone validatePhoneNumber];
    if (!phoneValidation.pass) {
        [UIAlertController showAlertControllerText:phoneValidation.message onViewController:self];
        return;
    }
    
    [self.smsCodeButton startAnimationWithDuration:60];
    
    NSDictionary *parameter = @{@"phone_number":self.phone,
                                @"biz_type":@"1"};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    __weak typeof(self)weakSelf = self;
    [[HttpManager sharedInstance] sendSMSCodeWithParameter:parameter success:^(HttpResponseObject *response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if ([response.responseData[@"result"] integerValue] == 0) {
            //发送成功
            MBProgressHUD *alertHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            alertHUD.mode = MBProgressHUDModeText;
            alertHUD.label.text = @"验证码发送成功";
            [alertHUD showAnimated:YES];
            [alertHUD hideAnimated:YES afterDelay:1.5];
        } else {
            //发送失败
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

- (IBAction)resetPassword:(id)sender {
    
    NSString *phone = [self.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *smsCode = [self.smsCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    Validation *phoneValidation = [phone validatePhoneNumber];
    if (!phoneValidation.pass) {
        [UIAlertController showAlertControllerText:phoneValidation.message onViewController:self];
        return;
    }
    
    Validation *passwordValidation = [password validatePassword];
    if (!passwordValidation.pass) {
        [UIAlertController showAlertControllerText:passwordValidation.message onViewController:self];
        return;
    }
    
    Validation *smsCodeValidation = [smsCode validateSMSCode];
    if (!smsCodeValidation.pass) {
        [UIAlertController showAlertControllerText:smsCodeValidation.message onViewController:self];
        return;
    }
    
    NSDictionary *parameter = @{@"phone_number":phone,
                                @"pw":[password md5],
                                @"v_code":smsCode};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    __weak typeof(self)weakSelf = self;
    [[HttpManager sharedInstance] resetPasswordWithParameter:parameter success:^(HttpResponseObject *response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if ([response.responseData[@"result"] integerValue] == 0) {
            //重置成功
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"重置密码成功，请去登录吧" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (UIViewController *v in strongSelf.navigationController.viewControllers) {
                    if ([v isKindOfClass:LoginTableViewController.class]) {
                        [strongSelf.navigationController popToViewController:v animated:YES];
                        break;
                    }
                }
            }];
            [alertController addAction:action];
            [strongSelf presentViewController:alertController animated:YES completion:nil];

        } else {
            //重置失败
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
