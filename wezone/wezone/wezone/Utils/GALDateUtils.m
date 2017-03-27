//
//  GALDateUtils.m
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALDateUtils.h"

@implementation GALDateUtils

+ (NSString *)getDateString:(NSDate *)currentDate formatString:(NSString *)formatString {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:formatString];
    
    return [format stringFromDate:currentDate];
}

+ (NSDate *)getStringToDate:(NSString *)dateString formatString:(NSString *)formatString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    
    NSDate *date = [dateFormat dateFromString:dateString];
    
    return date;
}


+ (NSDate *)dateWithSting:(NSString *)datestring{
    static NSDateFormatter *inputDateFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inputDateFormat = [[NSDateFormatter alloc] init];
        [inputDateFormat setDateFormat:@"yyyyMMddHHmm"];
    });
    
    NSDate *date = [inputDateFormat dateFromString:datestring];
    return date;
}

+ (NSDate *)dateWithSting:(NSString *)datestring withDateFormat:(NSString *)dateFormat {
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: dateFormat];
    NSDate *date = [inputFormatter dateFromString:datestring];
    
    return date;
}

+ (NSString *)dateForBoardTypeWithString:(NSString *)datestring {
    
    static NSDateFormatter *outputDateFormat = nil;
    static dispatch_once_t onceToken;
    static NSTimeInterval oneMinute = 60.f;
    static NSTimeInterval oneHour   = 60.f * 60.f;
    static NSTimeInterval oneDay    = 60.f * 60.f * 24.f;
    static NSTimeInterval oneMonth  = 60.f * 60.f * 24.f * 30.f;
    static NSTimeInterval oneYear  = 60.f * 60.f * 24.f * 30.f * 12.f;
    
    dispatch_once(&onceToken, ^{
        outputDateFormat = [[NSDateFormatter alloc] init];
        [outputDateFormat setDateFormat:@"yyyy-MM-dd"];
    });
    
    NSDate *date = [self dateWithSting:datestring];
    NSTimeInterval timeIntervalSec = [[NSDate date] timeIntervalSinceDate:date];
    
    if (timeIntervalSec < oneMinute) {
        return [NSString stringWithFormat:LSSTRING(@"minutes_ago"), (int)floor(timeIntervalSec / oneMinute)];
    }
    else if (timeIntervalSec < oneHour) {
        return [NSString stringWithFormat:LSSTRING(@"minutes_ago"), (int)floor(timeIntervalSec / oneMinute)];
    }
    else if (timeIntervalSec < oneDay) {
        return [NSString stringWithFormat:LSSTRING(@"hours_ago"), (int)floor(timeIntervalSec / oneHour)];
    }
    else if (timeIntervalSec < oneMonth) {
        return [NSString stringWithFormat:LSSTRING(@"days_ago"), (int)floor(timeIntervalSec / oneDay)];
    }else{
        return [NSString stringWithFormat:LSSTRING(@"months_ago"), (int)floor(timeIntervalSec / oneMonth)];
    }
    
//    NSString *newString = [outputDateFormat stringFromDate:date];
//    return newString;
}

#pragma mark - DateFormatting Method
+ (NSArray *)divdeDateFromNSString:(NSString *)dateString
{
    NSString * date = nil;
    NSString * time = nil;
    dateString =[dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc]init];
    
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"ko_KR"];
    [dateFormatter setLocale:locale];
    [timeFormatter setLocale:locale];
    
    [inputFormatter setDateFormat: @"yyyyMMddHHmmssSS"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd EEEE"];
    [timeFormatter setDateFormat: @"a hh:mm"];
    NSDate *inputDate = [inputFormatter dateFromString:dateString];
    
    date = [dateFormatter stringFromDate:inputDate];
    time = [timeFormatter stringFromDate:inputDate];
    
    
    NSArray * resultData = @[date,time];
    return resultData;
    
}

+ (NSString *)divdeTimeFromNSString:(NSString *)dateString
{
    NSString * time = nil;
    dateString =[dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc]init];
    
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"ko_KR"];
    [timeFormatter setLocale:locale];
    
    [inputFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SS"];
    [timeFormatter setDateFormat: @"a hh:mm"];
    NSDate *inputDate = [inputFormatter dateFromString:dateString];
    time = [timeFormatter stringFromDate:inputDate];
    
    return time;
}

+ (NSDate *)changeDateFromString:(NSString *)dateString
{
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: @"yyyyMMddHHmmssSS"];
    NSDate *inputDate = [inputFormatter dateFromString:dateString];
    
    return inputDate;
    
}
+ (NSArray *)divideDateFromNSDate:(NSDate *)inputDate
{
    NSString * date = nil;
    NSString * time = nil;
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc]init];
    
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"ko_KR"];
    [dateFormatter setLocale:locale];
    [timeFormatter setLocale:locale];
    
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd EEEE"];
    [timeFormatter setDateFormat: @"a hh:mm"];
    date = [dateFormatter stringFromDate:inputDate];
    time = [timeFormatter stringFromDate:inputDate];
    
    
    
    NSArray * resultData = @[date,time];
    return resultData;
    
}

+ (NSString *)mergeDateFromStrings:(NSString *)dateString Time:(NSString *)timeString
{
    NSArray* dateToken = [dateString componentsSeparatedByString:@" "];
    //    NSArray* timeToken = [timeString componentsSeparatedByString:@" "];
    
    
    NSString * mergeString = [NSString stringWithFormat:@"%@ %@", [dateToken objectAtIndex:0], timeString];
    NSDateFormatter * inputDateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter * outputDateFormatter = [[NSDateFormatter alloc]init];
    [inputDateFormatter setDateFormat: @"yyyy-MM-dd a hh:mm"];     //hh는 0~12, HH은 0~24..
    [outputDateFormatter setDateFormat: @"yyyyMMddHHmmssSS"];
    
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"ko_KR"];
    [inputDateFormatter setLocale:locale];
    [outputDateFormatter setLocale:locale];
    
    NSDate *inputDate = [inputDateFormatter dateFromString:mergeString];
    //    long long resultLongValue = [[outputDateFormatter stringFromDate:inputDate] longLongValue];
    //
    //
    //    NSArray* timeToken = [timeString componentsSeparatedByString:@" "];
    //    if([timeToken count] != 0){
    //        NSString * ampmString = [timeToken objectAtIndex:0];
    //        if([ampmString isEqualToString:@"오후"]){
    //            resultLongValue += 12000000;
    //        }
    //
    //
    //    }
    //
    //
    //
    //
    //    NSString * resultString = [NSString stringWithFormat:@"%lli", resultLongValue];
    NSString * resultString = [NSString stringWithFormat:@"%@", [outputDateFormatter stringFromDate:inputDate]];
    
    return resultString;
    
    
}

//yyyyssDDHHmmss -> yyyy-MM-dd HH:mm:ss.SSS 로 변환
+ (NSString *)convertingDateFormatter:(NSString *)dateString
{
    NSString * date = nil;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: @"yyyyMMddHHmmss"];
    NSDate *inputDate = [inputFormatter dateFromString:dateString];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"ko_KR"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    date = [dateFormatter stringFromDate:inputDate];
    return date;
}

+ (NSString *)convertingDateWithDateString:(NSString *)dateString withFormatter:(NSString *)formatter
{
    NSString * date = nil;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *inputDate = [inputFormatter dateFromString:dateString];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"ko_KR"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat: formatter];
    date = [dateFormatter stringFromDate:inputDate];
    return date;
}

+ (NSString *)getCurrentTimeZone
{
    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
    localTimeZoneFormatter.dateFormat = @"z";

    NSString *localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
    
    return localTimeZoneOffset;
}

+ (NSString *) getCurrentTimeWithGMTOffset:(NSInteger) gmt withTimeFormat:(NSString *)timeFormat{

    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.dateFormat = timeFormat;
    
    [localTimeZoneFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [localTimeZoneFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:gmt]];
    
    localTimeZoneFormatter.dateFormat = timeFormat;
    
    return [localTimeZoneFormatter stringFromDate:[NSDate date]];
}

+ (NSString *) getCurrentGMT:(NSString *)gmt{
    
    if(gmt == nil || [@"" isEqualToString:gmt]){
        return nil;
    }
    
    NSString *returnStr = nil;
    
    if([gmt length] > 1){
        
        NSArray *strTempArray = [gmt componentsSeparatedByString:@"."];
        
        NSString *strGMT = @"GMT";
        
        if([strTempArray count] > 1){
            
            NSRange range = [[strTempArray objectAtIndex:0]  rangeOfString:@"-" options: NSCaseInsensitiveSearch];
            
            if(range.location != NSNotFound){
                
                NSInteger tempInt = [[strTempArray objectAtIndex:0] integerValue];
                
                if(tempInt == 0){
                   strGMT = [strGMT stringByAppendingString:@"-"];
                }
                
                strGMT = [strGMT stringByAppendingString:[NSString stringWithFormat:@"%d",tempInt]];
                strGMT = [strGMT stringByAppendingString:@":"];
            }else{
            
                NSString *strTime = [strTempArray objectAtIndex:0];
                
                NSRange range = [strTime  rangeOfString:@"+" options: NSCaseInsensitiveSearch];
                
                if(range.location != NSNotFound){
                    strTime = [strTime stringByReplacingOccurrencesOfString:@"+" withString:@""];
                }
                
                strGMT = [strGMT stringByAppendingString:@"+"];
                strGMT = [strGMT stringByAppendingString:[NSString stringWithFormat:@"%@",strTime]];
                strGMT = [strGMT stringByAppendingString:@":"];
            }
            
            NSString *strMin = [strTempArray objectAtIndex:1];
            if(strMin.length == 1){
                strMin = [strMin stringByAppendingString:@"0"];
            }
            
            CGFloat tempFloat = [strMin floatValue];
            tempFloat *= 0.6;
            
            NSInteger tempInt = (NSInteger) tempFloat;
            
            if(tempFloat == 0){
                strGMT = [strGMT stringByAppendingString:@"00"];
            }else{
                strGMT = [NSString stringWithFormat:@"%@%d",strGMT,tempInt];
            }
            
        }else{
            
            NSRange range = [[strTempArray objectAtIndex:0]  rangeOfString:@"-" options: NSCaseInsensitiveSearch];
            if(range.location != NSNotFound){
                
                NSInteger tempInt = [[strTempArray objectAtIndex:0] integerValue];
                strGMT = [NSString stringWithFormat:@"%d",tempInt];
                strGMT = [strGMT stringByAppendingString:@":"];
                strGMT = [strGMT stringByAppendingString:@"00"];
            }else{
                
                NSString *strTime = [strTempArray objectAtIndex:0];
                NSRange range = [strTime  rangeOfString:@"+" options: NSCaseInsensitiveSearch];
                
                if(range.location != NSNotFound){
                    strTime = [strTime stringByReplacingOccurrencesOfString:@"+" withString:@""];
                }
                
                strGMT = [strGMT stringByAppendingString:@"+"];
                strGMT = [strGMT stringByAppendingString:[NSString stringWithFormat:@"%@",strTime]];
                strGMT = [strGMT stringByAppendingString:@":"];
                strGMT = [strGMT stringByAppendingString:@"00"];
            }
          
        }
        
        returnStr = [returnStr stringByAppendingString:strGMT];
    
    }else{
        
        NSInteger gmtInt = [gmt integerValue];
        if(gmtInt == 0){
            returnStr = [NSString stringWithFormat:@"GMT+%d:00",gmtInt];
        }else{
            returnStr = [NSString stringWithFormat:@"GMT+0%d:00",gmtInt];
        }
    }
    
    return returnStr;
}

+ (NSString *) getCurrentTime:(NSString *)format{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [outputFormatter setTimeZone:zone];
    [outputFormatter setDateFormat:format];
    
    return [outputFormatter stringFromDate:[NSDate date]];
}

+ (NSString *) getCalTimeWithGMT:(NSString *)timeFormat withStrDate:(NSString *)strDate withGmt:(NSInteger)gmt{
    
    NSTimeInterval timeInterval = (60.f * 60.0f) * gmt;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: timeFormat];
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    inputDate = [inputDate dateByAddingTimeInterval:timeInterval];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:timeFormat];
    
    return [outputFormatter stringFromDate:inputDate];
}

+ (NSString *) getCalTimeWithGMT:(NSString *)timeFormat withStrDate:(NSString *)strDate{
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: timeFormat];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [outputFormatter setTimeZone:zone];
    [outputFormatter setDateFormat:timeFormat];
    
    return [outputFormatter stringFromDate:inputDate];
}

+ (NSString *) getCalTimeWithLocalToGMT:(NSString *)timeFormat withStrDate:(NSString *)strDate{
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: timeFormat];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [inputFormatter setTimeZone:zone];
    
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [outputFormatter setDateFormat:timeFormat];
    
    return [outputFormatter stringFromDate:inputDate];
}



+ (NSString *) getChageDateType:(NSString *)inputType withOutputType:(NSString *)outputType withStrDate:(NSString *)strDate{
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:inputType];
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:outputType];
    
    return [outputFormatter stringFromDate:inputDate];
    
}

+ (NSString *)dateForMessageType:(NSString *)format WithString:(NSString *)datestring {
    
    static NSDateFormatter *outputDateFormat = nil;
    static dispatch_once_t onceToken;
    static NSTimeInterval oneMinute = 60.f;
    static NSTimeInterval oneHour   = 60.f * 60.f;
    static NSTimeInterval oneDay    = 60.f * 60.f * 24.f;
    static NSTimeInterval oneMonth  = 60.f * 60.f * 24.f * 30.f;
    static NSTimeInterval oneYear  = 60.f * 60.f * 24.f * 30.f * 12.f;
    
    dispatch_once(&onceToken, ^{
        outputDateFormat = [[NSDateFormatter alloc] init];
        [outputDateFormat setDateFormat:format];
    });
    
    NSDate *date = [self dateWithSting:datestring withDateFormat:format];
    NSTimeInterval timeIntervalSec = [[NSDate date] timeIntervalSinceDate:date];
    
    if (timeIntervalSec < oneMinute) {
        
        NSInteger diffMin = (int)floor(timeIntervalSec / oneMinute);
        if(diffMin <=0){
            diffMin = 0;
        }
        return [NSString stringWithFormat:LSSTRING(@"minutes_ago"),diffMin];
    }
    else if (timeIntervalSec < oneHour) {
        return [NSString stringWithFormat:LSSTRING(@"minutes_ago"), (int)floor(timeIntervalSec / oneMinute)];
    }
    else if (timeIntervalSec < oneDay) {
        return [NSString stringWithFormat:LSSTRING(@"hours_ago"), (int)floor(timeIntervalSec / oneHour)];
    }
    else if (timeIntervalSec < oneMonth) {
        return [NSString stringWithFormat:LSSTRING(@"days_ago"), (int)floor(timeIntervalSec / oneDay)];
    }else{
        return [NSString stringWithFormat:LSSTRING(@"months_ago"), (int)floor(timeIntervalSec / oneMonth)];
    }
}

+ (NSInteger) diffOfMinWithType:(NSString *)dateType Begin:(NSString *)begin End:(NSString *)end{
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: dateType];
    
    
    NSDate *beginDate = [inputFormatter dateFromString:begin];
    NSDate *endDate = [inputFormatter dateFromString:end];
    
    return [endDate timeIntervalSinceDate:beginDate] / 60.0f;
}

+ (NSString *) moveMinuteWithType:(NSString *)dataType StringDate:(NSString *) date withMins:(NSInteger) moveMins{
    NSTimeInterval timeInterval = 60.f * moveMins;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: dataType];
    NSDate *inputDate = [inputFormatter dateFromString:date];
    
    inputDate = [inputDate dateByAddingTimeInterval:timeInterval];
    
    return [inputFormatter stringFromDate:inputDate];
}

+ (NSString *) moveMinute:(NSString *) date withMins:(NSInteger) moveMins{

    NSTimeInterval timeInterval = 60.f * moveMins;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: @"HHmm"];
    NSDate *inputDate = [inputFormatter dateFromString:date];
    
    inputDate = [inputDate dateByAddingTimeInterval:timeInterval];
    
    return [inputFormatter stringFromDate:inputDate];
    
}

+ (NSString *) moveDateWithString:(NSString *) strDate withType:(NSString *)format withDays:(NSInteger) days{
    
    NSTimeInterval timeInterval = (60.f * 60.f * 24.f) * days;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: format];
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    inputDate = [inputDate dateByAddingTimeInterval:timeInterval];
    
    return [inputFormatter stringFromDate:inputDate];
}


+ (NSString *) moveDateAllWithString:(NSString *) strDate withType:(NSString *) format withYears:(NSInteger) years withMonth:(NSInteger) months withDays:(NSInteger) days{
    
    NSTimeInterval yearsInterval = (60.f * 60.f * 24.f * 30.f * 12.f) * years;
    NSTimeInterval monthsInterval = (60.f * 60.f * 24.f * 30.f) * months;
    NSTimeInterval dayssInterval = (60.f * 60.f * 24.f) * days;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: format];
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    inputDate = [inputDate dateByAddingTimeInterval:yearsInterval];
    inputDate = [inputDate dateByAddingTimeInterval:monthsInterval];
    inputDate = [inputDate dateByAddingTimeInterval:dayssInterval];
    
    return [inputFormatter stringFromDate:inputDate];
    
}

+ (NSInteger) getDayOfWeekWithOutGMT:(NSString *) type withDate:(NSString *)strDate{
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: type];
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:inputDate];
    return [comps weekday] - 1;
}

+ (NSInteger) getDayOfWeekWithGMT:(NSString *) type withDate:(NSString *)strDate{
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: type];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:inputDate];
    return [comps weekday] - 1;
}

+ (NSInteger) getDayOfWeekWithGMT:(NSString *)type withDate:(NSString *)strDate withGmt:(NSInteger)gmt{
    
    NSTimeInterval timeInterval = (60.f * 60.0f) * gmt;
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: type];
    [inputFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *inputDate = [inputFormatter dateFromString:strDate];
    
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat: type];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *gmtTime = [outputFormatter stringFromDate:inputDate];
    
    NSDate *outputDate = [outputFormatter dateFromString:gmtTime];
    outputDate = [outputDate dateByAddingTimeInterval:timeInterval];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:outputDate];
    return [comps weekday] - 1;
    
}

+ (NSString *) getCalendarDayinWeek:(NSInteger) pos{
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.firstWeekday = (pos + 1); // Sunday = 1, Saturday = 7
    
    NSDate *mondaysDate = nil;
    [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&mondaysDate interval:NULL forDate:today];
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: @"yyyyMMdd"];
    
    return [inputFormatter stringFromDate:mondaysDate];
}

+ (NSString *) getCalendarDayinWeekFromMonday:(NSInteger) pos{

    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.firstWeekday = (pos + 1); // Sunday = 1, Saturday = 7
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    
    NSDate *mondaysDate = nil;
    [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&mondaysDate interval:NULL forDate:today];
    
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat: @"E"];
    
    return [inputFormatter stringFromDate:mondaysDate];
}



@end
