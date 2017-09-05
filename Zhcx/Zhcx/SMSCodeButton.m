//
//  SMSCodeButton.m
//  VCDemo
//
//  Created by siasun on 17/5/11.
//  Copyright © 2017年 TrueStudio. All rights reserved.
//

#import "SMSCodeButton.h"

static NSString *const InitialText = @"发送验证码";

@interface SMSCodeButton()

@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, assign) NSInteger count;

@end

@implementation SMSCodeButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:150.0/255.0 blue:200.0/255.0 alpha:1];
    [self.layer setCornerRadius:7.0];
    [self.layer setMasksToBounds:YES];
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.count == 1) {
            [strongSelf recoverInitialStatus];
        } else {
            [strongSelf setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            strongSelf.count --;
            [strongSelf setTitle:[NSString stringWithFormat:@"%ld秒",self.count] forState:UIControlStateNormal];
        }
    });
}

- (void)startAnimationWithDuration:(NSInteger)duration
{
    self.userInteractionEnabled = NO;
    self.count = duration;
    dispatch_resume(self.timer);
}

- (void)recoverInitialStatus
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dispatch_suspend(self.timer);
    self.userInteractionEnabled = YES;
    [self setTitle:InitialText forState:UIControlStateNormal];
}

- (void)clearTimer
{
    dispatch_suspend(self.timer);
}

@end
