//
//  NSDictionary+Addition.m
//  Zhcx
//
//  Created by siasun on 17/6/22.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "NSDictionary+Addition.h"
#import "NSString+Utils.h"
@implementation NSDictionary (Addition)

- (NSString *)dictionaryToString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSDictionary *)dictionaryFromString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"%@",error);
        return nil;
    }
    return dictionary;
}

- (NSData *)dictionaryToData
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

- (NSMutableDictionary *)platformDictionary
{
    NSMutableDictionary *parameter = [self mutableCopy];
    [parameter setObject:@"1" forKey:@"platform"];
    
    return parameter;
}
@end
