//
//  UIColor+HexColor.m
//  iMoney
//
//  Created by 郭亚娟 on 14-2-25.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [[self class] colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
#if 1
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    NSScanner *hexScanner = [NSScanner scannerWithString:hexString];
    
    // Tell scanner to skip the # character
    [hexScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    unsigned int hexValue = 0;
    
    [hexScanner scanHexInt:&hexValue];
    int r = (hexValue >> 16) & 0xFF;
    int g = (hexValue >> 8) & 0xFF;
    int b = (hexValue) & 0xFF;
    
    // Create color object, specifying alpha
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha];
#endif
#if 0
    // Check for hash and add the missing hash
    if('#' != [hexString characterAtIndex:0])
    {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    
    // check for string length
    NSAssert(7 == hexString.length || 4 == hexString.length, @"clor lengh error");
    // check for 3 character HexStrings
    hexString = [[self class] hexStringTransformFromThreeCharacters:hexString];
    
    NSString *redHex    = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(1, 2)]];
    unsigned redInt = [[self class] hexValueToUnsigned:redHex];
    
    NSString *greenHex  = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(3, 2)]];
    unsigned greenInt = [[self class] hexValueToUnsigned:greenHex];
    
    NSString *blueHex   = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(5, 2)]];
    unsigned blueInt = [[self class] hexValueToUnsigned:blueHex];
    
    UIColor *color = [UIColor colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
    
    return color;
#endif
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [[self class] colorWith8BitRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    UIColor *color = [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
    
    return color;
}

+ (NSString *)hexStringTransformFromThreeCharacters:(NSString *)hexString
{
    if(hexString.length == 4)
    {
        hexString = [NSString stringWithFormat:@"#%@%@%@%@%@%@",
                     [hexString substringWithRange:NSMakeRange(1, 1)],[hexString substringWithRange:NSMakeRange(1, 1)],
                     [hexString substringWithRange:NSMakeRange(2, 1)],[hexString substringWithRange:NSMakeRange(2, 1)],
                     [hexString substringWithRange:NSMakeRange(3, 1)],[hexString substringWithRange:NSMakeRange(3, 1)]];
    }
    
    return hexString;
}

+ (unsigned)hexValueToUnsigned:(NSString *)hexValue
{
    unsigned value = 0;
    
    NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
    [hexValueScanner scanHexInt:&value];
    
    return value;
}

@end
