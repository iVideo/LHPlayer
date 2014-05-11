//
//  GYJIMAFJSONRequestOperation.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-25.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYJAFJSONRequestOperation : AFHTTPRequestOperation{
}
-(id)initWithRequestUrl:(NSString*)urlStr postBodyString:(NSString*)postString;
@end
