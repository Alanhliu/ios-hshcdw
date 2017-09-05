//
//  NSData+Addition.m
//  Zhcx
//
//  Created by siasun on 17/7/24.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "NSData+Addition.h"

@implementation NSData (Addition)

- (NSString *)dataToHexString
{
    NSUInteger len = [self length];
    char *chars = (char *)[self bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i=0; i<len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx",chars[i]]];
    }
    return hexString;
}

@end
