//
//  SettingTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/7/21.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "SettingTableViewController.h"
#import "ModifyPasswordTableViewController.h"
#import "LocalSaveManager.h"
#import "HttpManager.h"
#import "NotifyConstant.h"
#import "UIAlertController+Addition.h"
#import "NSString+Utils.h"
#import <MBProgressHUD.h>
@interface SettingTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneLabel.text = [[[LocalSaveManager sharedInstance] getPhone] phoneCipherText];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        ModifyPasswordTableViewController *modifyPasswordTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyPasswordTableViewController"];
        [self.navigationController pushViewController:modifyPasswordTableViewController animated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        __weak typeof(self)weakSelf = self;
        [[HttpManager sharedInstance] logoutWithParameter:@{} success:^(HttpResponseObject *response) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            
            if ([response.responseData[@"result"] integerValue] == 0) {
                //登出成功
                [[LocalSaveManager sharedInstance] removeToken];
                [[LocalSaveManager sharedInstance] removePhone];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ZRefreshMineVCNotification object:nil];
                
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                //登出失败
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
