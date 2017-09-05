//
//  ShareManager.m
//  Zhcx
//
//  Created by siasun on 17/6/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "ShareManager.h"

static NSString * const WX_APP_ID = @"wx866552fdffc90228";
static NSString * const WX_APP_SECRET = @"894cbc0ab7550ea718a81d4819a02301";

static NSString * const QQ_APP_ID = @"";
static NSString * const QQ_APP_KEY = @"";

static NSString * const SINA_APP_ID = @"";
static NSString * const SINA_APP_KEY = @"";

@implementation ShareManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ShareManager *shareManager = nil;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (id)init
{
    if (!(self = [super init])) return nil;

    self.socialManager = [UMSocialManager defaultManager];
    
    /* 打开调试日志 */
//    [self.socialManager openLog:YES];
    
    /* 设置友盟appkey */
    [self.socialManager setUmSocialAppkey:UM_APP_KEY];
    
    
    //platforms
    /* 设置微信的appKey和appSecret */
    [self.socialManager setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_ID appSecret:WX_APP_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置分享到QQ互联的appID
     U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。*/
    [self.socialManager setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [self.socialManager setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

    
    return self;
}


@end
