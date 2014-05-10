//
//  NTESIMRenrenCommon.h
//  iMoney
//
//  Created by Gavin Zeng on 14-4-8.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning @"更改appID"
#define kRenRenAPP_ID     @"155487"
#define kRenRenAPI_Key    @"55a995fa16e14599ab5774c463d317ea"

#define kRenRenAccessToken @"renren_access_Token"
#define kRenrenExpirationDate @"renren_expiration_Date"
#define kRenrenSessionKey @"renren_session_Key"
#define kRenrenSecretKey @"renren_secret_Key"

//授权及api相关
#define kRenRenAuthBaseURL            @"http://graph.renren.com/oauth/authorize"
#define kRenRenDialogBaseURL          @"http://widget.renren.com/dialog/"
#define kRenRenRestserverBaseURL      @"http://api.renren.com/restserver.do"
#define kRenRenSessionKeyURL        @"http://graph.renren.com/renren_api/session_key"
#define kRenRenSuccessURL           @"http://widget.renren.com/callback.html"
#define kRenRenSDKversion             @"3.0"
#define kRenRenPasswordFlowBaseURL    @"https://graph.renren.com/oauth/token"
#define kWidgetDialogURL @"//widget.renren.com/dialog"
#define kWidgetDialogUA @"18da8a1a68e2ee89805959b6c8441864"

#define kUserAgent  @"Renren iOS SDK v3.0"
#define kStringBoundary  @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3"