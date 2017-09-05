//
//  CommonButton.m
//  Zhcx
//
//  Created by siasun on 17/7/18.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "CommonButton.h"

@implementation CommonButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonUI];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self commonUI];
    }
    
    return self;
}

- (void)commonUI
{
    self.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

@end
