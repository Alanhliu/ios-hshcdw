//
//  NSString+Utils.h
//  Zhcx
//
//  Created by siasun on 17/6/22.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 MD5

 @return string
 */
- (NSString *)md5;

/**
 DES加密

 @return string
 */
- (NSString *)encryptUseDES;

/**
 DES解密

 @return string
 */
- (NSString *)decryptUseDES;

/**
 app版本号

 @return string
 */
+ (NSString *)appVersion;

/**
 设备号

 @return string
 */
+ (NSString *)deviceString;

/**
 唯一UUID

 @return string
 */
+ (NSString *)uniqueUUID;

/**
 将16进制字符串转化为data

 @return data
 */
- (NSData *)hexStringToData;

/**
 将手机号中间四位密文显示

 @return string
 */
- (NSString *)phoneCipherText;
@end
