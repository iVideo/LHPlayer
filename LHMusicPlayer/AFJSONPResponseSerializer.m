//
//  AFJSONPResponseSerializer.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-2-26.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "AFJSONPResponseSerializer.h"

static NSError * AFErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

static BOOL AFErrorOrUnderlyingErrorHasCode(NSError *error, NSInteger code) {
    if (error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCode(error.userInfo[NSUnderlyingErrorKey], code);
    }
    
    return NO;
}

#pragma mark -

@implementation AFJSONPResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithReadingOptions:0];
}

+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions {
    AFJSONPResponseSerializer *serializer = [[self alloc] init];
    serializer.readingOptions = readingOptions;
    
    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.stringEncoding = NSUTF8StringEncoding;
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", @"text/plain", @"text/html", nil];
    
    return self;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (AFErrorOrUnderlyingErrorHasCode(*error, NSURLErrorCannotDecodeContentData)) {
            return nil;
        }
    }
    
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    id responseObject = nil;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
    if (responseString && ![responseString isEqualToString:@" "]) {
        // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
        // See http://stackoverflow.com/a/12843465/157142
        
        // 解析jsonP，取第一个“（”和最后一个")"之间的部分
        [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSInteger beginPos = [responseString rangeOfString:@"("].location;
        NSInteger endPos = [responseString rangeOfString:@")" options:NSBackwardsSearch].location;
        NSString *realResponseString = nil;
        if (beginPos >= 0 && endPos >=0 && beginPos+1 <= endPos) {
            realResponseString = [responseString substringWithRange:NSMakeRange(beginPos+1, endPos-beginPos-1)];
        }
        if (verifiedString(realResponseString)) {
            data = [realResponseString dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSError *serializationError = nil;
        if (data) {
            if ([data length] > 0) {
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&serializationError];
            } else {
                return nil;
            }
        } else {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Data failed decoding as a UTF-8 string", nil, @"AFNetworking"),
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Could not decode string: %@", nil, @"AFNetworking"), responseString]
                                       };
            
            serializationError = [NSError errorWithDomain:AFNetworkingErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
        }
        
        if (error) {
            *error = AFErrorWithUnderlyingError(serializationError, *error);
        }
    }
    
    return responseObject;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    self.readingOptions = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(readingOptions))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.readingOptions forKey:NSStringFromSelector(@selector(readingOptions))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFJSONPResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.readingOptions = self.readingOptions;
    
    return serializer;
}

@end
