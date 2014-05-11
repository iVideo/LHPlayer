//
//  GYJIMAFJSONRequestOperation.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-25.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJAFJSONRequestOperation.h"

@implementation GYJAFJSONRequestOperation

-(id)initWithRequestUrl:(NSString*)urlStr postBodyString:(NSString*)postString{

    if (nil == urlStr || nil == postString) {
        return nil;
    }
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBodyData = [NSMutableData dataWithData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *contentLength = [NSString stringWithFormat:@"%d",[postBodyData length]];
    [theRequest setValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postBodyData];
    
    self = [super initWithRequest:theRequest];
    if (self) {
        // Custom initialization
        [super setResponseSerializer:[AFJSONResponseSerializer new]];
    }
    return self;
}


@end
