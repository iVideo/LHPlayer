//
//  NTESMTencentManager.h
//  Magazine
//
//  Created by 范 岩峰 on 13-9-27.
//  Copyright (c) 2013年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QQ_APPKEY @"801420559"
#define QQ_SECRET @"8af1dfebcff7f349b6b00018984af8c6"
#define TencentCallBackURL @"http://itunes.apple.com/cn/app/wang-yi-nu-ren-shi-shang-za-zhi/id401827947?mt=8"

#define TencentOauthRequestTokenUrl @"https://open.t.qq.com/cgi-bin/oauth2/authorize"
#define TencentOauthAccessTokenUrl  @"https://api.weibo.com/oauth2/access_token"
#define TencentOauthUpdate @"http://open.t.qq.com/api/t/add"
#define TencentOauthUpload @"http://open.t.qq.com/api/t/add_pic"

@protocol TencentManagerDelegate;

@interface NTESMTencentManager : NSObject{
    id <TencentManagerDelegate> teccentDelegate;
    AFHTTPRequestOperation *twitterRequest;
    AFHTTPRequestOperation * infoRequest;
}

@property (nonatomic, assign) id <TencentManagerDelegate> tencentDelegate;
+ (NTESMTencentManager *)shareInstance;

-(NSString*)requestTencentAuthorizeUrl;

- (void)cancelRequest;
- (void)storageAccessToken:(NSString*)token;
- (void)removeAccessToken;
- (BOOL)authorize;
- (BOOL)oauthExpired;
- (void)sendTwitter:(NSString*)content image:(UIImage*)img;
- (BOOL)isTencenWeiboBinded;
@end

@protocol TencentManagerDelegate<NSObject>;
@optional
- (void)finishInfoRequestWithScreenName:(NSString*)name;
- (void)finishSendTwitterWithSuccessStatus:(BOOL)success info:(NSString*)aInfo;
@end

