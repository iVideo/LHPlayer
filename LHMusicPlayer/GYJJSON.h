//
//  GYJNBJSON.h
//
//  Created by 郭亚娟 on 11/12/12.
//  Copyright (c) 2012 郭亚娟.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Deserializing methods

@interface NSData (JSONDeserializing)
- (id)objectFromJSONData;
- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)opt error:(NSError **)error;
@end

@interface NSString (JSONDeserializing)
- (id)objectFromJSONString;
- (id)objectFromJSONStringWithParseOptions:(NSJSONReadingOptions)opt error:(NSError **)error;
@end

#pragma mark - Serializing methods

@interface NSObject (JSONSerializing)

- (NSString *)JSONString;
- (NSData *)JSONData;

@end

