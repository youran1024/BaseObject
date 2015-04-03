//
//  MCPlaceHolderTextView.h
//  HealthChat3.0
//
//  Created by maomao on 12-12-11.
//  Copyright (c) 2012年 maomao. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  带PlaceHolder的TextView
 */
@interface MCPlaceHolderTextView : UITextView

@property(nonatomic, strong) NSString *placeholder;

@property(nonatomic, strong) UIColor *placeholderColor;

//  省略号的状态
@property(nonatomic, assign) BOOL ellipsisState;

- (void)setPlaceHolderVisible:(BOOL)hidden;

@end
