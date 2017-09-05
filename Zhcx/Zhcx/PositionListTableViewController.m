//
//  PositionListTableViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/13.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "PositionListTableViewController.h"
#import "PositionListTableViewCell.h"
#import "IWantGoConstant.h"
#import "NSDate+Addition.h"
#import "ZViewConstant.h"
#import "SearchTextFiled.h"
#import <Masonry.h>
@interface PositionListTableViewController ()<UITextFieldDelegate,BMKPoiSearchDelegate,BMKBusLineSearchDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) BMKPoiSearch *searcher;
@property (nonatomic, strong) BMKCitySearchOption *option;
@property (nonatomic, strong) NSArray *poiInfoList;
@property (nonatomic, assign) NSInteger count;

@end

@implementation PositionListTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    
    self.searchTextField = [[SearchTextFiled alloc] initWithFrame:CGRectMake(55, 7, Z_ScreenWidth-55-30, 30)];
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchTextField;
    
    if (self.startingPoiInfo) {
        self.searchTextField.text = self.startingPoiInfo.name;
    } else {
        self.searchTextField.text = self.finishingPoiInfo.name;
    }
    
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _searcher = [[BMKPoiSearch alloc] init];
    _searcher.delegate = self;
    self.option = [[BMKCitySearchOption alloc] init];
    self.option.pageIndex = 0;
    self.option.pageCapacity = 10;
    self.option.city = @"沈阳";
    
    ////
//    NSString *uid = @"de1db5d8fee6635996f08cac";
//    BMKBusLineSearch *searcher = [[BMKBusLineSearch alloc]init];
//    searcher.delegate = self;
//    //发起检索
//    BMKBusLineSearchOption *buslineSearchOption = [[BMKBusLineSearchOption alloc]init];
//    buslineSearchOption.city= @"沈阳";
//    buslineSearchOption.busLineUid = uid;
//    [searcher busLineSearch:buslineSearchOption];
//    
//    NSString *stationUid = @"2c6031bece4c4917b13c81ac";
//    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
//    option.poiUid = stationUid;
//    [_searcher poiDetailSearch:option];
    ////
    
    self.searchTextField.font = [UIFont systemFontOfSize:14];
    NSDictionary *attribute = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]};
    if (self.viewTag == StartingLabelTag) {
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入起点" attributes:attribute];
        [self.searchTextField setAttributedPlaceholder:placeholder];
    }
    
    if (self.viewTag == FinishLabelTag) {
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入终点" attributes:attribute];
        [self.searchTextField setAttributedPlaceholder:placeholder];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - textFieldDidChange
- (void)textFieldDidChange:(UITextField *)textfield{
    
    NSDictionary *attribute = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]};
    if (!self.startingPoiInfo && self.viewTag == StartingLabelTag) {
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入起点" attributes:attribute];
        [self.searchTextField setAttributedPlaceholder:placeholder];
    }
    
    if (!self.finishingPoiInfo && self.viewTag == FinishLabelTag) {
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入终点" attributes:attribute];
        [self.searchTextField setAttributedPlaceholder:placeholder];
    }
    
    
    self.count ++;
    [self performSelector:@selector(search:) withObject:@(self.count) afterDelay:0.5f];
}

- (void)search:(NSNumber *)count
{
    if (self.count == [count integerValue]) {
        self.option.keyword = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [_searcher poiSearchInCity:self.option];
    }
}

#pragma mark - BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    NSSortDescriptor *epoitype_sorter = [[NSSortDescriptor alloc] initWithKey:@"epoitype" ascending:NO];
    NSArray *sortDescriptors = @[epoitype_sorter];
    self.poiInfoList = [poiResult.poiInfoList sortedArrayUsingDescriptors:sortDescriptors];
    [self.tableView reloadData];
}

////
//- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)error
//{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        //在此处理正常结果
//    }
//    else {
//        NSLog(@"抱歉，未找到结果");
//    }
//}
//
//- (void)onGetBusDetailResult:(BMKBusLineSearch*)searcher result:(BMKBusLineResult*)busLineResult errorCode:(BMKSearchErrorCode)error
//{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        //在此处理正常结果
//        BMKBusStation *station = busLineResult.busStations.firstObject;
//        station.location;
//    }
//    else {
//        NSLog(@"抱歉，未找到结果");
//    }
//}
////

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.poiInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PositionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    BMKPoiInfo *poiInfo = self.poiInfoList[indexPath.row];
    cell.nameLabel.text = poiInfo.name;
    cell.addressLabel.text = poiInfo.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(positionPickupFinishWithViewTag:poiInfo:)]) {
        BMKPoiInfo *poiInfo = self.poiInfoList[indexPath.row];
        [self.delegate positionPickupFinishWithViewTag:self.viewTag poiInfo:poiInfo];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
