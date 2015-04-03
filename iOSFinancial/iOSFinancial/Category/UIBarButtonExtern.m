//
//  UIBarButtonExtern.m
//  JRJNews
//
//  Created by Mr.Yang on 14-8-8.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "UIBarButtonExtern.h"
#import "NSString+Size.h"

#define __IOS7_NAVI_SPACE 15


@implementation UIBarButtonExtern

+ (UIBarButtonItem *)nopBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc] initWithCustomView:button];
    flexSpacer.width = __IOS7_NAVI_SPACE;
    
    return flexSpacer;
}

+ (UIBarButtonItem *)flexSpacerBarButtonItem
{
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexSpacer.width = __IOS7_NAVI_SPACE;
    
    return flexSpacer;
}



@end
