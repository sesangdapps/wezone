//
//  NSLocale+GALISO3166_1_3.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 11. 9..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (GALISO3166_1_3)

- (NSString *)ISO3166_1_3CountryCode;

- (NSString *) displayNameWithISO3166_1_2:(NSString *)code;
- (NSString *)localCountryCodeWithISO3166_1_2:(NSString *)code;

@end
