//
//  HttpResponseObject.h
//  Zhcx
//
//  Created by siasun on 17/7/25.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResponseObject : NSObject

/**
 终端唯一码（Android为IMEI）
 */
@property (nonatomic, copy) NSString *di;

/**
 服务器时间戳，格式为yyyyMMddhhmmss
 */
@property (nonatomic, copy) NSString *st;

/**
 请求数据明文的MD5签名
 */
@property (nonatomic, copy) NSString *sig;

/**
 加密方式（ 1=MD5(di+ "zhcx")作为密钥pboc3des加密,2=MD5(tk+"zhcx")作为密钥pboc3des加密 ）
 */
@property (nonatomic, copy) NSString *et;

/**
 响应数据加密后的Base64
 */
@property (nonatomic, copy) NSString *rd;

/**
 响应码
 */
@property (nonatomic, copy) NSString *cd;

/**
 错误描述
 */
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSDictionary *body;
@property (nonatomic, strong) NSDictionary *responseData;

@end
