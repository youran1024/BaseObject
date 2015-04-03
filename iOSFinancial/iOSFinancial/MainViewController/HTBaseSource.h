//
//  HTBaseSource.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/31.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTBaseCell.h"

@interface HTBaseSource : NSObject

@property (nonatomic, assign)   CGFloat height;

+ (Class)cellClass;

@end
