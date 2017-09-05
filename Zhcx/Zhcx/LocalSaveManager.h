//
//  LocalSaveManager.h
//  Zhcx
//
//  Created by siasun on 17/7/26.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalSaveManager : NSObject

+ (instancetype)sharedInstance;

//token
- (void)saveToken:(NSString *)token;

- (void)removeToken;

- (NSString *)getToken;

//phone
- (void)savePhone:(NSString *)phone;

- (void)removePhone;

- (NSString *)getPhone;

//both
- (void)saveToken:(NSString *)token andPhone:(NSString *)phone;

- (void)removeTokenAndPhone;

@end
