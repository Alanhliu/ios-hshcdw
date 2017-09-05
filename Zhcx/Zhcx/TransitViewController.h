//
//  TransitViewController.h
//  Zhcx
//
//  Created by siasun on 17/6/15.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKMassTransitRouteLine;
@class BMKPoiInfo;

@interface TransitViewController : UIViewController
@property (nonatomic, strong) BMKMassTransitRouteLine *line;
@property (nonatomic, strong) BMKPoiInfo *startingPoiInfo;
@property (nonatomic, strong) BMKPoiInfo *finishingPoiInfo;

- (void)configureHeaderViewWithName:(NSString *)name time:(NSString *)time  stationCount:(NSInteger)stationCount walkMeters:(NSString *)walkMeters;

@end
