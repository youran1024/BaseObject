//
//  NSString+BaseURL.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-25.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "NSString+BaseURL.h"
#import "NSString+URLEncoding.h"
#import "NSString+BFExtension.h"
#include <sys/sysctl.h>
#import <sys/utsname.h>

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_2G= 3,
    
}NETWORK_TYPE;

@implementation NSString (BaseURL)

//  判断网络环境
+ (int)dataNetworkTypeFromStatusBar {
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }

    int netType = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        netType = NETWORK_TYPE_NONE;
        
    }else{

        int n = [num intValue];
        if (n == 0) {
            netType = NETWORK_TYPE_NONE;
            
        }else if (n == 1){
            netType = NETWORK_TYPE_2G;
            
        }else if (n == 2){
            netType = NETWORK_TYPE_3G;
            
        }else{
            netType = NETWORK_TYPE_WIFI;
        }
    }

    return netType;
}

+ (NSString *)functionName:(NSString *)function paramDic:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    
    NSString *param = @"";
    for (NSString *key in keys){
        
        NSString *value = HTSTR(@"%@", [dic objectForKey:key]);
        param = [param stringByAppendingString:HTSTR(@"%@=%@", key, value)];
        
        NSInteger index = [keys indexOfObject:key];
        if (index != (keys.count -1)) {
            param = [param stringByAppendingString:@"&"];
        }
    }
    
    return HTSTR(@"%@?%@", function, param);
}

//php 后缀参数拼接
+ (NSString *)functionName:(NSString *)function, ...
{
    va_list args;
    va_start(args, function);
    id tmp;
    id values;
    
    while (TRUE) {
        values = va_arg(args, id);
        if (!values) break;
        
        if ([values isKindOfClass:[NSDictionary class]]) {
            NSArray *keys = [values allKeys];
            for (NSString *key in keys) {
                id value = [values valueForKey:key];
                tmp = HTSTR(@"%@/%@/%@",tmp, key, value);
            }
        }else{
            tmp = HTSTR(@"%@/%@", tmp, values);
        }
    }
    
    va_end(args);
    return tmp;
}

//  拼参数的函数
+ (NSString *)appendFunctionName:(NSString *)function, ...
{
    va_list args;
    va_start(args, function);
    id tmp = function;
    id values;
    
    while (TRUE) {
        values = va_arg(args, id);
        if (!values) break;
        
        if ([values isKindOfClass:[NSDictionary class]]) {
            NSArray *keys = [values allKeys];
            for (NSString *key in keys) {
                id value = [values valueForKey:key];
                tmp = HTSTR(@"%@/%@/%@",tmp, key, value);
            }
        }else{
            tmp = HTSTR(@"%@/%@", tmp, values);
        }
    }
    
    va_end(args);
    return tmp;
}

//  平台 ios硬件版本号
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size,NULL, 0);
    NSString*platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

+ (NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


#pragma mark - Host

#define  ___baseHTTPSHost   [self baseHTTPSHost]
- (NSString *)baseHTTPSHost
{
    return HTSTR(@"https://%@", jianDanInvestServer);
}

#define ___baseHTTPHost     [self baseHTTPHost]
- (NSString *)baseHTTPHost
{
    return HTSTR(@"http://%@", jianDanInvestServer);
}


#define ___getUserInfoHost   [self userInfoHost]
- (NSString *)userInfoHost
{
    return HTSTR(@"%@/userinfo", ___baseHTTPHost);
}

#define ___getMessageHost [self getMessageHost]
- (NSString *)getMessageHost
{
    return HTSTR(@"%@/user/sendCaptcha", ___baseHTTPSHost);
}

#define ___getUserHost [self getUserHost]
- (NSString *)getUserHost
{
    return HTSTR(@"%@/user", ___baseHTTPSHost);
}

#define ___getSecurityHost  [self getSecurityHost]
- (NSString *)getSecurityHost
{
    return HTSTR(@"%@/secure", ___baseHTTPSHost);
}

#pragma mark -

#pragma mark - 短信发送

//  发送短信验证码--注册
- (NSString *)getMessageAtRigist
{
    return HTSTR(@"%@/signup", ___getMessageHost);
}

//  发送短信验证码--找回登录密码
- (NSString *)getMessageAtFindPass
{
    return HTSTR(@"%@/back", ___getMessageHost);
}

//  发送短信验证码--绑定手机号
- (NSString *)getMessgeAtBindPhone
{
    return HTSTR(@"%@/bindPhone", ___getMessageHost);
}

//  发送短信验证码--修改支付密码
- (NSString *)getMessageAtModifyPayPass
{
    return HTSTR(@"%@/modifyPayPwd", ___getMessageHost);
}


#pragma mark - 密码

//  修改登陆密码
- (NSString *)revertLoginPass
{
    return HTSTR(@"%@/reset/login?ak=", ___getSecurityHost);
}

//  修改支付密码
- (NSString *)revertPayPass
{
    return HTSTR(@"%@/reset/pay?ak=", ___getSecurityHost);
}

//  找回登录密码
- (NSString *)findBackPass
{
    return HTSTR(@"%@/back", ___getUserHost);
}

#pragma mark - 项目发布倒计时

- (NSString *)projectReleaseDate
{
    return HTSTR(@"%@/projects/countdown", ___baseHTTPHost);
}

#pragma mark - 设置

//  关于我们
- (NSString *)aboutUs
{
    return HTSTR(@"%@/aboutus?us=", ___baseHTTPHost);
}

//  版本号
- (NSString *)version
{
    return HTSTR(@"%@/version/ios", ___baseHTTPHost);
}

//  退出
- (NSString *)loginOut
{
    return HTSTR(@"%@/logout?ak=", ___baseHTTPSHost);
}

//  用户反馈
- (NSString *)userFeedBack
{
    return HTSTR(@"%@/feedback?ak=", ___baseHTTPHost);
}

#pragma mark - 个人中心

//  绑定身份证号
- (NSString *)bindIDCard
{
    return HTSTR(@"%@/bindIdCard?ak=", ___getUserInfoHost);
}

//  绑定手机号
- (NSString *)bindPhone
{
    return HTSTR(@"%@/bindPhone?ak=", ___getUserInfoHost);
}

//  绑定银行卡
- (NSString *)bindBankCard
{
    return HTSTR(@"%@bindBankCard?ak=", ___getUserInfoHost);
}

//  资产管理
- (NSString *)assetManage
{
    return HTSTR(@"%@/assetsOverview?ak=", ___getUserInfoHost);
}

//  交易记录
- (NSString *)tradeRecoderList
{     return HTSTR(@"%@/transactionRecord?page=&ak=", ___getUserInfoHost);
}

//  提现银行卡
- (NSString *)bankCardList
{
    return HTSTR(@"%@/transactionRecord?page=&ak=", ___getUserInfoHost);
}

//  投资记录
- (NSString *)investRecordList
{
    return HTSTR(@"%@/investRecord?ak=", ___getUserInfoHost);
}

//  申请提现
- (NSString *)applyCash
{
    return HTSTR(@"%@/applyCash?ak=", ___getUserInfoHost);
}

#pragma mark -

//  提现
- (NSString *)withDraw
{
    return HTSTR(@"%@/withdraw?ak=", ___getSecurityHost);
}

//  消息
- (NSString *)message
{
    return HTSTR(@"%@/messages?ak=", ___baseHTTPHost);
}

#pragma mark - 投资

//  最新账户数据
- (NSString *)investAccountInfo
{
    return HTSTR(@"%@/invest/base?type=&id=&ak=", ___baseHTTPHost);
}

//  投资
- (NSString *)invest
{
    return HTSTR(@"%@/invest?ak=", ___baseHTTPHost);
}

#pragma mark - 充值
//  充值历史列表
- (NSString *)rechargeMoney
{
    return HTSTR(@"%@/secure/query_mercust_bank_shortcut?ak=", ___baseHTTPHost);
}

//  下单接口
- (NSString *)payInterface
{
    return HTSTR(@"%@/secure/query_mercust_bank_shortcut?ak=", ___baseHTTPHost);
}

//  协议支付--调用U付下发验证码
- (NSString *)upaySmsMessage
{
    return HTSTR(@"%@/secure/req_smsverify_shortcut?ak=", ___baseHTTPHost);
}

//  协议支付--确认支付
- (NSString *)confirmPay
{
    return HTSTR(@"%@/secure/agreement_pay_confirm_shortcut?ak=",___baseHTTPHost);
}

//  联动支付--解除绑定关系
- (NSString *)termateBankCard
{
    return HTSTR(@"%@/secure/unbind_mercust_protocol_shortcut?ak=", ___baseHTTPHost);
}

//  实名认证



@end
