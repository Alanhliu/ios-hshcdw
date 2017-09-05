//
//  BMKPolyline+Addition.h
//  Zhcx
//
//  Created by siasun on 17/6/28.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

typedef NS_ENUM(NSInteger,PolylineType) {    
    PolylineType_Subway,//地铁
    PolylineType_Train,//火车
    PolylineType_Plane,//飞机
    PolylineType_Busline,//公交
    PolylineType_Driving,//驾车
    PolylineType_Walking,//步行
    PolylineType_Coach,//大巴
};

@interface BMKPolyline (Addition)

@property(nonatomic, strong) NSNumber *type;

@end
