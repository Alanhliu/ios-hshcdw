//
//  MineTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "MineTableViewController.h"
#import "HelpViewController.h"
#import "SettingTableViewController.h"
#import "LoginTableViewController.h"
#import "LocalSaveManager.h"
#import "NotifyConstant.h"
#import "NSString+Utils.h"
@interface MineTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation MineTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderView) name:ZRefreshMineVCNotification object:nil];
}

- (IBAction)headerViewAction:(id)sender {
    //token不为空，登录了
    if ([[LocalSaveManager sharedInstance] getToken]) {
        SettingTableViewController *settingTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
        [self.navigationController pushViewController:settingTableViewController animated:YES];
    } else {
        LoginTableViewController *loginTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        [self.navigationController pushViewController:loginTableViewController animated:YES];
    }
}

- (void)refreshHeaderView
{
    //token不为空，登录了
    if ([[LocalSaveManager sharedInstance] getToken]) {
        self.textLabel.text = [[[LocalSaveManager sharedInstance] getPhone] phoneCipherText];
    } else {
        self.textLabel.text = @"立即登录";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:02431699910"] options:@{} completionHandler:nil];
    } else if (row == 1) {
        HelpViewController *helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
        [self.navigationController pushViewController:helpViewController animated:YES];
    }
}


@end
