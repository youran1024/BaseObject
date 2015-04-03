//
//  HTWebViewController.m
//  HTWebView
//
//  Created by Mr.Yang on 13-8-2.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "HTWebViewController.h"


@protocol HTWebViewDelegate <NSObject>

- (void)webView:(HTWebView *)webView didReceiveDataPresent:(CGFloat)persent;

@end

@interface UIWebView ()
// apple private API
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;

@end

@interface HTWebProgressView : UIView

@property (nonatomic, assign)   CGFloat progressValue;
@property (nonatomic, strong)   UIColor *tintColor;

@end

@implementation HTWebProgressView

- (id)init
{
    self = [super init];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (void)initVariables
{
    _tintColor = [UIColor greenColor];
    self.backgroundColor = HTHexColor(0x0066aa);
    self.progressValue = 0.0f;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    CGRect rect = self.frame;
    static CGFloat width;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        width = rect.size.width;
    });

    if (progressValue > _progressValue) {
        _progressValue = progressValue;
        rect.size.width = width * _progressValue;
        self.frame = rect;
    }
}

@end

@implementation HTWebView
{
    NSInteger totalCount;
    NSInteger receiveCount;
}

- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    
    return @(totalCount++);
}

- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    
    receiveCount++;
    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(webView:didReceiveDataPresent:)]) {
        [_progressDelegate webView:self didReceiveDataPresent:receiveCount/totalCount ];
    }

    if (receiveCount == totalCount) {
        receiveCount = 0;
        totalCount = 0;
    }
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    
    receiveCount++;
    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(webView:didReceiveDataPresent:)]) {
        [_progressDelegate webView:self didReceiveDataPresent:(CGFloat)receiveCount/(CGFloat)totalCount ];
    }
    
    if (receiveCount == totalCount) {
        receiveCount = 0;
        totalCount = 0;
    }
}

@end


@interface HTWebViewController () <HTWebViewDelegate, UIWebViewDelegate>
{

}

@end

@implementation HTWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_url) {
        [self loadListRequest];
    }
}

- (void)setUrl:(NSURL *)url
{
    if (![_url.absoluteString isEqualToString:url.absoluteString]) {
        _url = url;
        [self refresh:url];
    }
}

- (void)loadListRequest
{
    [self refresh:_url];
}

- (void)refresh:(NSURL *)url
{
    _progressView.hidden = NO;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSMutableURLRequest *urlRequest = [request mutableCopy];
    urlRequest.allHTTPHeaderFields = [self addRequestHeader:urlRequest.allHTTPHeaderFields];
    
    if (!_webView) {
        _webView = [[HTWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor flashColorWithRed:0xf5 green:0xf5 blue:0xf5 alpha:1];;
        _webView.progressDelegate = self;
        [self.view addSubview:_webView];
    }
    
    if (!_progressView) {
        _progressView = [[HTWebProgressView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 3)];
        [self.view addSubview:_progressView];
    }
    
    [_webView loadRequest:request];
}

- (NSDictionary *)addRequestHeader:(NSDictionary *)headerDic
{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:headerDic];
    
    
    return mutDic;
}

- (void)webView:(HTWebView *)webView didReceiveDataPresent:(CGFloat)persent
{
    _progressView.progressValue = persent;
    if (persent == 1.0f) {
        _progressView.hidden = YES;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _progressView.hidden = NO;
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (NSString *)mimeType:(NSURL *)url
{
    //1NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2NSURLConnection
    
    //3 在NSURLResponse里，服务器告诉浏览器用什么方式打开文件。
    
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

#pragma mark -
- (NSString *)title
{
    /*
    if (self.VCTitle) {
        return self.VCTitle;
    }
     */
    if(self.titleStr && self.titleStr.length > 0){
        return self.titleStr;
    }
    
    return @"";
}



@end
