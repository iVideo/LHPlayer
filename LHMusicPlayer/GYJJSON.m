//
//  NTESNBJSON.m
//  NewsBoard
//
//  Created by Peter Liu on 11/12/12.
//  Copyright (c) 2012 NetEase.com, Inc. All rights reserved.
//

#import "GYJJSON.h"

#pragma mark - Deserializing methods

@implementation NSData (JSONDeserializing)

- (id)objectFromJSONData{
    NSError *error = nil;
    return [self objectFromJSONDataWithParseOptions:NSJSONReadingAllowFragments error:&error];
}

- (id)objectFromJSONDataWithParseOptions:(NSJSONReadingOptions)opt error:(NSError **)error{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self options:opt error:error];
    if (jsonObject != nil && *error == nil) {
        return jsonObject;
    }
#ifndef APPSTORE
    NSLog(@"JSON From Data Error : %@",[*error description]);
#endif
    return nil;
}

@end

@implementation NSString (JSONDeserializing)

- (id)objectFromJSONString{
    NSError *error = nil;
    return [self objectFromJSONStringWithParseOptions:NSJSONReadingAllowFragments error:&error];
}

- (id)objectFromJSONStringWithParseOptions:(NSJSONReadingOptions)opt error:(NSError **)error{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data objectFromJSONDataWithParseOptions:opt error:error];
}

@end

#pragma mark - Serializing methods

@implementation NSObject (JSONSerializing)

- (NSString *)JSONString{
    NSData *jsonData = [self JSONData];
    if (jsonData != nil && [jsonData length] > 0) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (verifiedString(jsonString)) {
            return jsonString;
        }
    }
    return nil;
}

- (NSData *)JSONData{
    NSError *error = nil;
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (jsonData != nil && error == nil) {
            return jsonData;
        }
    }
    return nil;
}

@end