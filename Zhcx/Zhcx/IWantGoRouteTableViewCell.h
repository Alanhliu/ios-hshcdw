//
//  IWantGoRouteTableViewCell.h
//  Zhcx
//
//  Created by siasun on 17/6/15.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKMassTransitRouteLine;

@interface IWantGoRouteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkMeterLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger stations;
@property (nonatomic, copy) NSString *walkMeters;

- (void)configureCellWithLine:(BMKMassTransitRouteLine *)line;

@end
