//
//  JSHandler.h
//  Zhcx
//
//  Created by siasun on 17/8/18.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSHandlerProtocol <JSExport>

/*
    多参数的方法
    由于涉及到多参数的问题，从第二个参数开始，外部参数名都要使用大写开头
    因为JS调用OC方法时，是将OC方法拼接连成字符串，如果无法区分就会造成无法识别
    比如对于下面的OC方法，JS调用时
    javascript.sayHelloToWithGreeting(参数1，参数2) //正确写法
    javascript.sayHelloTowithGreeting(参数1，参数2) //错误写法
 */
//- (void)sayHelloTo:(NSString *)name WithGreeting:(NSString *)greeting;

#pragma mark - methods for js

/**
 aes加密
 
 @param text 要加密的内容
 @return 加密字符串
 */
- (NSString *)aesEncryptString:(NSString *)text;

/**
 aes解密
 
 @param text 要加密的内容
 @return 解密字符串
 */
- (NSString *)aesDecryptString:(NSString *)text;


/**
 获取token

 @return token
 */
- (NSString *)getToken;


/**
 显示登录界面
 */
- (void)showLoginScene:(NSString *)message;

@end

@interface JSHandler : NSObject<JSHandlerProtocol>

@end
