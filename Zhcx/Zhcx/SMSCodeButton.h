//
//  SMSCodeButton.h
//  VCDemo
//
//  Created by siasun on 17/5/11.
//  Copyright © 2017年 TrueStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSCodeButton : UIButton


/**
 点击后执行倒计时动画

 @param duration 60秒倒计时
 */
- (void)startAnimationWithDuration:(NSInteger)duration;

/**
 恢复按钮初始状态
 */
- (void)recoverInitialStatus;


/**
 清楚计时器
 */
- (void)clearTimer;

@end
