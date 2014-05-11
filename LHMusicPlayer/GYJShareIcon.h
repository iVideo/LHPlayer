//
//  GYJIMShareIcon.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-14.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//
//  第三方平台绑定按钮
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYJShareIconType) {
    GYJShareIconTypeSina,
    GYJShareIconTypeTencentWeibo,
    GYJShareIconTypeYiXin,
    GYJShareIconTypeRenRen,
    GYJShareIconTypeWeChat,
    GYJShareIconTypeWeChatMoments
};

typedef void(^GYJShareIconBlock)(void);

@interface GYJShareIcon : UIButton

/*
 binded: 该平台是否已绑定过，未绑定则为灰色
 */
@property (nonatomic, assign) BOOL binded;
- (id)initWithFrame:(CGRect)frame type:(GYJShareIconType)type binded:(BOOL)binded block:(GYJShareIconBlock)actionBlock;
@end
