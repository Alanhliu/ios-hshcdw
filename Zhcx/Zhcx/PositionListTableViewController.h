//
//  PositionListTableViewController.h
//  Zhcx
//
//  Created by siasun on 17/6/13.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@protocol PositionListDelegate <NSObject>

- (void)positionPickupFinishWithViewTag:(NSInteger)viewTag poiInfo:(BMKPoiInfo *)poiInfo;

@end

@interface PositionListTableViewController : UITableViewController
@property (nonatomic, weak) id<PositionListDelegate> delegate;
@property (nonatomic, strong) BMKPoiInfo *startingPoiInfo;
@property (nonatomic, strong) BMKPoiInfo *finishingPoiInfo;
@property (nonatomic, assign) NSInteger viewTag;

@end
