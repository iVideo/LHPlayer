//
//  NSDictionary+Extened.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-5.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extened)

- (CGFloat)floatForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (double)doubleForKey:(NSString*)key;

- (NSString *)stringForKeyCaseInsensitive:(NSString *)key;   // 传入的key是大写英文字符串，如果查不到结果，转换成小写查找
- (double)doubleForKeyCaseInsensitive:(NSString *)key;
- (id)objectForKeyCaseInsensitive:(id)aKey;
- (NSInteger)integerForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
@end
