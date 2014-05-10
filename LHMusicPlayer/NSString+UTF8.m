//
//  NSString+UTF8.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-10.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "NSString+UTF8.h"

@implementation NSString (UTF8)
- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
	return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}

@end
