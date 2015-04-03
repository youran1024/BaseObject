//
//  AppDelegate.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/26.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HTNavigationController.h"
#import "HTTabBarController.h"
#import "HTGuideManager.h"

#import "FirstTableViewController.h"


@interface AppDelegate () <HTGuideManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [self htTabBarController];
    
    
    [self.window makeKeyAndVisible];
    
    //  显示引导页
    [HTGuideManager showGuideViewWithDelegate:self];
    
    return YES;
}

#pragma mark - 
#pragma mark GuideManager Delegate
- (void)guideManagerWantDisappear:(HTGuideManager *)guideManager
{
    [guideManager makeGuideViewDisappear];
    guideManager = nil;
}

- (HTTabBarController *)htTabBarController
{
    HTTabBarController *tabBarController = [[HTTabBarController alloc] init];
    [tabBarController setViewControllers:[self subViewControllers]];
    
    return tabBarController;
}

- (NSArray *)subViewControllers
{
    NSMutableArray *array = [@[] mutableCopy];

    FirstTableViewController *viewController1 = [[FirstTableViewController alloc] init];
    viewController1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
    viewController1.view.backgroundColor = HTRandomColor;
    HTNavigationController *navigationController1 = [[HTNavigationController alloc] initWithRootViewController:viewController1];
    
    [array addObject:navigationController1];
    
    UIViewController *viewController2 = [[UIViewController alloc] init];
    viewController2.tabBarItem  = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    viewController2.view.backgroundColor = HTRandomColor;
    HTNavigationController *navigationController2 = [[HTNavigationController alloc] initWithRootViewController:viewController2];
    
    [array addObject:navigationController2];
    
    UIViewController *viewController3 = [[UIViewController alloc] init];
    viewController3.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
    viewController3.view.backgroundColor = HTRandomColor;
    HTNavigationController *navigationController3 = [[HTNavigationController alloc] initWithRootViewController:viewController3];
    
    [array addObject:navigationController3];
    
    UIViewController *viewController4 = [[UIViewController alloc] init];
    viewController4.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:4];
    viewController4.view.backgroundColor = HTRandomColor;
    HTNavigationController *navigationController4 = [[HTNavigationController alloc] initWithRootViewController:viewController4];
    
    [array addObject:navigationController4];
    
    return array;
}

@end
