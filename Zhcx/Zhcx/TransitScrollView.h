//
//  TransitScrollView.h
//  Zhcx
//
//  Created by siasun on 17/6/14.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface TransitScrollView : UIScrollView


/**
 配置TransitScrollView组件内容

 @param staringText 起点
 @param finishingText 终点
 @param routeLine BMKMassTransitRouteLine
 */
- (void)configureTransitScrollViewWithStartingText:(NSString *)staringText finishingText:(NSString *)finishingText routeLine:(BMKMassTransitRouteLine *)routeLine;


/**
 清除TransitScrollView上所有的内容
 */
- (void)clean;

@end
