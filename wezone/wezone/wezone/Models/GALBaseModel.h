//
//  GALBaseModel.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#ifndef Langtudy_GALBaseModel_h
#define Langtudy_GALBaseModel_h
#import "ValueInjector.h"

@interface GALBaseModel : NSObject
- (NSObject *)getTag;
- (void)setTag:(NSObject *)tag;
- (NSMutableDictionary *) dictionary;
@end


#endif
