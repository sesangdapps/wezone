//
//  GALBaseEngineAF.m
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALBaseEngineAF.h"
//#import "UIImageView+AFNetworking.h"
#import "AESExtention.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GALRequestOperation
@end

@interface GALBaseEngineAF ()
@property (strong, nonatomic) dispatch_queue_t myBackgroundCacheQueue;
@end

@implementation GALBaseEngineAF

- (id) initWithHostName:(NSString*) hostName{
    NSMutableString *urlString = [NSMutableString stringWithString:hostName];
    
    if(self = [super initWithBaseURL:[NSURL URLWithString:urlString]]) {
        
        self.cacheUrlMapping = [[NSCache alloc] init];
        
        self.myBackgroundCacheQueue = dispatch_queue_create("com.galuster.cachequeue", DISPATCH_QUEUE_SERIAL);
        
        self.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
        //self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // statusbar network indicator
        AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
        
        // custom indicator
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidStart:) name:AFNetworkingOperationDidStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingOperationDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (GALRequestOperation *)requestOperationWithPath:(NSString*)path isPost:(BOOL)isPost headers:(NSDictionary*)headers params:(NSDictionary*)parmas
                                   resultHandler:(GALResultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableURLRequest *request;
    if (isPost) {
        
        //NSLog(@"\n\nPOST %@\n\%@\n\n",[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString], parmas);
        request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                                 parameters:parmas error:nil];
    }
    else {
        
        NSString *urlWithRestful = [NSString new];
        
        NSArray *keyArray = parmas.allKeys;
        for(NSInteger i=0; i<keyArray.count; i++){
            
            NSString *key = [keyArray objectAtIndex:i];
            NSString *value = [parmas objectForKey:key];
            
            if(value != nil && ![value isKindOfClass:[NSNull class]]){
                urlWithRestful = [urlWithRestful stringByAppendingString:[NSString stringWithFormat:@"%@/%@/",key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
            }
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString],urlWithRestful];
        //NSLog(@"\n\nGET %@\n\n", urlString);
        
        request = [self.requestSerializer requestWithMethod:@"GET" URLString:urlString
                                                 parameters:nil error:nil];
    }
    
    // 헤더 추가
    if (headers) {
        for (NSString *key in headers) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    GALRequestOperation *operation = [[GALRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer; // JSON
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    [operation.securityPolicy setAllowInvalidCertificates:YES];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock)
            errorBlock(operation.responseObject, error);
    }];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (GALRequestOperation *)requestOperationWithPath:(NSString*)path method:(NSString *)method headers:(NSDictionary*)headers params:(NSDictionary*)parmas resultHandler:(GALResultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableURLRequest *request;
    if ([method isEqualToString:@"GET"] ) {
        
        NSString *urlWithRestful = [NSString new];
        
        NSArray *keyArray = parmas.allKeys;
        for(NSInteger i=0; i<keyArray.count; i++){
            
            NSString *key = [keyArray objectAtIndex:i];
            NSString *value = [parmas objectForKey:key];
            
            if(value != nil && ![value isKindOfClass:[NSNull class]]){
                urlWithRestful = [urlWithRestful stringByAppendingString:[NSString stringWithFormat:@"%@/%@/",key,value]];
            }
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString],urlWithRestful];
        //NSLog(@"\n\n%@ %@\n\n", method, urlString);
        
        request = [self.requestSerializer requestWithMethod:method URLString:urlString
                                                 parameters:nil error:nil];

        
    } else if ( [method isEqualToString:@"DELETE"] ) {
        
        NSString *urlWithRestful = [NSString new];
        
        NSArray *keyArray = parmas.allKeys;
        for(NSInteger i=0; i<keyArray.count; i++){
            
            NSString *key = [keyArray objectAtIndex:i];
            NSString *value = [parmas objectForKey:key];
            
            if(value != nil && ![value isKindOfClass:[NSNull class]]){
                urlWithRestful = [urlWithRestful stringByAppendingString:[NSString stringWithFormat:@"%@/",value]];
            }
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString],urlWithRestful];
        //NSLog(@"\n\n%@ %@\n\n", method, urlString);
        
        request = [self.requestSerializer requestWithMethod:method URLString:urlString
                                                 parameters:nil error:nil];
        
        
    } else {
        
        //NSLog(@"\n\%@ %@\n\%@\n\n",method, [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString], parmas);
        
        request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                                 parameters:parmas error:nil];
    }
    
    // 헤더 추가
    if (headers) {
        for (NSString *key in headers) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    GALRequestOperation *operation = [[GALRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer; // JSON
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    [operation.securityPolicy setAllowInvalidCertificates:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock)
            errorBlock(operation.responseObject, error);
    }];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}


- (GALRequestOperation *)requestOperationWithPath:(NSString*)path multiPart:(NSDictionary *)multiPartDatas headers:(NSDictionary*)headers params:(NSDictionary*)parmas
                                   resultHandler:(GALResultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    NSError *error = nil;
    NSString *url = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    AFHTTPRequestSerializer *serializer = self.requestSerializer;
    //    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (multiPartDatas) {
            for (NSString *key in multiPartDatas.keyEnumerator) {
                if (multiPartDatas[key]) {
                    GALMultiPartData *multipartData = multiPartDatas[key];
                    [formData appendPartWithFileData:multipartData.data name:key fileName:multipartData.fileName mimeType:multipartData.mimeType];
                }
            }
            
        }
    } error:&error];
    
    if (error) {
        if (errorBlock)
            errorBlock(nil, error);
        return nil;
    }
    
    // 헤더 추가
    if (headers) {
        for (NSString *key in headers) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    GALRequestOperation *operation = [[GALRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer; // JSON
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock)
            errorBlock(nil, error);
    }];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (GALRequestOperation *)requestImageOperationWithURL:(NSURL *)url headers:(NSDictionary*)headers completionHandler:(GALResultImageBlock)resultImageHandler errorHandler:(GALErrorBlock)errorBlock {
    
    // 캐쉬 불러오기
    NSData *cachedImageData = [self getCacheDataForKey:url.absoluteString];
    if (cachedImageData) {
        UIImage *image = [UIImage imageWithData:cachedImageData];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            resultImageHandler(image, url, YES);
        //        });
        resultImageHandler(image, url, YES);
    }
    else {
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[url absoluteString] parameters:nil error:nil];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        // 헤더 추가
        if (headers) {
            for (NSString *key in headers) {
                [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        GALRequestOperation *operation = [[GALRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];  // IMAGE
        operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
        operation.credential = self.credential;
        operation.securityPolicy = self.securityPolicy;
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(!responseObject){
                NSError *error = nil;
                error = [[NSError alloc] initWithDomain:@"Empty ImageData"  code:0 userInfo:nil];
                
                if (errorBlock)
                    errorBlock(nil, error);
                return;
                
            }
            // 캐쉬 저장하기
            NSString *cacheKey = operation.request.URL.absoluteString;
            NSString *urlPath = [operation.request.URL path];
            NSString *query = [operation.request.URL query];
            
            //            if ([urlPath hasSuffix:@"downloadUserImageByUserCn"]) {
            //                if (operation.response.allHeaderFields && [operation.response.allHeaderFields objectForKey:@"fileName"]) {
            //                    NSRange aRange = [cacheKey rangeOfString:urlPath];
            //                    if (aRange.location != NSNotFound) {
            //                        NSRange aRangeUserCn = [query rangeOfString:@"userCn"];
            //                        NSRange aRangeFileNm = [query rangeOfString:@"fileName"];
            //                        if (aRangeUserCn.location != NSNotFound && aRangeFileNm.location == NSNotFound) {
            //
            //                            // downloadUserImageByUserCn이고 fileName이 헤더에 있으며 userCn만 있고 fileName는 없는경우 (채팅방에서 xmpp 메세지로 userImageUrl 없이 userCn만 가지고 사진을 요청한 경우 헤더의 fileName으로 캐시에 저장함, 그리고 그 캐시를 사용하도록 url 매핑 cacheUrls 사용)
            //
            //                            cacheKey = [NSString stringWithFormat:@"%@%@?fileName=%@&%@",
            //                                        [cacheKey substringToIndex:aRange.location],
            //                                        urlPath,
            //                                        [operation.response.allHeaderFields objectForKey:@"fileName"],
            //                                        query];
            //
            //                            @synchronized(self.cacheUrlMapping) {
            //                                if ([self.cacheUrlMapping objectForKey:operation.request.URL.absoluteString] == nil) {
            //                                    [self.cacheUrlMapping setObject:cacheKey forKey:operation.request.URL.absoluteString];
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            
            if (![self existCacheDataForKey:cacheKey]) {
                [self setCacheData:UIImagePNGRepresentation(responseObject) key:cacheKey];
            }
            
            resultImageHandler(responseObject, operation.request.URL, NO);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorBlock)
                errorBlock(nil, error);
        }];
        
        [operation setQueuePriority:NSOperationQueuePriorityLow];
        operation.isDisableActivityIndicator = YES;
        [self.operationQueue addOperation:operation];
        
        return operation;
    }
    return nil;
}

- (GALRequestOperation *)requestFileOperationWithURL:(NSURL *)url headers:(NSDictionary*)headers completionHandler:(GALResultFileBlock)resultFileHandler errorHandler:(GALErrorBlock)errorBlock {
    
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[url absoluteString] parameters:nil error:nil];
    [request addValue:@"file/*" forHTTPHeaderField:@"Accept"];
    
    // 헤더 추가
    if (headers) {
        for (NSString *key in headers) {
            [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    GALRequestOperation *operation = [[GALRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPRequestSerializer serializer];
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(!responseObject){
            NSError *error = nil;
            error = [[NSError alloc] initWithDomain:@"Empty FileData"  code:0 userInfo:nil];
            
            if (errorBlock)
                errorBlock(nil, error);
            return;
            
        }
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        resultFileHandler(data, operation.request.URL);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock)
            errorBlock(nil, error);
    }];
    
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    operation.isDisableActivityIndicator = YES;
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (NSMutableArray *)makeTypedArray:(NSArray *)array withClass:(__unsafe_unretained Class)cls {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (id item in array) {
        id model = [cls new];
        [model injectFromObject:item arrayClass:nil];
        [result addObject:model];
    }
    return result;
}

#pragma mark - AFNetworkingOperationDidStartNotification

- (BOOL)isEnableActivityIndicator:(AFURLConnectionOperation *)connectionOperation {
    return ([connectionOperation isKindOfClass:[GALRequestOperation class]] && !(((GALRequestOperation *)connectionOperation).isDisableActivityIndicator));
}

- (void)networkingOperationDidStart:(NSNotification *)notification {
    AFURLConnectionOperation *op = [notification object];
#ifdef DEBUG
    NSString *path = op.request.URL.absoluteString;
    NSString *jsonString = [[NSString alloc] initWithData:op.request.HTTPBody encoding:NSUTF8StringEncoding];
    
    NSLog(@"\n\nrequest[%i] : %i bytes\n\"%@\"\n%@\n\n", op.hash, op.request.HTTPBody.length, path, jsonString);
    //NSLog(@"request[%i] : %i bytes\n\"%@\"\nheaders %@\nparams %@", op.hash, op.request.HTTPBody.length, path, op.request.allHTTPHeaderFields, jsonString);
#endif
    if ([self isEnableActivityIndicator:op]) {
        [GALangtudyUtils showActivityIndicator]; // Start Activity
    }
}

- (void)networkingOperationDidFinish:(NSNotification *)notification {
    AFURLConnectionOperation *op = [notification object];
#ifdef DEBUG
    NSString *path = op.request.URL.absoluteString;
    NSString *jsonString = op.responseString ? op.responseString : op.responseData ? [NSString stringWithFormat:@"%i bytes", op.responseData.length] : nil;
    
    NSError *jsonError;
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization  JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    if ( jsonError ) {
        NSLog(@"\n\nresponse[%i] : %i bytes\n\"%@\"\n%@\n\n", op.hash, op.responseData.length, path, jsonString);
    } else {
        NSLog(@"\n\nresponse[%i] : %i bytes\n\"%@\"\n%@\n\n", op.hash, op.responseData.length, path, json);
    }
#endif
    if ([self isEnableActivityIndicator:op]) {
        [GALangtudyUtils hideActivityIndicator]; // End Activity
    }
}

#pragma mark - cache

- (NSString *)cacheDirectory {
    static NSString *cacheDirectoryName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"SDCache"];
        
        // 폴더 없으면 생성
        NSString *cacheDirectory = cacheDirectoryName;
        BOOL isDirectory = YES;
        BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] && isDirectory;
        
        if (!folderExists)
        {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        }
    });
    return cacheDirectoryName;
}

- (NSString *)string2md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSData *)getCacheDataForKey:(NSString *)key {
    AESExtention *aes = [AESExtention sharedAESExtention];
    NSString* hashKey = [aes getHashKeyWith:key];
    NSString *cacheKey = [self string2md5:hashKey];
    //    NSString *cacheKey = [self string2md5:key];
    
    NSString *filePath = [[self cacheDirectory] stringByAppendingPathComponent:cacheKey];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        
        // 복호화
        NSData *decData = [aes aes128DecryptWithData:data];
        //NSLog(@"파일복호화: %i > %i", data.length, decData.length);
        
        // NSURLContentAccessDateKey 속성이 반영되기 위해..
        [[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate]
                                         ofItemAtPath:filePath error:nil];
        
        return decData;
    }
    return nil;
}

- (BOOL)existCacheDataForKey:(NSString *)key {
    AESExtention *aes = [AESExtention sharedAESExtention];
    NSString* hashKey = [aes getHashKeyWith:key];
    NSString *cacheKey = [self string2md5:hashKey];
    //    NSString *cacheKey = [self string2md5:key];
    
    NSString *filePath = [[self cacheDirectory] stringByAppendingPathComponent:cacheKey];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (void)clearCacheDataWithDays:(int)days {
    NSArray *filesInUserInfoCacheDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:[self cacheDirectory]]
                                                                           includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLContentAccessDateKey, nil]
                                                                                              options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    for (NSURL *url in filesInUserInfoCacheDirectory) {
        NSDate *accessDate = [[url resourceValuesForKeys:[NSArray arrayWithObject:NSURLContentAccessDateKey] error:nil] objectForKey:NSURLContentAccessDateKey];
        
        NSDate *theDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*days];
        NSComparisonResult dateComp = [theDate compare:accessDate];
        
        if (dateComp == NSOrderedDescending) {
            NSLog(@"%@ 파일 삭제", accessDate);
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        }
    }
}

- (void)setCacheData:(NSData *)data key:(NSString *)key {
    [self setCacheData:data key:key resultBlock:nil];
}

- (void)setCacheData:(NSData *)data key:(NSString *)key resultBlock:(void (^)())resultBlock {
    dispatch_async(self.myBackgroundCacheQueue, ^{
        AESExtention *aes = [AESExtention sharedAESExtention];
        NSString* hashKey = [aes getHashKeyWith:key];
        NSString *cacheKey = [self string2md5:hashKey];
        //    NSString *cacheKey = [self string2md5:key];
        
        NSString *filePath = [[self cacheDirectory] stringByAppendingPathComponent:cacheKey];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            NSLog(@"%@", [error description]);
        }
        
        // 암호화
        NSData *encData = [aes aes128EncryptWithData:data];
        NSLog(@"파일암호화: %i > %i", data.length, encData.length);
        
        NSError *error;
        BOOL success = [encData writeToFile:filePath options:0 error:&error];
        if (!success) {
            NSLog(@"writeToFile failed with error %@", error);
        }
        else {
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock();
                });
            }
        }
    });
}

@end
