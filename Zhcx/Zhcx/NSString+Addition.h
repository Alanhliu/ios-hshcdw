//
//  NSString+Addition.h
//  Zhcx
//
//  Created by siasun on 17/7/25.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Validation.h"

@interface NSString (Addition)

- (Validation *)validatePhoneNumber;

- (Validation *)validatePassword;

- (Validation *)validateSMSCode;

@end
