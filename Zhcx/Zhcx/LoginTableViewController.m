//
//  LoginTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/26.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "LoginTableViewController.h"
#import "RegistTableViewController.h"
#import "ForgetPasswordTableViewController.h"
#import "HttpManager.h"
#import "NSString+Addition.h"
#import "NSString+Utils.h"
#import "UIAlertController+Addition.h"
#import "LocalSaveManager.h"
#import <MBProgressHUD.h>
#import "NotifyConstant.h"
@interface LoginTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *registBarItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarItem;

@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.registBarItem;
    
    if (self.transitionMode == TransitionModePresent) {
        self.navigationItem.leftBarButtonItem = self.cancelBarItem;
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    
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
    
    NSDictionary *parameter = @{@"phone_number":phone,
                                @"pw":[password md5]};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    __weak typeof(self)weakSelf = self;
    [[HttpManager sharedInstance] loginWithParameter:parameter success:^(HttpResponseObject *response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [hud hideAnimated:YES];
        });
        
        if ([response.responseData[@"result"] integerValue] == 0) {
            //登录成功
            [[LocalSaveManager sharedInstance] saveToken:response.responseData[@"token"]];
            [[LocalSaveManager sharedInstance] savePhone:phone];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZRefreshMineVCNotification object:nil];
            
            if (self.transitionMode == TransitionModePresent) {
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } else {
            //登录失败
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

- (IBAction)forgetPassword:(id)sender {
    ForgetPasswordTableViewController *forgetPasswordTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordTableViewController"];
    [self.navigationController pushViewController:forgetPasswordTableViewController animated:YES];
}

- (IBAction)regist:(id)sender {
    RegistTableViewController *registTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistTableViewController"];
    [self.navigationController pushViewController:registTableViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
