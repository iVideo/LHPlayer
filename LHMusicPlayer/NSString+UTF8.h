//
//  NSString+UTF8.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-10.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTF8)
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
@end
