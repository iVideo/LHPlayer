//
//  LHCommon.h
//  LHAD
//
//  Created by 郭亚娟 on 14-4-29.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) do { } while (0)
#endif

#define DOC_PATH_CACHE [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

/*单例*/
#undef	DECLARE_SINGLETON
#define DECLARE_SINGLETON( __class ) \
+ (__class *)sharedInstance __attribute__((const));

#undef	IMPLEMENT_SINGLETON
#define IMPLEMENT_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

/*屏幕尺寸信息*/
#define IS_IP_5 (IS_IPHONE && IS_IPHONE5)
#define IS_IP_4_AND_BELOW (IS_IPHONE && !IS_IPHONE5)
#define SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define STATUS_BAR_H 20
#define NAVIGATION_BAR_H 44
#define MAIN_TABBAR_HEIGHT  50

//====== 辅助工具 =====
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define isiPhone5 CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136))

// color
#define IM_NAVI_BLUE [UIColor colorWithHexString:@"C48FBD"]//RGBCOLOR(0, 24, 64)
#define IM_DARK_BLUE RGBCOLOR(13, 23, 41)
#define IM_LIGHT_BLUE RGBCOLOR(198, 212, 234)
#define IM_240_GRAY RGBCOLOR(240, 240, 240)


#define API_163_USER_INFO @"http://c.3g.163.com/nc/uc/profile/%@.html"//从新闻接口中获取通行证信息
#define API_HOST @"http://i.money.163.com/app/api"
#define API_163_USER_LOGIN @"https://reg.163.com/logins.jsp?product=newsclient"//用户从新闻接口中登录
#define API_USER_PUSH_SWITCH @"/user/setPush.json"//设置推送开关
#define API_USER_GET_BASE_INFO @"/user/basic/get.json"//获取用户基本信息
#define API_USER_SET_BASE_INFO @"/user/basic/update.json"//设置用户基本信息
#define API_USER_LOGIN_NOTI @"/user/loginNotify.json"//登陆通知
#define API_163_USER_IMAGEUPLOAD_URL @"http://m.163.com/api/comments/uploadImg"
#define API_163_POST_HEAD_URL @"http://c.3g.163.com/uc/api/visitor/head"


#define EncryptKey @"neteasenewsboard" //加密秘钥

#define RecorderPath @"recorderPath"
//通知
// 用户信息更改
#define NTESIMUserInfoChangedNotification  @"com.netease.im.user_InfoChanged"
// 用户登录成功
#define NTESIMUserLoginSuccessNotification  @"com.netease.im.user_LoginSuccess"
// 用户登录失败
#define NTESIMUserLoginFailedNotification  @"com.netease.im.user_LoginError"
// 用户登出
#define NTESIMUserLogoutNotification  @"com.netease.im.user_Louout"

//====== TENCENT ======
#define LOGIN_USERNAME_TENCENT_KEY @"LOGIN_USERNAME_TENCENT_KEY_OAUTH2"
#define LOGIN_DATA_TENCENT_KEY @"LOGIN_DATA_TENCENT_KEY"
#define LOGIN_EXPIRESIN_TENCENT_KEY @"LOGIN_EXPIRESIN_TENCENT_KEY"
#define LOGIN_OPENID_TENCENT_KEY @"LOGIN_OPENID_TENCENT_KEY"

/*新浪分享平台信息*/
#define SINA_APPKEY @"1278254028"
#define SINA_SECRET @"9b76648254533b008accd6b58dcddba8"
#define LOGIN_USERNAME_SINA_KEY @"LOGIN_USERNAME_SINA_KEY_OAUTH2"
#define LOGIN_DATA_SINA_KEY @"LOGIN_DATA_SINA_KEY"

// 账号绑定成功
#define NOTIFICATION_SINA_LOGIN @"NOTIFICATION_SINA_LOGIN"
#define NOTIFICATION_TENCENT_LOGIN @"NOTIFICATION_TENCENT_LOGIN"
#define NOTIFICATION_RENREN_LOGIN @"NOTIFICATION_RENREN_LOGIN"
// 绑定界面设置更改
#define NTESIMPlatformSettingChangeNotification @"com.netease.im.user_platform_setting_change"

//====== COOKIE =====
#define KEY_LOGINED_COOKIE_PROPERTIES @"KEY_LOGINED_COOKIE_PROPERTIES"
#define KEY_KEYCHAIN_SERVICE_MAILBOX @"KEY_KEYCHAIN_SERVICE_MAILBOX"

#define US [NSUserDefaults standardUserDefaults]
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define KEY_USER_LOCAL_INFO @"UserLocalInfo"
#define KEY_USER_LOGIN_INFO @"UserLoginInfo"
#define LOGIN_USERNAME_KEY @"LOGIN_USERNAME_KEY" //登录时直接保存的输入的USERNAME，并非真正主帐号
#define REGISTER_USERNAME_KEY @"REGISTER_USERNAME_KEY"

//UTF-8
#define UTF8String(str) [[NSString stringWithFormat:@"%@",str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]


//nsstring
static inline BOOL verifiedString(id strlike) {
    if (strlike && ![strlike isEqual:[NSNull null]] && [[strlike class] isSubclassOfClass:[NSString class]] && ((NSString*)strlike).length > 0) {
        return YES;
    }else{
        return NO;
    }
}

//nsnumber
static inline BOOL verifiedNSNumber(id numlike) {
    if (numlike && ![numlike isEqual:[NSNull null]] && [[numlike class] isSubclassOfClass:[NSNumber class]]) {
        return YES;
    }else{
        return NO;
    }
}

//nsarray
static inline BOOL verifiedNSArray(id arraylike) {
    if (arraylike && ![arraylike isEqual:[NSNull null]] && [[arraylike class] isSubclassOfClass:[NSArray class]] && [arraylike count] > 0) {
        return YES;
    }else{
        return NO;
    }
}

//nsdictionary
static inline BOOL verifiedNSDictionary(id dictlike) {
    if (dictlike && ![dictlike isEqual:[NSNull null]] && [[dictlike class] isSubclassOfClass:[NSDictionary class]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -
#pragma mark - version related
static inline NSString* releaseVersion(void){
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
}

static inline NSString* developmentVersion(){
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

@interface GYJCommon : NSObject
+ (NSDateFormatter *)sharedDateFormatter;
+ (NSURL *)recorderPath;
+ (NSDictionary *)calssPropertyForClass:(Class)className;
@end
