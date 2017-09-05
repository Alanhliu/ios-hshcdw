//
//  IWantGoViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "IWantGoViewController.h"
#import "IWantGoRouteTableViewCell.h"
#import "PositionListTableViewController.h"
#import "TransitViewController.h"
#import "TransitScrollView.h"
#import "UIAlertController+Addition.h"
#import "IWantGoConstant.h"
#import <Masonry.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface IWantGoViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,PositionListDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *searchWrapperView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *reverseButton;

@property (weak, nonatomic) IBOutlet UIImageView *startingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *finishingImageView;
@property (weak, nonatomic) IBOutlet UILabel *startingLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishingLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *startingTapGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *finishingTagGesture;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKPoiInfo *startingPoiInfo;
@property (nonatomic, strong) BMKPoiInfo *finishingPoiInfo;

@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

@property (nonatomic, strong) BMKUserLocation *userLocation;

@property (nonatomic, assign) BOOL order;
@property (nonatomic, assign) BOOL useUserLocation;
@property (nonatomic, assign) NSInteger viewTag;

@property (nonatomic, strong) NSArray *routeArray;

@property (nonatomic, strong) UIActivityIndicatorView *aiv;

@end

@implementation IWantGoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.locationService.delegate = self;
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.locationService.delegate = nil;
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.order = YES;
    self.useUserLocation = YES;
    self.startingLabel.tag = StartingLabelTag;
    self.finishingLabel.tag = FinishLabelTag;
    
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomLevel:14];    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchWrapperView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.startingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(self.startingImageView.mas_right).offset(10);
        make.right.equalTo(self.searchButton.mas_left).offset(-10);
        make.centerY.equalTo(self.startingImageView.mas_centerY);
    }];
    [self.finishingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(self.finishingImageView.mas_right).offset(10);
        make.right.equalTo(self.searchButton.mas_left).offset(-10);
        make.centerY.equalTo(self.finishingImageView.mas_centerY);
    }];
    
    self.startingLabel.text = DefaultPosition;
    
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    [self.locationService setDistanceFilter:10];
    [self.locationService startUserLocationService];
    
    [self.startingLabel addGestureRecognizer:self.startingTapGesture];
    [self.finishingLabel addGestureRecognizer:self.finishingTagGesture];
}

- (IBAction)showMap:(id)sender {
    self.mapView.hidden = NO;
    [self.mapView updateLocationData:self.userLocation];
    [self.mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
}

- (IBAction)reversePosition:(id)sender {
    
    [self.startingLabel removeGestureRecognizer:self.startingTapGesture];
    [self.startingLabel removeGestureRecognizer:self.finishingTagGesture];
    [self.finishingLabel removeGestureRecognizer:self.startingTapGesture];
    [self.finishingLabel removeGestureRecognizer:self.finishingTagGesture];

    BMKPoiInfo *tempPoiInfo = self.startingPoiInfo;
    self.startingPoiInfo = self.finishingPoiInfo;
    self.finishingPoiInfo = tempPoiInfo;
    
    self.order = !self.order;
    if (self.order) {
        self.startingLabel.tag = StartingLabelTag;
        self.finishingLabel.tag = FinishLabelTag;
        if (!self.finishingPoiInfo)
            self.finishingLabel.text = @"请输入终点";
        
        [self.startingLabel addGestureRecognizer:self.startingTapGesture];
        [self.finishingLabel addGestureRecognizer:self.finishingTagGesture];
        
        [self.startingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(self.startingImageView.mas_right).offset(10);
            make.right.equalTo(self.searchButton.mas_left).offset(-10);
            make.centerY.equalTo(self.startingImageView.mas_centerY);
        }];
        [self.finishingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(self.finishingImageView.mas_right).offset(10);
            make.right.equalTo(self.searchButton.mas_left).offset(-10);
            make.centerY.equalTo(self.finishingImageView.mas_centerY);
        }];
        [UIView animateWithDuration:AnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
        
    } else {
        self.startingLabel.tag = FinishLabelTag;
        self.finishingLabel.tag = StartingLabelTag;
        if (!self.startingPoiInfo)
            self.finishingLabel.text = @"请输入起点";
        
        [self.finishingLabel addGestureRecognizer:self.startingTapGesture];
        [self.startingLabel addGestureRecognizer:self.finishingTagGesture];
        
        [self.finishingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(self.startingImageView.mas_right).offset(10);
            make.right.equalTo(self.searchButton.mas_left).offset(-10);
            make.centerY.equalTo(self.startingImageView.mas_centerY);
        }];
        [self.startingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(self.finishingImageView.mas_right).offset(10);
            make.right.equalTo(self.searchButton.mas_left).offset(-10);
            make.centerY.equalTo(self.finishingImageView.mas_centerY);
        }];
        [UIView animateWithDuration:AnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    if (self.startingPoiInfo && self.finishingPoiInfo) {
        [self search:nil];
    }
}

- (IBAction)chooseStartingPosition:(UITapGestureRecognizer *)gesture {
    PositionListTableViewController *positionListTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PositionListTableViewController"];
    positionListTableViewController.delegate = self;
    positionListTableViewController.startingPoiInfo = self.startingPoiInfo;
    positionListTableViewController.viewTag = gesture.view.tag;
    [self.navigationController pushViewController:positionListTableViewController animated:NO];
}

- (IBAction)chooseFinishingPosition:(UITapGestureRecognizer *)gesture {
    PositionListTableViewController *positionListTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PositionListTableViewController"];
    positionListTableViewController.delegate = self;
    positionListTableViewController.finishingPoiInfo = self.finishingPoiInfo;
    positionListTableViewController.viewTag = gesture.view.tag;
    [self.navigationController pushViewController:positionListTableViewController animated:NO];
}

- (IBAction)search:(id)sender {
    
    NSString *text;
    if (!self.startingPoiInfo) {
        text = @"请输入起点";
        [UIAlertController showAlertControllerText:text onViewController:self];
        return;
    }
    if (!self.finishingPoiInfo) {
        text = @"请输入终点";
        [UIAlertController showAlertControllerText:text onViewController:self];
        return;
    }
    self.mapView.hidden = YES;
    
    [self.aiv startAnimating];
    self.tableView.hidden = YES;
    
    _routeSearch = [[BMKRouteSearch alloc] init];
    //设置delegate，用于接收检索结果
    _routeSearch.delegate = self;
    //构造公共交通路线规划检索信息类
    BMKPlanNode* start = [[BMKPlanNode alloc] init];
    start.name = self.startingPoiInfo.name;
    start.cityName = self.startingPoiInfo.city;
    start.pt = self.startingPoiInfo.pt;
    
    BMKPlanNode* end = [[BMKPlanNode alloc] init];
    end.name = self.finishingPoiInfo.name;
    end.cityName = self.finishingPoiInfo.city;
    end.pt = self.finishingPoiInfo.pt;
    
    BMKMassTransitRoutePlanOption *option = [[BMKMassTransitRoutePlanOption alloc] init];
    option.from = start;
    option.to = end;
    //发起检索
    [_routeSearch massTransitSearch:option];
}

#pragma mark - BMKRouteSearchDelegate
- (void)onGetMassTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKMassTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    [self.aiv stopAnimating];
    self.tableView.hidden = NO;
    
    self.routeArray = result.routes;
    [self.tableView reloadData];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IWantGoRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IWantGoRouteTableViewCell"];
    BMKMassTransitRouteLine *line = self.routeArray[indexPath.row];
    [cell configureCellWithLine:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKMassTransitRouteLine *line = self.routeArray[indexPath.row];
    
    TransitViewController *transitViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TransitViewController"];
    transitViewController.line = line;
    transitViewController.startingPoiInfo = self.startingPoiInfo;
    transitViewController.finishingPoiInfo = self.finishingPoiInfo;
    
    IWantGoRouteTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [transitViewController configureHeaderViewWithName:cell.name time:cell.time stationCount:cell.stations walkMeters:cell.walkMeters];
    [self.navigationController pushViewController:transitViewController animated:NO];
}

#pragma mark - PositionListDelegate
- (void)positionPickupFinishWithViewTag:(NSInteger)viewTag poiInfo:(BMKPoiInfo *)poiInfo
{
    ((UILabel *)([self.searchWrapperView viewWithTag:viewTag])).text = poiInfo.name;
    if (viewTag == StartingLabelTag) {
        self.startingPoiInfo = poiInfo;
    } else {
        self.finishingPoiInfo = poiInfo;
    }
    
    if (self.startingPoiInfo && self.finishingPoiInfo) {
        [self search:nil];
    }
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
    
    self.startingPoiInfo = [[BMKPoiInfo alloc] init];
    self.startingPoiInfo.pt = userLocation.location.coordinate;
    self.startingPoiInfo.name = userLocation.title;
    
    [self.mapView updateLocationData:userLocation];
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{

}

- (void)didStopLocatingUser
{

}

- (UIActivityIndicatorView *)aiv
{
    if (!_aiv) {
        _aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_aiv];
        [_aiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@30);
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@40);
        }];
    }
    return _aiv;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
