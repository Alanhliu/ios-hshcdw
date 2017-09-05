//
//  TransitScrollView.m
//  Zhcx
//
//  Created by siasun on 17/6/14.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "TransitScrollView.h"
#import "ZViewConstant.h"

#define Z_LeftMargin 60
#define Z_OriginTopMargin 10
#define Z_StartingFinishingLabelHeight 20
#define Z_WalkLabelColor [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1]
@implementation TransitScrollView
{
    CGFloat contentSizeHeight;
    NSArray *_Color_Array;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        _Color_Array = @[
                                    [UIColor redColor],
                                    [UIColor orangeColor],
                                    [UIColor blueColor]
                                ];
    }
    
    return self;
}

#pragma mark - configure TransitScrollView
- (void)configureTransitScrollViewWithStartingText:(NSString *)staringText finishingText:(NSString *)finishingText routeLine:(BMKMassTransitRouteLine *)routeLine
{
    UILabel *starttingLabel = [self startingLabel:staringText];
    starttingLabel.frame = CGRectMake(Z_LeftMargin, Z_OriginTopMargin, Z_ScreenWidth-Z_LeftMargin, Z_StartingFinishingLabelHeight);
    [self addSubview:starttingLabel];
    
    CGFloat startY = Z_OriginTopMargin + Z_StartingFinishingLabelHeight+5;
    
    for (NSInteger i=0; i<routeLine.steps.count; i++) {
        BMKMassTransitStep *step = routeLine.steps[i];
        
        NSArray *subSteps = step.steps;
        BMKMassTransitSubStep *subStep = subSteps.firstObject;
        
        NSInteger duration = subStep.duration;
        
        if (subStep.stepType != BMK_TRANSIT_WAKLING) {
            BMKBaseVehicleInfo *baseInfo = subStep.vehicleInfo;
            //公交名array
            NSMutableArray *nameSubStepArray = [NSMutableArray new];
            for (NSInteger j=0; j<subSteps.count; j++) {
                BMKMassTransitSubStep *subStep = subSteps[j];
                [nameSubStepArray addObject:subStep.vehicleInfo.name];
            }
            
            NSString *busName = [nameSubStepArray componentsJoinedByString:@"/"];
            NSString *departureStation = baseInfo.departureStation;
            NSString *arriveStation = baseInfo.arriveStation;
            NSInteger passStationNum;
            NSString *firstTime;
            NSString *lastTime;
            
            if ([subStep.vehicleInfo isKindOfClass:BMKBusVehicleInfo.class]) {
                BMKBusVehicleInfo *info = (BMKBusVehicleInfo *)subStep.vehicleInfo;
                passStationNum = info.passStationNum;
                firstTime = info.firstTime;
                lastTime = info.lastTime;
            }
            
            //在subStep.instructions中找到公交行进方向
            NSString *directionText;
            if ([subStep.instructions containsString:@"方向"]) {
                NSInteger index = 0;
                while (![directionText containsString:@"方向"]) {
                    NSInteger from = [subStep.instructions rangeOfString:@"(" options:0 range:NSMakeRange(index, subStep.instructions.length - index)].location;
                    
                    NSInteger to = [subStep.instructions rangeOfString:@")" options:0 range:NSMakeRange(index, subStep.instructions.length - index)].location;
                    
                    index = to+1;
                    
                    if (from > 0 && to > from) {
                        directionText = [subStep.instructions substringWithRange:NSMakeRange(from+1, to-from-1)];
                    }
                }
            }
            
            //地铁1号线
            UILabel *busLabel = [self busLabel:busName index:i];
            busLabel.frame = CGRectMake(Z_LeftMargin, startY, [self busLabelWidth:busName], 20);
            [self addSubview:busLabel];
            
            //方向
            UILabel *directionLabel = [self directionLabel:directionText];
            directionLabel.frame = CGRectMake(Z_LeftMargin, CGRectGetMaxY(busLabel.frame)+15, Z_ScreenWidth-Z_LeftMargin, 20);
            [self addSubview:directionLabel];
            
            //首班车时间
            UILabel *firstTimeLabel = [self timeLabel:firstTime];
            firstTimeLabel.frame = CGRectMake(Z_LeftMargin, CGRectGetMaxY(directionLabel.frame)+10, [self timeLabelWidth:firstTime], 20);
            [self addSubview:firstTimeLabel];
            
            //末班车时间
            UILabel *lastTimeLabel = [self timeLabel:lastTime];
            lastTimeLabel.frame = CGRectMake(CGRectGetMaxX(firstTimeLabel.frame)+10, CGRectGetMaxY(directionLabel.frame)+10, [self timeLabelWidth:lastTime], 20);
            [self addSubview:lastTimeLabel];
            
            //出发站
            UILabel *departureStationLabel = [self arriveStationLabel:departureStation];
            departureStationLabel.frame = CGRectMake(Z_LeftMargin, CGRectGetMaxY(lastTimeLabel.frame)+10, Z_ScreenWidth-Z_LeftMargin, 20);
            [self addSubview:departureStationLabel];
            
            //到站
            UILabel *arriveStationLabel = [self departureStationLabel:arriveStation];
            arriveStationLabel.frame = CGRectMake(Z_LeftMargin, CGRectGetMaxY(departureStationLabel.frame)+10, Z_ScreenWidth-Z_LeftMargin, 20);
            [self addSubview:arriveStationLabel];
            
            //乘车时间
            UILabel *durationLabel = [self durationLabel:duration isWalk:NO index:i];
            durationLabel.frame = CGRectMake(0, startY+(CGRectGetMaxY(arriveStationLabel.frame)-CGRectGetMidY(busLabel.frame))/2 - 20, Z_LeftMargin, 40);
            [self addSubview:durationLabel];
            
            startY = CGRectGetMaxY(arriveStationLabel.frame) + 10;
            
        } else {
            //步行🚶
            startY += 15;
            UILabel *walkLabel = [self walkLabel:subStep.instructions];
            walkLabel.frame = CGRectMake(Z_LeftMargin, startY, Z_ScreenWidth-Z_LeftMargin, 40);
            [self addSubview:walkLabel];
            
            //步行时间
            UILabel *durationLabel = [self durationLabel:duration isWalk:YES index:i];
            durationLabel.frame = CGRectMake(0, startY, Z_LeftMargin, 40);
            [self addSubview:durationLabel];
            
            startY = CGRectGetMaxY(walkLabel.frame) + 10;
            startY += 15;
        }
    }
    
    UILabel *finishingLabel = [self finishingLabel:finishingText];
    finishingLabel.frame = CGRectMake(Z_LeftMargin, startY+5, Z_ScreenWidth-Z_LeftMargin, Z_StartingFinishingLabelHeight);
    [self addSubview:finishingLabel];

    contentSizeHeight = CGRectGetMaxY(finishingLabel.frame)+10;
    [self setContentSize:CGSizeMake(Z_ScreenWidth, contentSizeHeight)];
}

#pragma mark - walk label
- (UILabel *)walkLabel:(NSString *)walkText
{
    UILabel *label = [UILabel new];
    label.text = walkText;
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = Z_WalkLabelColor;
    return label;
}

#pragma mark - time label 
static NSInteger timeLabelFontSize = 14;
- (UILabel *)timeLabel:(NSString *)timeText
{
    UILabel *label = [UILabel new];
    label.text = timeText;
    label.font = [UIFont boldSystemFontOfSize:timeLabelFontSize];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

- (CGFloat)timeLabelWidth:(NSString *)timeText
{
    CGSize size = [timeText boundingRectWithSize:CGSizeMake(Z_ScreenWidth-Z_LeftMargin, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:timeLabelFontSize]} context:nil].size;
    return size.width+10;
}

#pragma mark - duration label 
- (UILabel *)durationLabel:(NSInteger)duration isWalk:(BOOL)walk index:(NSInteger)index
{
    UILabel *label = [UILabel new];
    int minute = ceil(duration/60);
    if (minute == 0)
        minute = 1;
    
    label.text = [NSString stringWithFormat:@"%d分钟",minute];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    if (walk) {
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = Z_WalkLabelColor;
    } else {
        label.textColor = [self color:index];
    }
    return label;
}

#pragma mark - direction label 
- (UILabel *)directionLabel:(NSString *)directionText
{
    UILabel *label = [UILabel new];
    label.text = directionText;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

#pragma mark - bus label
static NSInteger busLabelFontSize = 14;
- (UILabel *)busLabel:(NSString *)busText index:(NSInteger)index
{
    UILabel *label = [UILabel new];
    label.text = busText;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:busLabelFontSize];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [self color:index];
    
    [label.layer setCornerRadius:5.0];
    [label.layer setMasksToBounds:YES];
    return label;
}

- (CGFloat)busLabelWidth:(NSString *)busText
{
    CGSize size = [busText boundingRectWithSize:CGSizeMake(Z_ScreenWidth-Z_LeftMargin, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:busLabelFontSize]} context:nil].size;
    return size.width+10;
}

#pragma mark - starting/finishing label
- (UILabel *)startingLabel:(NSString *)startingText
{
    UILabel *label = [self SF_Label];
    NSString *text = [NSString stringWithFormat:@"起点(%@)",startingText];
    label.text = text;
    return label;
}

- (UILabel *)finishingLabel:(NSString *)finishingText
{
    UILabel *label = [self SF_Label];
    NSString *text = [NSString stringWithFormat:@"终点(%@)",finishingText];
    label.text = text;
    return label;
}

- (UILabel *)SF_Label
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    return label;
}

#pragma mark - station label
- (UILabel *)stationLabel:(NSString *)stationText
{
    UILabel *label = [UILabel new];
    label.text = stationText;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

- (UILabel *)departureStationLabel:(NSString *)departureStationText
{
    UILabel *label = [self DA_Label];
    label.text = departureStationText;
    return label;
}

- (UILabel *)arriveStationLabel:(NSString *)arriveStationText
{
    UILabel *label = [self DA_Label];
    label.text = arriveStationText;
    return label;
}

- (UILabel *)DA_Label
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    return label;
}

#pragma mark - Color_Array

- (UIColor *)color:(NSInteger)index
{
    if (index >= _Color_Array.count) {
        index = index % _Color_Array.count;
    }
    return _Color_Array[index];
}

#pragma mark - clean TransitScrollView
- (void)clean{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}
@end
