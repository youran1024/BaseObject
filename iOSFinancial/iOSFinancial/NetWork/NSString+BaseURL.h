//
//  NSString+BaseURL.h
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-25.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerHostConfig.h"

/*
*  NOTE:接口文档地址
*  URL:https://github.com/jiandanlicai/earth/blob/master/dev_docs/app_api_v1.0.1.md
*/

#warning 可以修改，在每个请求的Header里边放上 版本信息

@interface NSString (BaseURL)

//  发送短信验证码--注册
- (NSString *)getMessageAtRigist;

//  发送短信验证码--找回登录密码
- (NSString *)getMessageAtFindPass;

//  发送短信验证码--绑定手机号
- (NSString *)getMessgeAtBindPhone;

//  发送短信验证码--修改支付密码
- (NSString *)getMessageAtModifyPayPass;

//
//  重置密码
//

//  修改登陆密码
- (NSString *)revertLoginPass;

//  修改支付密码
- (NSString *)revertPayPass;

//  找回登录密码
- (NSString *)findBackPass;

//
//  发布项目
//

//  发布项目倒计时
- (NSString *)projectReleaseDate;

#warning Header里边加上版本号信息
//  版本号
- (NSString *)version;

//  关于我们
- (NSString *)aboutUs;

//  退出
- (NSString *)loginOut;

//  用户反馈
- (NSString *)userFeedBack;

/**
 *  个人中心
 */

//  绑定身份证号
- (NSString *)bindIDCard;

//  绑定手机号
- (NSString *)bindPhone;

//  绑定银行卡
- (NSString *)bindBankCard;

//  资产管理
- (NSString *)assetManage;

//  交易记录
- (NSString *)tradeRecoderList;

//  提现银行卡
- (NSString *)bankCardList;

//  投资记录
- (NSString *)investRecordList;

//  申请提现
- (NSString *)applyCash;


//  提现
- (NSString *)withDraw;

//  消息
- (NSString *)message;

//  最新账户数据
- (NSString *)investAccountInfo;

//  投资
- (NSString *)invest;

//  充值历史列表
- (NSString *)rechargeMoney;

//  下单接口
- (NSString *)payInterface;

//  协议支付--调用U付下发验证码
- (NSString *)upaySmsMessage;

//  协议支付--确认支付
- (NSString *)confirmPay;

//  联动支付--解除绑定关系
- (NSString *)termateBankCard;



@end
