//
//  NSDate+Addition.m
//  Zhcx
//
//  Created by siasun on 17/7/7.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

+ (NSString *)currentDateString
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

@end
