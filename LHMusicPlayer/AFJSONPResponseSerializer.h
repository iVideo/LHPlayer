//
//  AFJSONPResponseSerializer.h
//  iMoney
//
//  Created by Abby Lin on 14-2-26.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLResponseSerialization.h"

#pragma mark -


/**
 `AFJSONPResponseSerializer` is a subclass of `AFHTTPResponseSerializer` that validates and decodes JSON responses.
 
 By default, `AFJSONPResponseSerializer` accepts the following MIME types, which includes the official standard, `application/json`, as well as other commonly-used types:
 
 - `application/json`
 - `text/json`
 - `text/javascript`
 */
@interface AFJSONPResponseSerializer : AFHTTPResponseSerializer

/**
 Options for reading the response JSON data and creating the Foundation objects. For possible values, see the `NSJSONSerialization` documentation section "NSJSONReadingOptions". `0` by default.
 */
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

/**
 Creates and returns a JSON serializer with specified reading and writing options.
 
 @param readingOptions The specified JSON reading options.
 */
+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end
