//
//  LoginTableViewController.h
//  Zhcx
//
//  Created by siasun on 17/6/26.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransitionMode) {
    TransitionModePush,
    TransitionModePresent
};

@interface LoginTableViewController : UITableViewController

@property (nonatomic, assign) TransitionMode transitionMode;

@end
