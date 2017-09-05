//
//  SearchTextFiled.m
//  Zhcx
//
//  Created by siasun on 17/7/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "SearchTextFiled.h"

#define Z_LeftMargin 10

@implementation SearchTextFiled

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        //设置光标颜色
        self.tintColor = [UIColor colorWithRed:76.0/255.0 green:121.0/255.0 blue:233.0/255.0 alpha:1];
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x = Z_LeftMargin;
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x = Z_LeftMargin;
    return rect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect rect = [super placeholderRectForBounds:bounds];
    rect.origin.x = Z_LeftMargin;
    return rect;
}

@end
