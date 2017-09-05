//
//  HttpManager.h
//  Zhcx
//
//  Created by siasun on 17/6/21.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseObject.h"

typedef void(^SuccessBlock)(id response);
typedef void(^FailureBlock)(NSError *error);

@interface HttpManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - APIs
/**
 登录
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
     dev_id         设备id，Android为IMEI
     dev_info       登录的设备信息（例如手机型号信息）
     app_version    App版本号，例如3.4.1
     phone_number   用户登录输入的手机号
     pw             密码MD5
 }
 */
- (void)loginWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 发送验证码
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
     phone_number   用户登录输入的手机号
     biz_type       业务类型（0=注册，1=重置密码)
 }
 */
- (void)sendSMSCodeWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 注册
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
     phone_number   用户登录输入的手机号
     pw             密码MD5
     v_code         验证码
 }
 */
- (void)registWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 登出
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
     token          不能为空
 }
 */
- (void)logoutWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 修改密码
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
     token          不能为空
     original_pw    原始密码MD5
     new_pw         新密码MD5
 }
 */
- (void)modifyPasswordWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 验证手机号
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
     phone          用户登录输入的手机号
 }
 */
- (void)verifyPhoneWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 重置密码
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
     phone_number   用户登录输入的手机号
     pw             密码MD5
     v_code         验证码
 }
 */
- (void)resetPasswordWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 重置密码
 @{
     platform       操作系统（0=Android, 1=iOS）（保留字段）
 }
 */
- (void)queryCityWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

- (void)queryFavoriteWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end
