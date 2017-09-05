//
//  TransitViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/15.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "TransitViewController.h"
#import "TransitHeaderView.h"
#import "TransitScrollView.h"
#import "ZViewConstant.h"
#import "RouteAnnotation.h"
#import "BMKPolyline+Addition.h"
#import <Masonry.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#define Z_headerViewHeight 110
@interface TransitViewController ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) TransitScrollView *scrollView;
@property (strong, nonatomic) IBOutlet TransitHeaderView *headerView;

@property (nonatomic, strong) UIView *transitContentView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation TransitViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomLevel:14];
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(Z_headerViewHeight);
    }];
    
    self.transitContentView = [UIView new];
    [self.view addSubview:self.transitContentView];
    [self.self.transitContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Z_ScreenHeight-Z_headerViewHeight);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@(Z_ScreenHeight));
    }];
    
    [self.transitContentView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transitContentView.mas_top).offset(0);
        make.left.equalTo(self.transitContentView.mas_left).offset(0);
        make.right.equalTo(self.transitContentView.mas_right).offset(0);
        make.height.equalTo(@(Z_headerViewHeight));
    }];
    
    self.scrollView = [[TransitScrollView alloc] init];
    [self.transitContentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.left.equalTo(self.transitContentView.mas_left).offset(0);
        make.right.equalTo(self.transitContentView.mas_right).offset(0);
        make.height.equalTo(@(Z_ScreenHeight - Z_headerViewHeight));
    }];
    
    [self.scrollView configureTransitScrollViewWithStartingText:self.startingPoiInfo.name finishingText:self.finishingPoiInfo.name routeLine:self.line];
    
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.transitContentView];
    
    [self drawRouteLine];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickHeaderView:(id)sender {
    if (self.transitContentView.frame.origin.y == 0) {
        [self.transitContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(Z_ScreenHeight-Z_headerViewHeight);
        }];
    } else {
        [self.transitContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(0);
        }];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)configureHeaderViewWithName:(NSString *)name time:(NSString *)time stationCount:(NSInteger)stationCount walkMeters:(NSString *)walkMeters
{
    self.headerView.nameLabel.text = name;
    self.headerView.detailLabel.text = [NSString stringWithFormat:@"%@ - %ld站 - %@",time,stationCount,walkMeters];
}

- (void)drawRouteLine
{
    BMKMassTransitRouteLine *routeLine = self.line;
    
    BOOL startCoorIsNull = YES;
    CLLocationCoordinate2D startCoor;//起点经纬度
    CLLocationCoordinate2D endCoor;//终点经纬度
    
    NSInteger size = [routeLine.steps count];

    for (NSInteger i = 0; i < size; i++) {
        BMKMassTransitStep *transitStep = [routeLine.steps objectAtIndex:i];
        for (BMKMassTransitSubStep *subStep in transitStep.steps) {
            //添加annotation节点
            if (subStep.stepType != BMK_TRANSIT_WAKLING) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                item.coordinate = subStep.entraceCoor;
                item.title = subStep.instructions;
                item.type = [item typeWithStepType:subStep.stepType];
                [_mapView addAnnotation:item];
            }
            
            if (startCoorIsNull) {
                startCoor = subStep.entraceCoor;
                startCoorIsNull = NO;
            }
            endCoor = subStep.exitCoor;
            
            //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
            if (transitStep.isSubStep == NO) {//是子方案，只取第一条方案
                break;
            }
            else {
                //是子路段，需要完整遍历transitStep.steps
            }
        }
    }
    
    //添加起点标注
    RouteAnnotation* startAnnotation = [[RouteAnnotation alloc]init];
    startAnnotation.coordinate = startCoor;
    startAnnotation.title = @"起点";
    startAnnotation.type = 0;
    [_mapView addAnnotation:startAnnotation]; // 添加起点标注
    //添加终点标注
    RouteAnnotation* endAnnotation = [[RouteAnnotation alloc]init];
    endAnnotation.coordinate = endCoor;
    endAnnotation.title = @"终点";
    endAnnotation.type = 1;
    [_mapView addAnnotation:endAnnotation]; // 添加终点标注
    
    
    double maxLat = 0.0;
    double maxLng = 0.0;
    double minLat = MAXFLOAT;
    double minLng = MAXFLOAT;
    
    NSMutableArray *lineArray = [NSMutableArray new];
    
    NSInteger index = 0;
    for (BMKMassTransitStep* transitStep in routeLine.steps) {
        for (BMKMassTransitSubStep *subStep in transitStep.steps) {
            for (NSInteger i = 0; i < subStep.pointsCount; i++) {
                
                CLLocationCoordinate2D coor = BMKCoordinateForMapPoint(subStep.points[i]);
                maxLat = MAX(maxLat, coor.latitude);
                maxLng = MAX(maxLng, coor.longitude);
                minLat = MIN(minLat, coor.latitude);
                minLng = MIN(minLng, coor.longitude);

                index++;
                
                BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:subStep.points count:subStep.pointsCount];
                polyLine.type = @(subStep.stepType);
                [lineArray addObject:polyLine];
            }
            
            //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
            if (transitStep.isSubStep == NO) {//是子方案，只取第一条方案
                break;
            }
            else {
                //是子路段，需要完整遍历transitStep.steps
            }
        }
    }
    
    [_mapView addOverlays:lineArray];
    
    CLLocationCoordinate2D coor;
    coor.latitude = (maxLat + minLat) / 2;
    coor.longitude = (maxLng + minLng) / 2;
    double delta = MAX(maxLat-coor.latitude, maxLng-coor.longitude) + 0.01;
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(delta, delta));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    _mapView.zoomLevel = 14;
    
    //[self mapViewFitPolyLine:polyLine];
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        NSInteger type = [((BMKPolyline *)overlay).type integerValue];
        
        UIColor *fillColor;
        UIColor *strokeColor;
        
        if (type == PolylineType_Walking) {
            fillColor = [UIColor greenColor];
            strokeColor = [UIColor greenColor];
        } else if (type == PolylineType_Subway) {
            fillColor = [UIColor blueColor];
            strokeColor = [UIColor blueColor];
        } else if (type == PolylineType_Busline) {
            fillColor = [UIColor blueColor];
            strokeColor = [UIColor blueColor];
        } else {
            fillColor = [UIColor blueColor];
            strokeColor = [UIColor blueColor];
        }
        
        polylineView.fillColor = fillColor;
        polylineView.strokeColor = strokeColor;
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - tools method
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *)polyLine
{
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
