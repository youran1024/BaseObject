

//
//  HTBaseViewController.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-22.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseViewController.h"
#import "SDImageCache.h"
#import "UIBarButtonExtern.h"
#import "UIView+Prompting.h"

@interface HTBaseViewController () <UIActionSheetDelegate>
{
    BOOL   _isFirstLoadView;
    BOOL   _isKeyboardAppear;
}

@property (nonatomic, strong)   NSMutableArray *guideImageArray;

@end

@implementation HTBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNavigationItem];
    
    //  显示引导页
    [self showGuideViewCheck];
    
    //  清除NavigationBar上边的返回文字
    [self clearBackBarButtonItemTitle];
}

- (void)addCloseBarbutton
{
    if (self.navigationController.viewControllers.count == 1) {
        //        self.navigationItem.leftBarButtonItem = [UIBarButtonExtern closeBarButtonItem:@selector(closeButtonClicked:) andTarget:self];
    }
}

- (void)closeButtonClicked:(UIBarButtonItem *)barbutton
{
    [self dissmissViewController];
}

#pragma mark -

- (void)clearBackBarButtonItemTitle
{
    //  左侧返回标题为空
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}

- (void)addNavigationItem
{
    if(APPSystemVersion >= 7){
        UIBarButtonItem *flexSpacer = [UIBarButtonExtern flexSpacerBarButtonItem];
        
        NSArray * tempR = [NSArray arrayWithObjects:flexSpacer,[self rightNavigationBarItem],nil];
        [self.navigationItem setRightBarButtonItems:tempR];
        
        if ([self leftNavigationImageStr]) {
            NSArray *tempL = [NSArray arrayWithObjects:flexSpacer, [self leftNavigationBarItem], [UIBarButtonExtern nopBarButtonItem], nil];
            [self.navigationItem setLeftBarButtonItems:tempL];
        }
        
    }else{
        //  NavigationBar左右工具按钮
        self.navigationItem.leftBarButtonItem = [self leftNavigationBarItem];
        self.navigationItem.rightBarButtonItem = [self rightNavigationBarItem];
    }
}

#pragma mark - handleKeyboard

- (void)addKeyboardNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDisappear:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)removeKeyboardNotifaction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)noti
{
    _isKeyboardAppear = YES;
    CGRect keyboardFrame = [[noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [self keyboardWillAppear:noti withKeyboardRect:keyboardFrame];
}

- (void)keyboardWillDisappear:(NSNotification *)noti
{
    _isKeyboardAppear = NO;
    CGRect keyboardFrame = [[noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [self keyboardWillDisappear:noti withKeyboardRect:keyboardFrame];
}

- (void)keyboardDidAppear:(NSNotification *)noti
{
    _isKeyboardAppear = YES;
    CGRect keyboardFrame = [[noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [self keyboardDidAppear:noti withKeyboardRect:keyboardFrame];
}

- (void)keyboardDidDisappear:(NSNotification *)noti
{
    _isKeyboardAppear = NO;
    CGRect keyboardFrame = [[noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [self keyboardDidDisappear:noti withKeyboardRect:keyboardFrame];
}

- (void)keyboardWillAppear:(NSNotification *)noti withKeyboardRect:(CGRect)rect
{
    
    
}

- (void)keyboardWillDisappear:(NSNotification *)noti withKeyboardRect:(CGRect)rect
{
    
}

- (void)keyboardDidAppear:(NSNotification *)noti withKeyboardRect:(CGRect)rect
{
    
}

- (void)keyboardDidDisappear:(NSNotification *)noti withKeyboardRect:(CGRect)rect
{
    
}

#pragma mark - FirstLoadSign
#define ViewFirstLoadSign   @"viewFirstLoadSign"

- (void)showGuideViewCheck
{
    if (self.isFirstLoadView) {
        [self showGuideView];
    }
    
    self.isFirstLoadView = NO;
}

- (void)setIsFirstLoadView:(BOOL)isFirstLoadView
{
    _isFirstLoadView = isFirstLoadView;
    
    NSString *key = HTSTR(@"%@%@", ViewFirstLoadSign, NSStringFromClass([self class]));
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@(!_isFirstLoadView)  forKey:key];
    [userDefault synchronize];
}

- (BOOL)isFirstLoadView
{
    NSString *key = HTSTR(@"%@%@", ViewFirstLoadSign, NSStringFromClass([self class]));
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _isFirstLoadView = ![[userDefault valueForKey:key] boolValue];
    
    return _isFirstLoadView;
}

- (void)showGuideView
{
    NSArray *guideImages = [self guideImages];
    NSInteger count = guideImages.count;
    
    if (count == 0) {
        return;
    }
    
    NSMutableArray *guideImageViewArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        
        NSString *imageStr = [guideImages objectAtIndex:i];
        
        if (is4Inch) {
            imageStr = HTSTR(@"%@5", imageStr);
        }else if (is47Inch) {
            imageStr = HTSTR(@"%@47", imageStr);
        }
        
        UIImage *image = HTImageNamed(imageStr);
        
        if (!image) {
            return;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        if (i == count - 1) {
            //最后一张的标记
            imageView.tag = 9;
        }
        
        if (i > 0) {
            imageView.hidden = YES;
        }
        
        [guideImageViewArray addObject:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
        _guideImageArray = guideImageViewArray;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideViewTouched:)];
        [imageView addGestureRecognizer:tap];
        UIWindow *window;
        if (self.isKeyboardAppear) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:1];
        }else {
            window = [[UIApplication sharedApplication] keyWindow];
        }
        
        [window addSubview:imageView];
        
        
        imageView.frame = CGRectMake(0, 0, APPScreenWidth, CGRectGetHeight(window.frame));
    }
}

- (NSArray *)guideImages
{
    return nil;
}

- (void)guideViewTouched:(UITapGestureRecognizer *)tap
{
    NSInteger count = _guideImageArray.count;
    
    UIView *view = tap.view;
    
    if (view.tag < (count - 1)) {
        UIView *nextView = [_guideImageArray objectAtIndex:view.tag + 1];
        nextView.hidden = NO;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        view.alpha = .0;
    } completion:^(BOOL finished) {
        if (view.tag == 9) {
            _guideImageArray = nil;
        }
        [view removeFromSuperview];
    }];
}


#pragma mark - AlertView
- (void)showAlert:(NSString *)message
{
    //  兼容ios8弹框
    if (APPSystemVersion<8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
        
        [alertController addAction:alertAction];
        
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    
}

//  iOS 8
- (void)showActionSheet:(NSString *)title andButtonArray:(NSArray *)buttonArray andButtonBlcok:(void(^)(NSInteger buttonIndex))handleBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    for (int i = 0; i < buttonArray.count; i++) {
        
        if (i == 0) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonArray[i] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                handleBlock(i);
            }];
            
            [alertController addAction:alertAction];
        } else if (i == 1) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonArray[i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                handleBlock(i);
            }];
            
            [alertController addAction:alertAction];
        } else {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:buttonArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                handleBlock(i);
            }];
            
            [alertController addAction:alertAction];
        }
        
    }
    
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (id)showActionSheet:(NSString *)title
              message:(NSString *)message
          buttonTitle:(NSArray *)buttonTitles
              handler:(void (^)(UIActionSheet *action , NSInteger clickedIndex))handler
{
    return [self showActionSheet:title message:message buttonTitle:buttonTitles style:UIAlertControllerStyleActionSheet handler:handler];
}

- (id)showActionSheet:(NSString *)title
              message:(NSString *)message
          buttonTitle:(NSArray *)buttonTitles
                style:(UIAlertControllerStyle)style
              handler:(void (^)(UIActionSheet *action , NSInteger clickedIndex))handler
{
    if (APPSystemVersion < 8) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:title
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        
        actionSheet.cancelButtonIndex = buttonTitles.count - 1;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

        return actionSheet;
        
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < buttonTitles.count; i++) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:i] style:(i < buttonTitles.count - 1 ? UIAlertActionStyleDefault: UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
                if (handler) {
                    handler(nil , i);
                }
            }];
            [alertController addAction:alertAction];
        }
        [self presentViewController:alertController animated:YES completion:NULL];
        
        return alertController;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{


}

#pragma mark -
#pragma mark PromptView

//  等待提示
- (MBProgressHUD *)showHudWaitingView:(NSString *)prompt
{
    return [[self promptingTopView] showHudWaitingView:prompt];
}

//  文字提示
- (MBProgressHUD *)showHudAuto:(NSString *)text
{
    return [[self promptingTopView] showHudAuto:text];
}

//  手动的提示
- (MBProgressHUD *)showHudManaual:(NSString *)text
{
    return [[self promptingTopView] showHudManaual:text];
}

//  成功失败提示
- (MBProgressHUD *)showHudSuccessView:(NSString *)text
{
    return [[self promptingTopView] showHudSuccessView:text];
}

//  错误提示
- (MBProgressHUD *)showHudErrorView:(NSString *)text
{
    return [[self promptingTopView] showHudErrorView:text];
}

//  消除视图
- (void)removeMBProgressHudInManaual
{
    [[self promptingTopView] removeMBProgressHudInManaual];
}

//  如果键盘出来了，则将等待视图加在键盘的Window上
- (UIView *)promptingTopView
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    UIView *topView = self.view;
    
    if (windows.count > 1 && _isKeyboardAppear) {
        UIWindow *keyboarWindow = [windows objectAtIndex:1];
        topView = keyboarWindow;
    }
    
    return topView;
}

#pragma mark - 获取键盘

- (UIView *)keyboardView
{
    NSArray *windowList = [[UIApplication sharedApplication] windows];
    UIWindow* tempWindow = nil;
    if ([windowList count] > 1) {
        tempWindow = [windowList objectAtIndex:1];
    }
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        //iPhone SDk 4.0 自定义键盘 版本兼容问题
        if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) ||
           (([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)))
        {
            return keyboard;
        }
    }
    
    return nil;
}

#pragma mark - changeStateBarStyle

- (void)changeStateBarStyleLight:(BOOL)light
{
    
    UIStatusBarStyle style = light ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;

    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

#pragma mark - NavigationBarItem

- (UIBarButtonItem *)leftNavigationBarItem
{
    return [self navigationItem:[self leftNavigationImageStr] withSEL:@selector(leftBarItemClicked:)];
}

- (UIBarButtonItem *)rightNavigationBarItem
{
    return [self navigationItem:[self rightNavigationImageStr] withSEL:@selector(rightBarItemClicked:)];
}

- (UIBarButtonItem *)navigationItem:(NSString *)imageName withSEL:(SEL)sel
{
    if (isEmpty(imageName)) {
        return nil;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:HTImageNamed(imageName) forState:UIControlStateNormal];
    button.size = CGSizeMake(25, 25);
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (NSString *)leftNavigationImageStr
{
    return nil;
    return @"vcDismiss";
}

- (NSString *)rightNavigationImageStr
{
    return nil;
}

- (void)leftBarItemClicked:(UIButton *)button
{
    [self dissmissViewController];
}

- (void)rightBarItemClicked:(UIButton *)button
{
    
}

- (void)dissmissViewControllerAnimated:(BOOL)animation complainBlock:(void (^)(void))completion
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (self == window.rootViewController) {
        return;
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        [self viewControllerWillDismiss];
        [self.navigationController popViewControllerAnimated:animation];
        if (completion) {
            completion();
        }
        
        [self viewControllerDidDismiss];
        
    }else {
        [self viewControllerWillDismiss];
        [self dismissViewControllerAnimated:animation completion:^{
    
            
        }];
        [self viewControllerDidDismiss];
    }

}

- (void)dissmissViewController:(void (^)(void))completion
{
    [self dissmissViewControllerAnimated:YES complainBlock:completion];
}

- (void)dissmissViewController
{
    [self dissmissViewController:nil];
}

- (void)viewControllerWillDismiss
{
    
}

- (void)viewControllerDidDismiss
{
    
}


#pragma mark -  屏幕旋转

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - View Will

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@ view will appear", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@ view did appear", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"%@ view will disappear", NSStringFromClass([self class]));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSLog(@"%@ view did disappear", NSStringFromClass([self class]));
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"%@ view will layoutSubviews", NSStringFromClass([self class]));
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSLog(@"%@ view did layoutSubviews", NSStringFromClass([self class]));
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    NSLog(@"%@ view did unload", NSStringFromClass([self class]));
}

- (void)dealloc
{
    [self removeKeyboardNotifaction];
    
    NSLog(@"%@ dealloc~~", NSStringFromClass([self class]));
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MemoryWarning:%@", NSStringFromClass([self class]));
    
    //  清理图片所占内存
#if DEBUG
    [[SDImageCache sharedImageCache] clearMemory];
    
#endif
}

@end

