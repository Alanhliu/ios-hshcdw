//
//  NSDictionary+Addition.h
//  Zhcx
//
//  Created by siasun on 17/6/22.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Addition)


/**
 将字典转化为json字符串

 @return NSString
 */
- (NSString *)dictionaryToString;

/**
 将json字符串转化为字典

 @param jsonString jsonString
 @return NSDictionary
 */
+ (NSDictionary *)dictionaryFromString:(NSString *)jsonString;


/**
 将字典转化为NSData

 @return data
 */
- (NSData *)dictionaryToData;


- (NSMutableDictionary *)platformDictionary;
@end
