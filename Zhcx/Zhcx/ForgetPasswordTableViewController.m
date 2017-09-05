//
//  ForgetPasswordTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/7/19.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "ForgetPasswordTableViewController.h"
#import "ResetPasswordTableViewController.h"
#import "UIAlertController+Addition.h"
#import "HttpManager.h"
#import "NSString+Addition.h"
#import <MBProgressHUD.h>
@interface ForgetPasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation ForgetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)nextButtonAction:(id)sender {
    
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    Validation *phoneValidation = [phone validatePhoneNumber];
    if (!phoneValidation.pass) {
        [UIAlertController showAlertControllerText:phoneValidation.message onViewController:self];
        return;
    }

    NSDictionary *parameter = @{@"phone_number":phone};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    __weak typeof(self)weakSelf = self;
    [[HttpManager sharedInstance] verifyPhoneWithParameter:parameter success:^(HttpResponseObject *response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        
        if ([response.responseData[@"result"] integerValue] == 0) {
            //验证成功
            ResetPasswordTableViewController *resetPasswordTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordTableViewController"];
            resetPasswordTableViewController.phone = phone;
            [self.navigationController pushViewController:resetPasswordTableViewController animated:YES];
        } else {
            //验证失败
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
