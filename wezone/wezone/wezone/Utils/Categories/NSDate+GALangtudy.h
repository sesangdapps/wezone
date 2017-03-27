//
//  NSDate+SDGori.h
//  Shinhan_Gori
//
//  Created by sumin on 2014. 2. 24..
//  Copyright (c) 2014년 SDS 스마트개발센터. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GALangtudy)

typedef NS_ENUM(NSInteger, SDGoriWeekOfDay) {
    SDGoriSUNDAY=0,
    SDGoriMONDAY=1,
    SDGoriTUESDAY=2,
    SDGoriWEDNESDAY=3,
    SDGoriTHURSDAY=4,
    SDGoriFRIDAY=5,
    SDGoriSATURDAY=6
};

typedef NS_ENUM(NSInteger, AMPM) {
    SDGoriAM=0,
    SDGoriPM=1
};

struct SDGoriScheduleInfo{
    int year;
    int month;
    int day;
    int weekday;
    int ampm;
    int hour;
    int minute;
    int second;
};
typedef struct SDGoriScheduleInfo SDGoriScheduleInfo;

@property (readonly,nonatomic) NSString *month;
@property (readonly,nonatomic) NSString *year;
@property (readonly,nonatomic) NSString *day;
@property (readonly,nonatomic) NSInteger dayOfWeek;
@property (readonly,nonatomic) BOOL isToday;

- (SDGoriScheduleInfo) dateInformationWithTimeZone:(NSTimeZone*)tz;
- (SDGoriScheduleInfo) dateInformation;
+ (NSDate*) dateFromDateInformation:(SDGoriScheduleInfo)info timeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(SDGoriScheduleInfo)info;

- (NSDate*) firstOfMonth;
- (NSDate*) nextMonth;
- (NSDate*) previousMonth;

- (BOOL) isSameDay:(NSDate*)anotherDate;
- (int) differenceInDaysTo:(NSDate *)toDate;
- (int) differenceInMonthsTo:(NSDate *)toDate;

- (int) daysBetweenDate:(NSDate*)d;

@end
