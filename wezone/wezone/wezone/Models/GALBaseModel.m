//
//  GALBaseModel.m
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALBaseModel.h"

@implementation GALBaseModel
{
    NSObject *myTag;
}

- (NSObject *)getTag {
    return myTag;
}
- (void)setTag:(NSObject *)tag {
    myTag = tag;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    static NSSet *systemProperties = nil;
    if (!systemProperties) {
        systemProperties = [NSSet setWithArray:@[@"description"]];
    }
    BOOL isContain = [systemProperties containsObject:key];
    if (isContain) {
        [super setValue:value forKey:[NSString stringWithFormat:@"prop_%@", key]];
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (NSMutableDictionary *) dictionary {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setValue:[self valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return dict;
}

@end
