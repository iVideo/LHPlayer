//
//  NTESIMAFJSONRequestOperation.h
//  iMoney
//
//  Created by TorrLau on 14-3-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYJAFJSONRequestOperation : AFHTTPRequestOperation{
}
-(id)initWithRequestUrl:(NSString*)urlStr postBodyString:(NSString*)postString;
@end
