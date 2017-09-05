//
//  RouteAnnotation.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/8/31.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#ifndef RouteAnnotation_h
#define RouteAnnotation_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface RouteAnnotation : BMKPointAnnotation

///<0:起点 1：终点 2：公交 3：地铁 4：步行 5:驾乘 6:途经点 7:楼梯、电梯
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger degree;

//获取该RouteAnnotation对应的BMKAnnotationView
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;

- (NSInteger)typeWithStepType:(BMKMassTransitType)type;

@end


#endif /* RouteAnnotation_h */
