//
//  NSDictionary+Extened.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-5.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "NSDictionary+Extened.h"

@implementation NSDictionary (Extened)

- (CGFloat)floatForKey:(NSString *)key
{
    NSNumber *floatNumber = [self objectForKey:key];
    if (verifiedNSNumber(floatNumber)) {
        return floatNumber.floatValue;
    }
    else
    {
        return 0.0;
    }
    
}

- (NSString *)stringForKey:(NSString *)key
{
    return verifiedString([self objectForKey:key])?[self objectForKey:key]:@"";
}


- (NSString*)stringForKeyCaseInsensitive:(NSString *)key{
    NSString *ret = verifiedString([self objectForKey:key])?[self objectForKey:key]:@"";
    if (verifiedString(ret)) {
        return ret;
    }else{
        ret = verifiedString([self objectForKey:[key lowercaseString]]) ? [self objectForKey:[key lowercaseString]] : @"";
        return ret;
    }
}

- (double)doubleForKey:(NSString *)key{
    return verifiedNSNumber([self objectForKey:key]) ? [[self objectForKey:key] doubleValue] : 0.0;
}

- (id)objectForKeyCaseInsensitive:(id)aKey{
    id ret = [self objectForKey:aKey];
    if (ret) {
        return ret;
    }else{
        return [self objectForKey:[aKey lowercaseString]];
    }
}

- (double)doubleForKeyCaseInsensitive:(NSString *)key{
    NSNumber *ret = verifiedNSNumber([self objectForKey:key]) ? [self objectForKey:key] : nil;
    if (!verifiedNSNumber(ret)) {
        ret = verifiedNSNumber([self objectForKey:[key lowercaseString]]) ? [self objectForKey:[key lowercaseString]] : nil;
    }
    
    return ret ? [ret doubleValue] : 0.0;
}

- (NSInteger)integerForKey:(NSString *)key
{
    NSNumber *number = [self objectForKey:key];
    if (!verifiedNSNumber(number)) {
        NSString *numString = [self objectForKey:key];
        return verifiedString(numString) ? [numString integerValue] : 0;
    }else{
        return verifiedNSNumber(number)? number.integerValue : 0;
    }
}


- (NSArray *)arrayForKey:(NSString *)key
{
    return verifiedNSArray([self objectForKey:key])?[self objectForKey:key]:[NSArray array];
}

@end
