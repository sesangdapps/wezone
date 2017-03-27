//
//  NSLocale+GALISO3166_1_3.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 11. 9..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "NSLocale+GALISO3166_1_3.h"

@implementation NSLocale (GALISO3166_1_3)


+ (NSDictionary *)ISO3166_1_3Dictionary
{
    static dispatch_once_t onceToken;
    static NSDictionary *sISO3166_1_3Dictionary = nil;
    
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"iso639_2" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        NSString *plistPath = [bundle pathForResource:@"iso3166_1_2_to_iso3166_1_3" ofType:@"plist"];
        
        sISO3166_1_3Dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    });
    
    return sISO3166_1_3Dictionary;
}

- (NSString *)ISO3166_1_3CountryCode
{
    NSString *ISO3166_1_2CountryCode = [self objectForKey:NSLocaleCountryCode];
    NSString *ISO3166_1_3CountryCode = [[[self class] ISO3166_1_3Dictionary] objectForKey:ISO3166_1_2CountryCode];
    
    if (!ISO3166_1_3CountryCode) return ISO3166_1_2CountryCode;
    
    return ISO3166_1_3CountryCode;
}

- (NSString *) displayNameWithISO3166_1_2:(NSString *)code{
    
    NSString *ISO3166_1_2CountryCode;
    
    NSDictionary *dic = [[self class] ISO3166_1_3Dictionary];
    NSArray *allkey = [dic allKeys];
    
    for(NSInteger i=0; i<allkey.count; i++){
        NSString *value = [dic objectForKey:[allkey objectAtIndex:i]];
        
        if([value isEqualToString:code]){
            ISO3166_1_2CountryCode = [allkey objectAtIndex:i];
        }
    }
    
    if(ISO3166_1_2CountryCode==nil){
        return @"";
    }else{
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: ISO3166_1_2CountryCode}];
        return [self displayNameForKey:NSLocaleIdentifier value:identifier];
    }
}

- (NSString *)localCountryCodeWithISO3166_1_2:(NSString *)code{
    
    NSString *ISO3166_1_2CountryCode;
    
    NSDictionary *dic = [[self class] ISO3166_1_3Dictionary];
    NSArray *allkey = [dic allKeys];
    
    for(NSInteger i=0; i<allkey.count; i++){
        NSString *value = [dic objectForKey:[allkey objectAtIndex:i]];
        
        if([value isEqualToString:code]){
            ISO3166_1_2CountryCode = value;
        }
    }
    
    return ISO3166_1_2CountryCode;
}

@end
