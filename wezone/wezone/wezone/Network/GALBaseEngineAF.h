//
//  GALBaseEngineAF.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import "AFNetworking.h"
#import "AESExtention.h"
#import "AFNetworkActivityIndicatorManager.h"

#ifndef Langtudy_GALBaseEngineAF_h
#define Langtudy_GALBaseEngineAF_h

@interface GALRequestOperation : AFHTTPRequestOperation
@property (nonatomic, assign) BOOL isDisableActivityIndicator;
@end

@interface GALBaseEngineAF : AFHTTPRequestOperationManager

@property (nonatomic, strong) NSCache *cacheUrlMapping;

typedef void (^GALResultBlock)(NSDictionary *data);
typedef void (^GALResultArrayBlock)(NSArray *data);
typedef void (^GALResultImageBlock)(UIImage *fetchedImage, NSURL *url, BOOL isInCache);
typedef void (^GALResultFileBlock)(NSData *fileData, NSURL *url);
typedef void (^GALErrorBlock)(NSDictionary *data, NSError* error);

- (id) initWithHostName:(NSString*) hostName;

- (GALRequestOperation *)requestOperationWithPath:(NSString*)path isPost:(BOOL)isPost headers:(NSDictionary*)headers params:(NSDictionary*)parmas
                                   resultHandler:(GALResultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)requestOperationWithPath:(NSString*)path method:(NSString *)method headers:(NSDictionary*)headers params:(NSDictionary*)parmas resultHandler:(GALResultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)requestOperationWithPath:(NSString*)path multiPart:(NSDictionary *)multiPartDatas headers:(NSDictionary*)headers params:(NSDictionary*)parmas
                                   resultHandler:(GALResultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)requestImageOperationWithURL:(NSURL *)url headers:(NSDictionary*)headers completionHandler:(GALResultImageBlock)resultImageHandler errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)requestFileOperationWithURL:(NSURL *)url headers:(NSDictionary*)headers completionHandler:(GALResultFileBlock)resultFileHandler errorHandler:(GALErrorBlock)errorBlock;

- (NSMutableArray *) makeTypedArray:(NSArray *)array withClass:(__unsafe_unretained Class)cls;

- (void)clearCacheDataWithDays:(int)days;
- (NSData *)getCacheDataForKey:(NSString *)key;
- (BOOL)existCacheDataForKey:(NSString *)key;
- (void)setCacheData:(NSData *)data key:(NSString *)key;
- (void)setCacheData:(NSData *)data key:(NSString *)key resultBlock:(void (^)())resultBlock;

@end

#endif
