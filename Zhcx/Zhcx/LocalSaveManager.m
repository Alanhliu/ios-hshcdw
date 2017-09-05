//
//  LocalSaveManager.m
//  Zhcx
//
//  Created by siasun on 17/7/26.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "LocalSaveManager.h"
#import <UICKeyChainStore.h>
@implementation LocalSaveManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static LocalSaveManager *localSaveManager = nil;
    dispatch_once(&onceToken, ^{
        localSaveManager = [[self alloc] init];
    });
    return localSaveManager;
}

- (void)saveToken:(NSString *)token
{
    [[UICKeyChainStore keyChainStore] setString:token forKey:@"token"];
}

- (void)removeToken
{
    [[UICKeyChainStore keyChainStore] removeItemForKey:@"token"];
}

- (NSString *)getToken
{
    NSString *token = [[UICKeyChainStore keyChainStore] stringForKey:@"token"];
    return token;
}


- (void)savePhone:(NSString *)phone
{
    [[UICKeyChainStore keyChainStore] setString:phone forKey:@"phone"];
}

- (void)removePhone
{
    [[UICKeyChainStore keyChainStore] removeItemForKey:@"phone"];
}

- (NSString *)getPhone
{
    return [[UICKeyChainStore keyChainStore] stringForKey:@"phone"];
}

- (void)saveToken:(NSString *)token andPhone:(NSString *)phone
{
    [self saveToken:token];
    [self savePhone:phone];
}

- (void)removeTokenAndPhone
{
    [self removeToken];
    [self removePhone];
}
@end
