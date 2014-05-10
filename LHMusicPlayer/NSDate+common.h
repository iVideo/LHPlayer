//
//  NSDate+common.h
//  PluginLib
//
//  Created by 范 岩峰 on 13-12-23.
//  Copyright (c) 2013年 NetEase.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(NSInteger)numDaysInMonth;
-(NSInteger)firstWeekDayInMonth;
-(NSInteger)year;
-(NSInteger)month;
-(NSInteger)day;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

- (NSDate *)dateByAddingMonths:(NSInteger)dMonths;
- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isWeekAgo:(NSInteger)it;

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
@end
