//
//  SharePopView.h
//  Zhcx
//
//  Created by siasun on 17/6/20.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShareType) {
    ShareTypeImage,
    ShareTypeWebPage,
};

@interface SharePopView : UIView

+ (instancetype)sharedInstance;

@property (nonatomic, assign) ShareType shareType;

- (void)showOnViewController:(UIViewController *)viewController;

@end
