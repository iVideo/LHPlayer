//
//  NTESMAlert.h
//  iMoney
//
//  Created by 郭亚娟 on 14-3-6.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYJAlert;
typedef void (^NTESMAlertBlock) (GYJAlert *alert, NSInteger buttonIndex);

@interface GYJAlert : UIView
- (instancetype)initAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                     completeBlock:(NTESMAlertBlock)block
                        otherTitle:(NSString *)otherTitle, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;
@end
