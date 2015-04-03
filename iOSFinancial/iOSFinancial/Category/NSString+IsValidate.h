//
//  NSObject+IsValidate.h
//  HealthChat3.0
//
//  Created by Hunter on 3/19/13.
//  Copyright (c) 2013 maomao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IsValidate)
//是否是B股
- (BOOL)isBStock;

//  字符串是不是 == 0
- (BOOL)isValidate;

- (BOOL)isValidate14DateStr;
- (BOOL)isValidateLength;
- (BOOL)isValidateTelPhoneNum;
- (BOOL)isValidatePhone;
- (BOOL)isValidateFaxCode;
- (BOOL)isValidateMailCode;
- (BOOL)isValidatePrice;
- (BOOL)isNumber;
- (BOOL)validateCardId: (NSString *)identityCard;
- (BOOL)validateByRegular:(NSString *)regular;
- (BOOL)isFloatValue;

@end
