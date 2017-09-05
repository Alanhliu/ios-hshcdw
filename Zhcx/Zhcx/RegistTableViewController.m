//
//  RegistTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/27.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "RegistTableViewController.h"
#import "HttpManager.h"
#import "NSString+Addition.h"
#import "NSString+Utils.h"
#import "UIAlertController+Addition.h"
#import "SMSCodeButton.h"
#import <MBProgressHUD.h>
@interface RegistTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet SMSCodeButton *verifyCodeButton;


@end

@implementation RegistTableViewController

- (void)dealloc
{
    [self.verifyCodeButton clearTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)sendVerifyCode:(id)sender {
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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

    [self.verifyCodeButton startAnimationWithDuration:60];
    
    NSDictionary *parameter = @{@"phone_number":phone,
                                @"biz_type":@"0"};
    
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

- (IBAction)regist:(id)sender {
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *smsCode = [self.verifyCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
    [[HttpManager sharedInstance] registWithParameter:parameter success:^(HttpResponseObject *response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if ([response.responseData[@"result"] integerValue] == 0) {
            //注册成功
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功，请去登录吧" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:action];
            [strongSelf presentViewController:alertController animated:YES completion:nil];
        } else {
            //注册失败
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

- (void)showAlertHUDWithText:(NSString *)text
{
    MBProgressHUD *alertHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    alertHUD.mode = MBProgressHUDModeText;
    alertHUD.label.text = text;
    [alertHUD showAnimated:YES];
    [alertHUD hideAnimated:YES afterDelay:1.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
