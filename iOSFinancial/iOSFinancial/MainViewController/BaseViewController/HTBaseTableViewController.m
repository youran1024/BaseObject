//
//  HTBaseTableViewController.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseTableViewController.h"
#import "LoadMoreCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URLEncoding.h"

@interface HTBaseTableViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign)   UITableViewStyle tableViewStyle;

@end

@implementation HTBaseTableViewController

- (void)dealloc
{
    if (_refreshHeaderView) {
        [_refreshHeaderView free];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView free];
    }
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    
    return self;
}

- (id)initWithTableViewStyle:(UITableViewStyle)tableViewStyle
{
    self = [super init];
    
    if (self) {
        _tableViewStyle = tableViewStyle;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //deselect Row
    NSIndexPath *index = [_tableView indexPathForSelectedRow];
    [_tableView deselectRowAtIndexPath:index animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewCellSeparatorInsets
//- (void)viewDidLayoutSubviews
//{
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (void)setShowRefreshHeaderView:(BOOL)showRefreshHeaderView
{
    if (_showRefreshHeaderView != showRefreshHeaderView) {
        _showRefreshHeaderView = showRefreshHeaderView;
        if (_showRefreshHeaderView) {
            [self initRefreshView];
        }else {
            [self removeRefreshHeaderView];
        }
    }
}

- (void)setShowRefreshFooterView:(BOOL)showRefreshFooterView
{
    if (_showRefreshFooterView != showRefreshFooterView) {
        _showRefreshFooterView = showRefreshFooterView;
        if (_showRefreshFooterView) {
            [self initFooterView];
        }else {
            [self removeRefreshFooterView];
        }
    }
}

- (void)initRefreshView
{
    [self.refreshHeaderView setScrollView:self.tableView];
    
    __weak HTBaseTableViewController *weakSelf = self;
    [_refreshHeaderView setBeginRefreshingBlock:^(MJRefreshBaseView *refreshView){
        [weakSelf refreshViewBeginRefresh:refreshView];
    }];
    
    [_refreshHeaderView setEndStateChangeBlock:^(MJRefreshBaseView *refreshView){
        [weakSelf refreshViewStateChanged:refreshView];
    }];
}


#pragma mark - endRefresh
- (void)endRefresh
{
    if (_refreshFooterView && _refreshFooterView.isRefreshing) {
        [_refreshFooterView endRefreshing];
    }
    
    if (_refreshHeaderView && _refreshHeaderView.isRefreshing) {
        [_refreshHeaderView endRefreshing];
    }
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    
}

- (void)refreshViewStateChanged:(MJRefreshBaseView *)baseView
{
    
}

- (void)initFooterView
{
    [self.refreshFooterView setScrollView:self.tableView];

    __weak typeof(self) weakSelf = self;
    [_refreshFooterView setBeginRefreshingBlock:^(MJRefreshBaseView *refreshView){
        [weakSelf.refreshFooterView performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
    }];
    
    [_refreshFooterView setEndStateChangeBlock:^(MJRefreshBaseView *refreshView){
        
    }];
}

- (void)removeRefreshFooterView
{
    [_refreshFooterView removeFromSuperview];
    _refreshFooterView = nil;
}

- (void)removeRefreshHeaderView
{
    [_refreshHeaderView removeFromSuperview];
    _refreshHeaderView = nil;
}

- (MJRefreshHeaderView *)refreshHeaderView
{
    if (!_refreshHeaderView) {
        _refreshHeaderView = [MJRefreshHeaderView header];
        [_refreshHeaderView refreshUpdateTimeLabel];
    }
    
    return _refreshHeaderView;
}

- (MJRefreshFooterView *)refreshFooterView
{
    if (!_refreshFooterView) {
        _refreshFooterView = [MJRefreshFooterView footer];
    }
    
    return _refreshFooterView;
}

#pragma mark tableView

- (UITableView *)tableView
{
    return [self tableViewWithStyle:_tableViewStyle];
}

- (UITableView *)tableViewWithStyle:(UITableViewStyle)tableViewStyle
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.frame;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        //  去掉空白多余的行
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _tableView;
}

#pragma mark - TableViewController Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
