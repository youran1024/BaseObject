//
//  JRJBaseViewController
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-22.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTViewControllerDelegate.h"

@interface HTBaseViewController : UIViewController <ViewControllerPromptingDelegate,
                                                    ViewControllerKeyboardNotificationDelegate,
                                                    ViewControllerDismissDelegate>


//  键盘是否打开了
@property (nonatomic, assign, readonly)   BOOL isKeyboardAppear;
//  是否第一次load此视图
@property (nonatomic, assign, readonly)   BOOL isFirstLoadView;


/**
 *  重置statesBarStyle
 *
 *  @param Yes is light  no is Default
 */
- (void)changeStateBarStyleLight:(BOOL)light;

//  显示引导图
- (void)showGuideView;
//  需要显示的引导图
- (NSArray *)guideImages;
//  显示引导图
- (void)showGuideViewCheck;


//  获取键盘视图
- (UIView *)keyboardView;

@end
