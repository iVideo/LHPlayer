//
//  NSString+UTF8.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-10.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTF8)
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
@end
