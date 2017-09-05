//
//  IWantGoRouteTableViewCell.m
//  Zhcx
//
//  Created by siasun on 17/6/15.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "IWantGoRouteTableViewCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@implementation IWantGoRouteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithLine:(BMKMassTransitRouteLine *)line
{
    //用时
    BMKTime *duration = line.duration;
    NSString *day = duration.dates == 0 ? @"":[NSString stringWithFormat:@"%d天",duration.dates];
    NSString *hour = duration.hours == 0 ? @"":[NSString stringWithFormat:@"%d小时",duration.hours];
    NSString *minute = duration.minutes == 0 ? @"":[NSString stringWithFormat:@"%d分钟",duration.minutes];
    
    NSString *time = [NSString stringWithFormat:@"%@%@%@",day,hour,minute];
    self.timeLabel.text = time;
    
    //步行array
    NSMutableArray *walkSubStepArray = [NSMutableArray new];
    
    //公交名array
    NSMutableArray *nameSubStepArray = [NSMutableArray new];
    
    //站点数array
    NSMutableArray *stationArray = [NSMutableArray new];
    
    for (BMKMassTransitStep *step in line.steps) {
        
        NSPredicate *walkPredicate = [NSPredicate predicateWithBlock:^BOOL(BMKMassTransitSubStep *subStep, NSDictionary<NSString *,id> * _Nullable bindings) {
            return subStep.stepType == BMK_TRANSIT_WAKLING || [subStep.instructions containsString:@"米"];
        }];
        NSPredicate *namePredicate = [NSPredicate predicateWithBlock:^BOOL(BMKMassTransitSubStep *subStep, NSDictionary<NSString *,id> * _Nullable bindings) {
            return
            subStep.stepType == BMK_TRANSIT_SUBWAY ||
            subStep.stepType == BMK_TRANSIT_BUSLINE;
        }];
        NSPredicate *stationPredicate = [NSPredicate predicateWithBlock:^BOOL(BMKMassTransitSubStep *subStep, NSDictionary<NSString *,id> * _Nullable bindings) {
            return
            (subStep.stepType == BMK_TRANSIT_SUBWAY ||
             subStep.stepType == BMK_TRANSIT_BUSLINE) &&
             ((BMKBusVehicleInfo *)subStep.vehicleInfo).passStationNum > 0;
        }];

        [walkSubStepArray addObjectsFromArray:[step.steps filteredArrayUsingPredicate:walkPredicate]];
        
        if ([step.steps filteredArrayUsingPredicate:namePredicate].count > 0) {
            [nameSubStepArray addObject:[[[step.steps filteredArrayUsingPredicate:namePredicate] valueForKeyPath:@"vehicleInfo.name"] componentsJoinedByString:@"/"]];
        }
        
        [stationArray addObjectsFromArray:[step.steps filteredArrayUsingPredicate:stationPredicate]];
    }
    
    //步行多少米
    CGFloat meters = 0;
    for (BMKMassTransitSubStep *step in walkSubStepArray) {
        int m = [[step.instructions stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] intValue];
        meters += m;
    }
    
    NSString *walkMeters;
    if (meters < 1000) {
        walkMeters = [NSString stringWithFormat:@"步行%ld米",(NSInteger)meters];
    } else {
        walkMeters = [NSString stringWithFormat:@"步行%.2f公里",meters/1000];
    }
    self.walkMeterLabel.text = walkMeters;
    
    
    //公交名
    NSString *name = [nameSubStepArray componentsJoinedByString:@" -> "];
    self.nameLabel.text = name;
    
    //经过多少站和起始上车站点
    NSInteger stations = 0;
    for (BMKMassTransitSubStep *step in stationArray) {
        stations += ((BMKBusVehicleInfo *)step.vehicleInfo).passStationNum;
    }
    BMKMassTransitSubStep *step = stationArray.firstObject;
    self.detailLabel.text = [NSString stringWithFormat:@"%ld站  %@上车",stations,step.vehicleInfo.departureStation];
    
    self.time = time;
    self.name = name;
    self.stations = stations;
    self.walkMeters = walkMeters;
}
@end
