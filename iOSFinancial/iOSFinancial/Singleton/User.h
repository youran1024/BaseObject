//
//  User.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *userNickName;
@property (nonatomic, copy) NSString *userRealName;
@property (nonatomic, copy) NSString *userMale;
@property (nonatomic, copy) NSString *userToken;


+ (User *)sharedUser;



@end
