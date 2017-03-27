//
//  GALDateUtils.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#ifndef Langtudy_GALDateUtils_h
#define Langtudy_GALDateUtils_h

@interface GALDateUtils : NSObject

+ (NSString *)getDateString:(NSDate *)currentDate formatString:(NSString *)formatString;
+ (NSDate *)getStringToDate:(NSString *)dateString formatString:(NSString *)formatString;

+ (NSDate *)dateWithSting:(NSString *)datestring;
+ (NSDate *)dateWithSting:(NSString *)datestring withDateFormat:(NSString *)dateFormat;
+ (NSString *)dateForBoardTypeWithString:(NSString *)datestring;
+ (NSArray *)divdeDateFromNSString:(NSString *)dateString;
+ (NSDate *)changeDateFromString:(NSString *)dateString;
+ (NSArray *)divideDateFromNSDate:(NSDate *)inputDate;
+ (NSString *)divdeTimeFromNSString:(NSString *)dateString;
+ (NSString *)mergeDateFromStrings:(NSString *)dateString Time:(NSString *)timeString;
+ (NSString *)convertingDateFormatter:(NSString *)dateString;
+ (NSString *)convertingDateWithDateString:(NSString *)dateString withFormatter:(NSString *)formatter;

+ (NSString *)getCurrentTimeZone;
+ (NSString *) getCurrentTimeWithGMTOffset:(NSInteger) gmt withTimeFormat:(NSString *)timeFormat;
+ (NSString *) getCurrentGMT:(NSString *)gmt;
+ (NSString *) getCurrentTime:(NSString *)format;
+ (NSInteger) diffOfMinWithType:(NSString *)dateType Begin:(NSString *)begin End:(NSString *)end;
+ (NSString *) getCalTimeWithGMT:(NSString *)timeFormat withStrDate:(NSString *)strDate withGmt:(NSInteger)gmt;
+ (NSString *)getCalTimeWithGMT:(NSString *)timeFormat withStrDate:(NSString *)strDate;
+ (NSString *) getCalTimeWithLocalToGMT:(NSString *)timeFormat withStrDate:(NSString *)strDate;
+ (NSString *) getChageDateType:(NSString *)inputType withOutputType:(NSString *)outputType withStrDate:(NSString *)strDate;
+ (NSString *)dateForMessageType:(NSString *)format WithString:(NSString *)datestring;

+ (NSString *) moveMinuteWithType:(NSString *)dataType StringDate:(NSString *) date withMins:(NSInteger) moveMins;
+ (NSString *) moveMinute:(NSString *) date withMins:(NSInteger) moveMins;
+ (NSString *) moveDateWithString:(NSString *) strDate withType:(NSString *)format withDays:(NSInteger) days;
+ (NSString *) moveDateAllWithString:(NSString *) strDate withType:(NSString *) format withYears:(NSInteger) years withMonth:(NSInteger) months withDays:(NSInteger) days;


+ (NSInteger) getDayOfWeekWithOutGMT:(NSString *) type withDate:(NSString *)strDate;
+ (NSInteger) getDayOfWeekWithGMT:(NSString *) type withDate:(NSString *)strDate;
+ (NSInteger) getDayOfWeekWithGMT:(NSString *)type withDate:(NSString *)strDate withGmt:(NSInteger)gmt;

+ (NSString *) getCalendarDayinWeek:(NSInteger) pos;
+ (NSString *) getCalendarDayinWeekFromMonday:(NSInteger) pos;

@end

#endif
