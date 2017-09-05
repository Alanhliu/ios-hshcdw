//
//  LocationTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "LocationTableViewController.h"
#import "HttpManager.h"
#import "UIAlertController+Addition.h"
#import "NotifyConstant.h"
#import "CityConstant.h"
#import <MBProgressHUD.h>
@interface LocationTableViewController ()

@property (nonatomic, strong) NSArray *cityList;

@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    __weak typeof(self)weakSelf = self;
    [[HttpManager sharedInstance] queryCityWithParameter:@{} success:^(HttpResponseObject *response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if ([response.responseData[@"result"] integerValue] == 0) {
            //获取成功
            strongSelf.cityList = response.responseData[@"city_list"];
            [strongSelf.tableView reloadData];
        } else {
            //获取失败
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

#pragma mark - Table view data source
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"定位城市";
//    }
//    return @"其他城市";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *cityItem = self.cityList[indexPath.row];
    
    cell.textLabel.text = cityItem[@"city_name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cityItem = self.cityList[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:cityItem[CITY_CODE] forKey:CITY_CODE];
    [[NSUserDefaults standardUserDefaults] setObject:cityItem[CITY_NAME] forKey:CITY_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:cityItem[CITY_URL] forKey:CITY_URL];
    [[NSUserDefaults standardUserDefaults] setObject:cityItem[CITY_NAME_FOR_BD] forKey:CITY_NAME_FOR_BD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZRefreshHomeVCNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
