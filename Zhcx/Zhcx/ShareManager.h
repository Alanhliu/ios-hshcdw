//
//  ShareManager.h
//  Zhcx
//
//  Created by siasun on 17/6/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

static NSString * const UM_APP_KEY = @"593e23e4cae7e72b80001911";

@interface ShareManager : NSObject

@property(nonatomic, strong) UMSocialManager *socialManager;

+ (instancetype)sharedInstance;

//below self.socialManager method

/*
 设置系统回调
 -(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
 */

/*
 分享
 -(void)shareToPlatform:(UMSocialPlatformType)platformType
 messageObject:(UMSocialMessageObject *)messageObject
 currentViewController:(id)currentViewController
 completion:(UMSocialRequestCompletionHandler)completion;
 */




@end
