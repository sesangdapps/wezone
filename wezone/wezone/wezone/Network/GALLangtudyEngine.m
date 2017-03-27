//
//  GALangtudyEngine.m
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALLangtudyEngine.h"
#import "NSData+Base64.h"

@implementation GALMultiPartData

- (id)initWithFileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    if(self = [super init]) {
        _data = fileData;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end

@interface GALLangtudyEngine ()

- (GALRequestOperation *)operationWithPath:(NSString*)path
                                    method:(NSString*)method
                                    params:(NSDictionary*)body
                             resultHandler:(GALResultBlock)resultBlock
                              errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)operationByGetWithPath:(NSString*)path
                                          params:(NSDictionary*)body
                                   resultHandler:(GALResultBlock)resultBlock
                                    errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)operationByPostWithPath:(NSString*)path
                                         params:(NSDictionary*)body
                                  resultHandler:(GALResultBlock)resultBlock
                                   errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)operationListByPostWithPath:(NSString*)path
                                             params:(NSDictionary*)body
                                      resultHandler:(GALResultArrayBlock)resultBlock
                                       errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)operationByMultiPartPostWithPath:(NSString*)path
                                                  params:(NSDictionary*)body
                                               multiPart:(NSDictionary*)multiPartDatas
                                           resultHandler:(GALResultBlock)resultBlock
                                            errorHandler:(GALErrorBlock)errorBlock;

@end

@implementation GALLangtudyEngine

static NSString * const kEngineHostName           = SERVICE_HOST_NAME;
static NSString * const kEngineSuccessResultNo    = SERVICE_SUCCESS_RESULT_NO;

+ (instancetype)sharedEngine {
    static id _sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GALBaseEngineAF *base = [[super alloc] initWithHostName:kEngineHostName];
        _sharedEngine = base;
    });
    return _sharedEngine;
}

+ (BOOL)convertFlag:(NSString *)flag {
    if (flag && [flag isEqualToString:@"Y"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)convertBool:(BOOL)b {
    return b ? @"Y" : @"N";
}

- (void)errorCheckWithResult:(NSDictionary *)jsonObject errorHandler:(GALErrorBlock)errorBlock {
    NSString *resultNo = jsonObject[@"result_no"];
    NSObject *errorDesc = jsonObject[@"error_desc"];
    
    // {"data":"null","result_no":"0002","error_desc":"해당 세션이 없습니다. 재 로그인 하십시오"}
    // {"data":"null","result_no":"1003","error_desc":"로그인 정보 오류입니다."}
    if ([resultNo isEqualToString:@"0002"] || [resultNo isEqualToString:@"1003"]) {
//        [self errorProcessForSystemCode];
        return;
    }
    
    // {"data":"null","result_no":"1008","error_desc":"다른 기기에서 로그인 하였습니다."}
    // {"data":"null","result_no":"1010","error_desc":"내부 정보보안 정책변경으로 10분동안 미 사용시 자동 로그아웃됩니다."}
    else if ([resultNo isEqualToString:@"1008"] || [resultNo isEqualToString:@"1010"]) {
//        [GALGoriUtils showAlert:SDAlertTypeOk message:[errorDesc description] close:^(SDAlertButton buttonType) {
//            [self errorProcessForSystemCode];
//        }];
        return;
    }
    else if ([resultNo isEqualToString:@"8002"]) {
//        [SDGoriUtils showAlert:SDAlertTypeOk message:[errorDesc description] title:@"이용불가 안내" close:^(SDAlertButton buttonType) {
//            [self errorProcessForSystemCode];
//        }];
        return;
    }
    
    
    //    NSString *desc = errorDesc == [NSNull null] ? resultNo : [errorDesc description];
    NSString *desc = errorDesc == [NSNull null] ? [jsonObject[@"data"] description] : [errorDesc description];
    if (errorBlock) {
        errorBlock(resultNo, [NSError errorWithDomain:desc code:ERROR_CODE userInfo:jsonObject]);
    }
}
//
//- (void)errorProcessForSystemCode {
//    if (IS_NO_LOGIN) {
//        [ApplicationDelegate logout];
//    }
//    else {
//        // 로그아웃 처리
//        if ([ApplicationDelegate isLogin]) {
//            // 로그아웃 화면으로 이동
//            [ApplicationDelegate logout];
//        }
//    }
//}
//
//- (NSDictionary *)commonHeaders {
//    if ([self isNoLoginUser]) {
//        NSString *token = [self getNoLoginUserToken];
//        return @{@"token": token};
//    }
//    return nil;
//}

- (GALRequestOperation *)operationByGetWithPath:(NSString*)path
                                          params:(NSDictionary*)body
                                   resultHandler:(GALResultBlock)resultBlock
                                    errorHandler:(GALErrorBlock)errorBlock {
    
    return [self requestOperationWithPath:path isPost:NO headers:nil params:body resultHandler:^(NSDictionary *jsonObject) {
        
        resultBlock(jsonObject);
        //        NSString *resultNo = jsonObject[@"result_no"];
        //
        //
        //        if ([resultNo isEqualToString:kEngineSuccessResultNo]) {
        //            NSDictionary *data = jsonObject[@"data"];
        //            resultBlock(data);
        //        }
        //        else {
        //            [self errorCheckWithResult:jsonObject errorHandler:errorBlock];
        //        }
    } errorHandler:^(NSDictionary *data, NSError* error) {
        NSLog(@"네트워크 연결 %i회 실패", retryCount);
        if ([error code] == -1009) {
            if (retryCount < RETRY_COUNT) {
                retryCount++;
                [self operationByPostWithPath:path params:body resultHandler:resultBlock errorHandler:errorBlock];
            } else {
                retryCount = 0;
                if (errorBlock) {
                    errorBlock(data, error);
                }
            }
        }else {
            retryCount = 0;
            if (errorBlock) {
                errorBlock(data, error);
            }
        }
        
        
    }];
}

- (GALRequestOperation *)operationWithPath:(NSString*)path
                                    method:(NSString*)method
                                    params:(NSDictionary*)body
                             resultHandler:(GALResultBlock)resultBlock
                              errorHandler:(GALErrorBlock)errorBlock {
    
    return [self requestOperationWithPath:path method:method headers:nil params:body resultHandler:^(NSDictionary *jsonObject) {
        
        resultBlock(jsonObject);
        //        NSString *resultNo = jsonObject[@"result_no"];
        //
        //
        //        if ([resultNo isEqualToString:kEngineSuccessResultNo]) {
        //            NSDictionary *data = jsonObject[@"data"];
        //            resultBlock(data);
        //        }
        //        else {
        //            [self errorCheckWithResult:jsonObject errorHandler:errorBlock];
        //        }
    } errorHandler:^(NSDictionary *data, NSError* error) {
        NSLog(@"네트워크 연결 %i회 실패", retryCount);
        if ([error code] == -1009) {
            if (retryCount < RETRY_COUNT) {
                retryCount++;
                [self operationByPostWithPath:path params:body resultHandler:resultBlock errorHandler:errorBlock];
            } else {
                retryCount = 0;
                if (errorBlock) {
                    errorBlock(data, error);
                }
            }
        }else {
            retryCount = 0;
            if (errorBlock) {
                errorBlock(data, error);
            }
        }
        
        
    }];
}


// 일반전문(data:NSDictionary)
- (GALRequestOperation *)operationByPostWithPath:(NSString*)path
                                         params:(NSDictionary*)body
                                  resultHandler:(GALResultBlock)resultBlock
                                   errorHandler:(GALErrorBlock)errorBlock {
    
    return [self requestOperationWithPath:path isPost:YES headers:nil params:body resultHandler:^(NSDictionary *jsonObject) {
        
        resultBlock(jsonObject);
//        NSString *resultNo = jsonObject[@"result_no"];
//        
//        
//        if ([resultNo isEqualToString:kEngineSuccessResultNo]) {
//            NSDictionary *data = jsonObject[@"data"];
//            resultBlock(data);
//        }
//        else {
//            [self errorCheckWithResult:jsonObject errorHandler:errorBlock];
//        }
    } errorHandler:^(NSDictionary *data, NSError* error) {
        NSLog(@"네트워크 연결 %i회 실패", retryCount);
        
        if ([error code] == -1009) {
            if (retryCount < RETRY_COUNT) {
                retryCount++;
                [self operationByPostWithPath:path params:body resultHandler:resultBlock errorHandler:errorBlock];
            } else {
                retryCount = 0;
                if (errorBlock) {
                    errorBlock(data, error);
                }
            }
        }else {
            retryCount = 0;
            if (errorBlock) {
                errorBlock(data, error);
            }
        }
        
        
    }];
}

// 일반전문(data:NSArray)
- (GALRequestOperation *)operationListByPostWithPath:(NSString*)path
                                             params:(NSDictionary*)body
                                      resultHandler:(GALResultArrayBlock)resultBlock
                                       errorHandler:(GALErrorBlock)errorBlock {
    return [self requestOperationWithPath:path isPost:YES headers:nil params:body resultHandler:^(NSDictionary *jsonObject) {
        NSString *resultNo = jsonObject[@"result_no"];
        if ([resultNo isEqualToString:kEngineSuccessResultNo]) {
            NSArray *data = jsonObject[@"data"];
            resultBlock(data);
        }
        else {
            [self errorCheckWithResult:jsonObject errorHandler:errorBlock];
        }
    } errorHandler:^(NSDictionary *data, NSError* error) {
        NSLog(@"네트워크 연결 %i회 실패", retryCount);
        if (error) {    //2014.10.11 by KimES
            if ([error code] == -1009) {
                if (retryCount < RETRY_COUNT) {
                    retryCount++;
                    [self operationListByPostWithPath:path params:body resultHandler:resultBlock errorHandler:errorBlock];
                } else {
                    retryCount = 0;
                    if (errorBlock) {
                        errorBlock(data, error);
                    }
                }
            } else {
                retryCount = 0;
                if (errorBlock) {
                    errorBlock(data, error);
                }
            }
        }
        
        
        if (retryCount < RETRY_COUNT) {
            retryCount++;
            [self operationListByPostWithPath:path params:body resultHandler:resultBlock errorHandler:errorBlock];
        } else {
            retryCount = 0;
            if (errorBlock) {
                errorBlock(data, error);
            }
        }
    }];
}

// 멀티파트 데이터 전송
- (GALRequestOperation *)operationByMultiPartPostWithPath:(NSString*)path
                                                  params:(NSDictionary*)body
                                               multiPart:(NSDictionary*)multiPartDatas
                                           resultHandler:(GALResultBlock)resultBlock
                                            errorHandler:(GALErrorBlock)errorBlock {
    return [self requestOperationWithPath:path multiPart:multiPartDatas headers:nil params:body resultHandler:^(NSDictionary *jsonObject) {
        
//        if([@"TRUE" isEqualToString:resultNo]){
//            NSDictionary *data = jsonObject[@"data"];
//            resultBlock(data);
//        }else{
//            NSDictionary *data = jsonObject[@"error"];
////            errorBlock(data);
//        }
        resultBlock(jsonObject);
    } errorHandler:errorBlock];
}

//#pragma mart - 서버정보
//- (GALRequestOperation *)requestServerInfo:(serverInfoBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    NSMutableDictionary *dictParam = nil;
//    
//    GALRequestOperation *op = [self operationByGetWithPath:@"/cm/serverinfo" params:dictParam resultHandler:^(NSDictionary *data) {
//        GALServerInfo *serverInfo = [GALServerInfo new];
//        [serverInfo injectFromObject:data[@"server_info"]];
//        resultBlock(serverInfo);
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//#pragma mart - 유저정보
//- (GALRequestOperation *)requestUserList:(userListBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    NSMutableDictionary *dictParam = nil;
//    
//    GALRequestOperation *op = [self operationByGetWithPath:@"/user_info" params:dictParam resultHandler:^(NSDictionary *data) {
//        NSMutableArray *userlist = [self makeTypedArray:data[@"user_info"] withClass:[GALUserInfo class]];
//        resultBlock(userlist);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)requestUserInfo:(NSString *)user_uuid OtherUuid:(NSString *)other_uuid SystemLang:(NSString *) sys_lang LangCode:(NSString *)lang_code LangMode:(NSString *)lang_mode resultHandler:(userBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_uuid"];
//    [dictParam setObject:other_uuid forKey:@"other_user_uuid"];
//    [dictParam setObject:sys_lang forKey:@"sys_lang"];
//    
//    if(lang_code != nil){
//        [dictParam setObject:lang_code forKey:@"lang_code"];
//    }
//
//    [dictParam setObject:lang_mode forKey:@"lang_mode"];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_USER_GET params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        GALUserInfo *userInfo = [GALUserInfo new];
//        [userInfo injectFromObject:data];
//        
//        resultBlock(userInfo);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *)deleteUser:(NSString*)user_uuid resultHandler:(userDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_info_uuid"];
//    
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_USER_DELETE params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)updateUserPart:(NSString*) user_uuid Type:(NSString *)type Data:(NSObject *)data resultHandler:(userPartBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_uuid"];
//    [dictParam setObject:type forKey:@"flag"];
//    
//    
//    if([@"languages" isEqualToString:type]){
//        if([data isKindOfClass:[NSMutableArray class]]){
//            NSMutableArray *objArray = [NSMutableArray arrayWithArray:data];
//            
//            NSMutableArray *tempArray = [NSMutableArray array];
//            for(GALLangData *data in objArray){
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObject:data];
//                [tempArray addObject:dic];
//            }
//            
//            [dictParam setObject:tempArray forKey:@"val"];
//        }
//    }else if([@"interests" isEqualToString:type]){
//        if([data isKindOfClass:[NSMutableArray class]]){
//            NSMutableArray *objArray = [NSMutableArray arrayWithArray:data];
//            
//            NSMutableArray *tempArray = [NSMutableArray array];
//            for(GALInterestUser *data in objArray){
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObject:data];
//                [tempArray addObject:dic];
//            }
//            
//            [dictParam setObject:tempArray forKey:@"val"];
//        }
//    }else{
//        [dictParam setObject:data forKey:@"val"];
//    }
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_USER_PART params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *)updateUserFile:(NSString*) user_uuid Flag:(NSString *)flag Url:(NSObject *)url resultHandler:(userFileBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
// 
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_uuid"];
//    [dictParam setObject:flag forKey:@"flag"];
//    [dictParam setObject:url forKey:@"url"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_USER_RGFILE params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//    
//}
//
//
//#pragma mart - 공통
//#pragma mart 위치
//
//- (GALRequestOperation *)requestLocate:(NSString *)sys_lang resultHandler:(locateBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:sys_lang forKey:@"sys_lang"];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_GEO params:dictParam resultHandler:^(NSDictionary *data) {
//
////        GALLocateInfo *locateInfo = [[GALLocateInfo alloc] init];
////        [locateInfo setGeonames:[self makeTypedArray:data[@"geonames"] withClass:[GALGeonames class]]];
//
//        NSMutableArray *geos = [self makeTypedArray:data[@"geonames"] withClass:[GALGeonames class]];
//        
//        resultBlock(geos);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)updateUserStatusithUserUuid:(NSString *)user_uuid UserState:(NSString *)user_status OtherUuid:(NSString *)other_user_uuid CallOption:(GALCallOption *)call_option resultHandler:(userStatusBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_uuid"];
//    [dictParam setObject:user_status forKey:@"user_status"];
//    
//    if(other_user_uuid != nil){
//        [dictParam setObject:other_user_uuid forKey:@"other_user_uuid"];
//    }
//    
//    if(call_option != nil){
//        NSMutableDictionary *optionParam = [[NSMutableDictionary alloc] initWithObject:call_option];
//        [dictParam setObject:optionParam forKey:@"item_id"];
//    }
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_STATUS params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *user_uuid = data[@"user_uuid"];
//        NSString *remains = data[@"remains"];
//        
//        resultBlock(user_uuid,remains);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)requestInterestList:(NSString *)user_uuid UseLang:(NSString *)use_lang resultHandler:(interestBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_uuid"];
//    [dictParam setObject:use_lang forKey:@"lang_code"];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_INTEREST params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSMutableArray *interest = [self makeTypedArray:data[@"interest"] withClass:[GALInterest class]];
//        
//        resultBlock(interest);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)updateHelpMail:(NSString *)user_uuid Title:(NSString *)title Contents:(NSString *)contents resultHandler:(sendMailBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_uuid"];
//    [dictParam setObject:title forKey:@"help_title"];
//    [dictParam setObject:contents forKey:@"help_content"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_MAIL_HELP params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)requestAdvert:(NSString *)user_uuid Language:(NSString *)lang resultHandler:(advertBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setObject:user_uuid forKey:@"user_uuid"];
//    [dictParam setObject:lang forKey:@"lang_code"];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_MAIN_ADVERT params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSMutableArray *advert = [self makeTypedArray:data[@"advert"] withClass:[GALAdvert class]];
//        
//        resultBlock(advert);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
#pragma mark - 인증

- (GALRequestOperation *)requestLogin:(GALLoginParam *)loginParam resultHandler:(loginBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:loginParam];
    
    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_LOGIN params:dictParam resultHandler:^(NSDictionary *data) {
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
        
            GALUserInfo *userInfo = [GALUserInfo new];
            GALServerInfo *serverInfo = [GALServerInfo new];
            
            [userInfo injectFromObject:data[@"user_info"]];
            [serverInfo injectFromObject:data[@"server_info"]];
            
            NSMutableArray *payInfoList = nil;//[self makeTypedArray:data[@"pay_info"] withClass:[GALPayInfo class]];
            
            //resultBlock(serverInfo,userInfo,payInfoList,data[@"email_auth"]);
            resultBlock(serverInfo,userInfo,payInfoList,data[@"email_auth"]);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)requestLogout:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    
    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_LOGOUT params:dictParam resultHandler:^(NSDictionary *data) {
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            resultBlock();
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *) requestRegiUser:(GALRegiUserParam *)regiParam resultHandler:(regiUserBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:regiParam];
    
    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_REGI_USER params:dictParam resultHandler:^(NSDictionary *data) {
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            NSString *user_uuid = data[@"uuid"];
            resultBlock(user_uuid);
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)requestCheckMail:(NSString *)mail resultHandler:(checkMailBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:mail forKey:@"email"];
    
    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_CHECK_MAIL params:dictParam resultHandler:^(NSDictionary *data){
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            resultBlock();
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}


- (GALRequestOperation *)sendFindPasswd:(NSString *)email resultHandler:(sendFindpasswdrBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:email forKey:@"email"];
    
    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_FIND_PASSWD params:dictParam resultHandler:^(NSDictionary *data){
        
        resultBlock();
        
    } errorHandler:errorBlock];
    
    return op;
}


- (GALRequestOperation *)sendCheckCode:(NSString *)email withCode:(NSString *)code withPass:(NSString *)pw resultHandler:(sendFindpasswdrBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    [dictParam setObject:email forKey:@"email"];
    [dictParam setObject:code forKey:@"auth_code"];
    
    if(pw != nil){
        [dictParam setObject:pw forKey:@"new_password"];
    }
    
    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_CHECK_CODE params:dictParam resultHandler:^(NSDictionary *data){
        
        resultBlock();
        
    } errorHandler:errorBlock];
    
    return op;
}

#pragma mark -
#pragma mark 유저 

- (GALRequestOperation *)getUserInfo:(NSString *)other_uuid longitude:(NSString *)longitude latitude:(NSString *)latitude resultHandler:(userBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:other_uuid forKey:@"other_uuid"];
    [dictParam setObject:longitude forKey:@"longitude"];
    [dictParam setObject:latitude forKey:@"latitude"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_USER method:@"GET" params:dictParam resultHandler:^(NSDictionary *data){
        
//        NSInteger code = [data[@"code"] integerValue];
//        if ( code == 200 ) {
        
        if ( data[@"user_info"] ) {
            UserModel *user = [UserModel new];
            [user injectFromObject:data[@"user_info"]];
            
            resultBlock(user);
        
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendModifyUserInfo:(NSString *)uuid flag:(NSString *)flag val:(NSString *)val resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:flag forKey:@"flag"];
    [dictParam setObject:val forKey:@"val"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_USER method:@"PUT" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            resultBlock();
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}
#pragma mark 위존 멤버 리스트

- (GALRequestOperation *)getWezoneMemberList:(NSString *)zone_id zone_type:(NSString *)zone_type longitude:(NSString *)longitude latitude:(NSString *)latitude offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:zone_id forKey:@"zone_id"];
    [dictParam setObject:zone_type forKey:@"zone_type"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", offset] forKey:@"offset"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    if ( longitude ) [dictParam setObject:longitude forKey:@"longitude"];
    if ( latitude ) [dictParam setObject:latitude forKey:@"latitude"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_USERS method:@"GET" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            int total_count = [data[@"total_count"] intValue];
            NSMutableArray *list = [self makeTypedArray:data[@"list"] withClass:[UserModel class]];
            
            resultBlock(total_count, list);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}


#pragma mark 친구 추가

- (GALRequestOperation *)sendAddFriend:(NSString *)other_uuid resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:other_uuid forKey:@"other_uuid"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_USERS_FRIEND method:@"PUT" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            resultBlock();
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

#pragma mark -
#pragma mark 위존

- (GALRequestOperation *)getWezoneHashtag:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_HASHTAGS method:@"GET" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            int total_count = [data[@"total_count"] intValue];
            
            resultBlock(total_count, data[@"list"]);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendWezoneJoin:(NSString *)wezone_id flag:(NSString *)flag resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:wezone_id forKey:@"wezone_id"];
    [dictParam setObject:flag forKey:@"flag"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_MY_WEZONE method:@"PUT" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            WezoneModel *wezone = [WezoneModel new];
            [wezone injectFromObject:data[@"wezone_info"]];
            
            resultBlock(wezone);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)getWezone:(NSString *)wezone_id withLongitude:(NSString *)longitude withLatitude:(NSString *)latitude resultHandler:(wezoneBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    if ( wezone_id ) [dictParam setObject:wezone_id forKey:@"wezone_id"];
    if ( longitude ) [dictParam setObject:longitude forKey:@"longitude"];
    if ( latitude ) [dictParam setObject:latitude forKey:@"latitude"];
    
    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_WEZONE params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            WezoneModel *wezone = [WezoneModel new];
            [wezone injectFromObject:data[@"wezone_info"]];
            
            resultBlock(wezone);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendRegistWezone:(WezoneModel *)wezone resultHandler:(idBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setValue:wezone.title forKey:@"title"];
    [dictParam setValue:wezone.introduction forKey:@"introduction"];
    [dictParam setValue:wezone.img_url forKey:@"img_url"];
    [dictParam setValue:wezone.bg_img_url forKey:@"bg_img_url"];
    [dictParam setValue:wezone.longitude forKey:@"longitude"];
    [dictParam setValue:wezone.latitude forKey:@"latitude"];
    [dictParam setValue:wezone.wezone_type forKey:@"wezone_type"];
    [dictParam setValue:wezone.member_limit forKey:@"member_limit"];
    [dictParam setValue:wezone.location_type forKey:@"location_type"];
    [dictParam setValue:wezone.location_data forKey:@"location_data"];
    [dictParam setValue:wezone.push_flag forKey:@"push"];
    [dictParam setValue:wezone.beacon forKey:@"beacon"];
    [dictParam setValue:wezone.zone_in forKey:@"zone_in"];
    [dictParam setValue:wezone.zone_out forKey:@"zone_out"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE method:@"POST" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            NSString *wezone_id = data[@"wezone_id"];
            resultBlock(wezone_id);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendModifyWezone:(NSString *)wezone_id wezone_info:(NSArray *)wezone_info resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setValue:wezone_id forKey:@"wezone_id"];
    [dictParam setValue:wezone_info forKey:@"wezone_info"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE method:@"PUT" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            resultBlock();
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

#pragma mark 위존 리스트

- (GALRequestOperation *)getWezoneList:(NSString *)longitude latitude:(NSString *)latitude resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    if ( longitude ) [dictParam setObject:longitude forKey:@"longitude"];
    if ( latitude ) [dictParam setObject:latitude forKey:@"latitude"];
    
    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_WEZONE_LIST params:dictParam resultHandler:^(NSDictionary *data){
        
        int total_count = [data[@"total_count"] intValue];
        NSMutableArray *userlist = [self makeTypedArray:data[@"list"] withClass:[WezoneModel class]];
        
        resultBlock(total_count, userlist);
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)getWezoneList:(NSString *)search_type keyword:(NSString *)keyword longitude:(NSString *)longitude latitude:(NSString *)latitude offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    if ( search_type ) [dictParam setObject:search_type forKey:@"search_type"];
    if ( keyword ) [dictParam setObject:keyword forKey:@"keyword"];
    if ( longitude ) [dictParam setObject:longitude forKey:@"longitude"];
    if ( latitude ) [dictParam setObject:latitude forKey:@"latitude"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", offset] forKey:@"offset"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    
    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_WEZONE_LIST params:dictParam resultHandler:^(NSDictionary *data){
        
        int total_count = [data[@"total_count"] intValue];
        NSMutableArray *userlist = [self makeTypedArray:data[@"list"] withClass:[WezoneModel class]];
        
        resultBlock(total_count, userlist);
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)getMyWezoneList:(NSString *)other_uuid longitude:(NSString *)longitude withLatitude:(NSString *)latitude resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    if ( other_uuid ) [dictParam setObject:other_uuid forKey:@"other_uuid"];
    if ( longitude ) [dictParam setObject:longitude forKey:@"longitude"];
    if ( latitude ) [dictParam setObject:latitude forKey:@"latitude"];
    
    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_MY_WEZONE_LIST params:dictParam resultHandler:^(NSDictionary *data){
        
        int total_count = [data[@"total_count"] intValue];
        NSMutableArray *userlist = [self makeTypedArray:data[@"list"] withClass:[WezoneModel class]];
        
        resultBlock(total_count, userlist);
        
    } errorHandler:errorBlock];
    
    return op;
}

#pragma mark 위존 댓글

- (GALRequestOperation *)getWezoneCommentList:(NSString *)wezone_id type:(NSString *)type board_id:(NSString *)board_id offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:wezone_id forKey:@"wezone_id"];
    [dictParam setObject:type forKey:@"type"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", offset] forKey:@"offset"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    if ( board_id )[dictParam setObject:board_id forKey:@"board_id"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_COMMENTS method:@"GET" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            int total_count = [data[@"total_count"] intValue];
            NSMutableArray *list = [self makeTypedArray:data[@"list"] withClass:[WezoneComment class]];
            
            resultBlock(total_count, list);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendRegistComment:(NSString *)wezone_id type:(NSString *)type board_id:(NSString *)board_id content:(NSString *)content resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:wezone_id forKey:@"wezone_id"];
    [dictParam setObject:type forKey:@"type"];
    [dictParam setObject:content forKey:@"content"];
    if ( board_id ) [dictParam setObject:board_id forKey:@"board_id"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_COMMENT method:@"POST" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            resultBlock();
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendModifyComment:(NSString *)comment_id content:(NSString *)content resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:comment_id forKey:@"comment_id"];
    [dictParam setObject:content forKey:@"content"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_COMMENT method:@"PUT" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            resultBlock();
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendDeleteComment:(NSString *)comment_id resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:comment_id forKey:@"comment_id"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_COMMENT method:@"DELETE" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            resultBlock();
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

#pragma mark 위존 게시글

- (GALRequestOperation *)getWezoneBoardList:(NSString *)wezone_id offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:wezone_id forKey:@"wezone_id"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", offset] forKey:@"offset"];
    [dictParam setObject:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_BOARDS method:@"GET" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            int total_count = [data[@"total_count"] intValue];
            NSMutableArray *list = [self makeTypedArray:data[@"list"] withClass:[WezoneBoard class]];

            resultBlock(total_count, list);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)getWezoneBoard:(NSString *)board_id resultHandler:(boardBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:board_id forKey:@"board_id"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_BOARD method:@"GET" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            WezoneBoard *board = [WezoneBoard new];
            [board injectFromObject:data[@"board_info"]];
            
            resultBlock(board);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}


- (GALRequestOperation *)sendRegistBoard:(NSString *)wezone_id notice_flag:(NSString *)notice_flag content:(NSString *)content url:(NSString *)url resultHandler:(boardIdBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:wezone_id forKey:@"wezone_id"];
    [dictParam setObject:notice_flag forKey:@"notice_flag"];
    [dictParam setObject:content forKey:@"content"];
    if ( url ) [dictParam setObject:@[@{@"url":url, @"type":@"1", @"format":@"png"}] forKey:@"board_file"];
        
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_BOARD method:@"POST" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            NSInteger border_id = [data[@"border_id"] integerValue];
            resultBlock(border_id);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendModifyBoard:(NSString *)board_id put_flag:(NSString *)put_flag notice_flag:(NSString *)notice_flag content:(NSString *)content url:(NSString *)url resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:board_id forKey:@"board_id"];
    [dictParam setObject:put_flag forKey:@"put_flag"];
    [dictParam setObject:notice_flag forKey:@"notice_flag"];
    [dictParam setObject:content forKey:@"content"];
    if ( url ) [dictParam setObject:@[@{@"url":url, @"type":@"1", @"format":@"png"}] forKey:@"board_file"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_BOARD method:@"PUT" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            resultBlock();
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

- (GALRequestOperation *)sendDeleteBoard:(NSString *)board_id resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setObject:board_id forKey:@"board_id"];
    
    GALRequestOperation *op = [self operationWithPath:NETWORK_WEZONE_BOARD method:@"DELETE" params:dictParam resultHandler:^(NSDictionary *data){
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            
            resultBlock();
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}

#pragma mark - image
- (GALRequestOperation *)getImageWithUrl:(NSString *)url completionHandler:(GALImageBlock)imageBlock errorHandler:(GALErrorBlock)errorBlock{
    
    if ( url == nil || url.length == 0 ) {
        return nil;
    }
    NSString *imgURL = url;
    if ( [url hasPrefix:@"http"] == NO ) {
        imgURL = [NSString stringWithFormat:@"%@%@", SERVICE_HOST_NAME, url];
    }
    NSLog(@"getImageWithUrl : %@", imgURL);
    GALRequestOperation *op = [self requestImageOperationWithURL:[NSURL URLWithString:imgURL] headers:nil completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        if (!isInCache)
            NSLog(@"image loaded %dx%d : %@", (int)fetchedImage.size.width, (int)fetchedImage.size.height, url);
        imageBlock(fetchedImage, isInCache);
    } errorHandler:errorBlock];
    
    if (op)
        [op setQueuePriority:NSOperationQueuePriorityLow];
    
    return op;

}

- (GALRequestOperation *)uploadImage:(UIImage *)image withUuid:(NSString *)user_uuid type:(NSString *)type id:(NSString *)id status:(NSString *)status resultHandler:(uploadImageBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock {
    
    NSMutableDictionary *multiPartDatas =[[NSMutableDictionary alloc] init];
    if (image) {

        NSData *imageData = UIImagePNGRepresentation(image);
        long max = 2 * 1024 * 1024;
        if ( imageData.length >= max ) {
            float rate = imageData.length / max;
            imageData = UIImageJPEGRepresentation(image, rate);
            UIImage *scaled = [UIImage imageWithData:imageData];
            imageData = UIImagePNGRepresentation(scaled);
        }
       
        NSLog(@"uploadImage : %dx%d, %d byte", (int)image.size.width, (int)image.size.height, imageData.length);
        GALMultiPartData *data = [[GALMultiPartData alloc] initWithFileData:imageData fileName:[user_uuid stringByAppendingString:@".png"] mimeType:@"image/*"];
        
        [multiPartDatas setValue:data forKey:@"userfile"];
    }
    
    NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
    
    [dictParam setValue:type forKey:@"type"];
    [dictParam setValue:status forKey:@"status"];
    if (id) [dictParam setValue:id forKey:@"id"];
    
    NSString *url = [[NETWORK_IMAGEURL stringByAppendingString:@"user_uuid="] stringByAppendingString:user_uuid];
    
    GALRequestOperation *op = [self operationByMultiPartPostWithPath:url params:dictParam multiPart:multiPartDatas resultHandler:^(NSDictionary *data) {
        
        NSInteger code = [data[@"code"] integerValue];
        if ( code == 200 ) {
            NSString *imageUrl = data[@"url"];
            resultBlock(imageUrl);
            
        } else {
            errorBlock(data, nil);
        }
        
    } errorHandler:errorBlock];
    
    return op;
}
//
//- (GALRequestOperation *)getFileWithUrl:(NSString *)url completionHandler:(GALAudioBlock)fileBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    GALRequestOperation *op = [self requestFileOperationWithURL:[NSURL URLWithString:url] headers:nil completionHandler:^(NSData *audioData, NSURL *url) {
//        fileBlock(audioData);
//    } errorHandler:errorBlock];
//    
//    if (op)
//        [op setQueuePriority:NSOperationQueuePriorityLow];
//    
//    return op;
//    
//}
//
//- (GALRequestOperation *)uploadFile:(NSData *)fileData withUuid:(NSString *)user_uuid resultHandler:(uploadFileBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    NSDictionary *multiPartDatas = nil;
//    
//    GALMultiPartData *data = [[GALMultiPartData alloc] initWithFileData:fileData fileName:[user_uuid stringByAppendingString:@".mp3"] mimeType:@"file/"];
//    multiPartDatas = @{@"userfile": data};
//    
//    NSString *url = [[NETWORK_FILEURL stringByAppendingString:@"user_uuid="] stringByAppendingString:user_uuid];
//    
//    GALRequestOperation *op = [self operationByMultiPartPostWithPath:url params:nil multiPart:multiPartDatas resultHandler:^(NSDictionary *data) {
//        
//        NSString *result = data[@"result"];
//        
//        if([@"TRUE" isEqualToString:result]){
//            NSDictionary *dataDic = data[@"data"];
//            NSString *fileUrl = dataDic[@"file_url"];
//            resultBlock(fileUrl);
//        }else{
//            errorBlock(data,nil);
//        }
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//
//#pragma mark - Main
//- (GALRequestOperation *)requestMainList:(GALMainParam *)mainParam resultHandler:(mainBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:mainParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_MAIN_LIST params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *total_count = data[@"total_count"];
//        NSMutableArray *userlist = [self makeTypedArray:data[@"user"] withClass:[GALUserInfo class]];
//        
//        resultBlock(total_count, userlist);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//#pragma mark - Favorite
//- (GALRequestOperation *)requestFavoriteList:(GALFavoriteParam *)favoriteParam resultHandler:(favoriteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:favoriteParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_GET_FAVORITES params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *total_count = data[@"total_count"];
//        NSMutableArray *userlist = [self makeTypedArray:data[@"user"] withClass:[GALUserInfo class]];
//        
//        resultBlock(total_count, userlist);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *) registFavorite:(GALFavoriteEditParam *)favoriteEditParam resultHandler:(favoriteEditBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:favoriteEditParam];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_POST_FAVORITE params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *) deleteFavorite:(GALFavoriteEditParam *)favoriteEditParam resultHandler:(favoriteEditBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:favoriteEditParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_DELETE_FAVORITE params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *)deleteFavoriteList:(NSString *)user_uuid Ids:(NSArray *)ids resultHandler:(favoriteEditBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    
//    NSMutableArray *objArray = [NSMutableArray arrayWithArray:ids];
//    NSMutableArray *tempArray = [NSMutableArray array];
//    for(GALFavoriteDeleteParam *data in objArray){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObject:data];
//        [tempArray addObject:dic];
//    }
//    
//    [dictParam setValue:tempArray forKey:@"ids"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_DELETE_FAVORITES params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//
//}
//
//#pragma mark - Message
//- (GALRequestOperation *)requestMessageUserList:(GALMessageParam *)messageParam resultHandler:(messageBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:messageParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_GET_MESSAGE_USERLIST params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *total_count = data[@"total_count"];
//        NSMutableArray *userlist = [self makeTypedArray:data[@"list"] withClass:[GALMessageUser class]];
//        
//        resultBlock(total_count, userlist);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}

//- (GALRequestOperation *)requestMessageList:(GALMessageListParam *)messageListParam resultHandler:(messageListBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//   
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:messageListParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_GET_MESSAGES params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *total_count = data[@"total_count"];
//        GALOtherUser *otherUser = [GALOtherUser new];
//        [otherUser injectFromObject:data[@"other_user"]];
//        
//        NSMutableArray *messageList = [self makeTypedArray:data[@"message"] withClass:[GALMessage class]];
//        
//        resultBlock(total_count, otherUser, messageList);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//    
//}
//
//- (GALRequestOperation *)deleteMessageList:(NSString *)user_uuid Ids:(NSArray *)other_user_ids resultHandler:(messageDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:other_user_ids forKey:@"other_user_uuids"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_DELETE_MESSAGE_USER params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//#pragma mark - Pay
//- (GALRequestOperation *) requestPayList:(GALPayParam *)payParam resultHandler:(payBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:payParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_PAY_LANGCOINHISTORY params:dictParam resultHandler:^(NSDictionary *data) {
//        
//
//        NSString *langcoin_count = data[@"langcoin_count"];
//        NSString *cashout_flag = data[@"cashout_flag"];
//        NSString *total_count = data[@"total_count"];
//        
//        NSMutableArray *langcoinList = [self makeTypedArray:data[@"langcoin"] withClass:[GALLangCoin class]];
//        
//        resultBlock(langcoin_count, cashout_flag, total_count, langcoinList);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//    
//}
//
//- (GALRequestOperation *)exchangeWithParam:(GALExchangeParam *)exchangeParam resultHandler:(exchangeBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:exchangeParam];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_PAY_EXCHANGE params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//#pragma mark - Review
//- (GALRequestOperation *) requestReviewList:(GALReviewParam *)reviewParam resultHandler:(reviewBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:reviewParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_GET_REVIEW params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *total_count = data[@"total_count"];
//        NSMutableArray *reviewList = [self makeTypedArray:data[@"review"] withClass:[GALReview class]];
//        resultBlock(total_count, reviewList);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)updateReview:(GALReviewPostParam *)reviewPostParam resultHandler:(reviewPostBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:reviewPostParam];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_POST_REVIEW params:dictParam resultHandler:^(NSDictionary *data) {
//
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//
//}
//
//
//
//#pragma mark - Schedule
//- (GALRequestOperation *)requestScheduleList:(GALScheduleParam *)scheduleParam resultHandler:(scheduleBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] initWithObject:scheduleParam];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_GET_SCHEDULES params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *total_count = data[@"total_count"];
//        NSString *remain_count = data[@"remain_count"];
//        NSMutableArray *scheduleList = [self makeTypedArray:data[@"schedule"] withClass:[GALSchedule class]];
//        resultBlock(total_count, remain_count, scheduleList);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)registSchedule:(GALSchedulePostParam *)scheduleParam resultHandler:(schedulePostBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:scheduleParam.user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:scheduleParam.other_user_uuid forKey:@"other_user_uuid"];
//    [dictParam setValue:scheduleParam.all_cost forKey:@"all_cost"];
//    
//    
//    NSMutableArray *scheduleArray = [NSMutableArray arrayWithArray:scheduleParam.schedule];
//    NSMutableArray *scheduleTempArray = [NSMutableArray arrayWithCapacity:scheduleParam.schedule.count];
//    
//    for (GALBookInputItem *bookInputItem in scheduleArray) {
//        
//        NSMutableArray *scheduleItemArray = [NSMutableArray arrayWithArray:bookInputItem.schedule_item];
//        NSMutableArray *scheduleItemTempArray = [NSMutableArray arrayWithCapacity:[bookInputItem.schedule_item count]];
//        
//        for (GALScheduleItem *scheduleItem in scheduleItemArray){
//            
//            NSDictionary *param = @{@"schedule_item_id": scheduleItem.schedule_item_id == nil ? @"" : scheduleItem.schedule_item_id,
//                                    @"schedule_date": scheduleItem.schedule_date,
//                                    @"schedule_min":scheduleItem.schedule_min,
//                                    @"cost":scheduleItem.cost};
//            
//            [scheduleItemTempArray addObject:param];
//        }
//        
//        NSDictionary *scheduleParam = @{@"booked_lang": bookInputItem.booked_lang,
//                                        @"total_cost": bookInputItem.total_cost,
//                                        @"schedule_date":bookInputItem.schedule_date,
//                                        @"schedule_item":scheduleItemTempArray};
//        
//        [scheduleTempArray addObject:scheduleParam];
//    }
//
//    
//    [dictParam setValue:scheduleTempArray forKey:@"schedule"];
//    
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_POST_SCHEDULE params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock(data[@"langcoin_id"]);
//        
//    } errorHandler:errorBlock];
//    
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)registScheduleTemp:(GALSchedulePostTempParam *)scheduleParam resultHandler:(schedulePostBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:scheduleParam.user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:scheduleParam.other_user_uuid forKey:@"other_user_uuid"];
//    [dictParam setValue:scheduleParam.all_cost forKey:@"all_cost"];
//    [dictParam setValue:scheduleParam.langcoin_amount forKey:@"langcoin_amount"];
//    [dictParam setValue:scheduleParam.paycom forKey:@"paycom"];
//    [dictParam setValue:scheduleParam.usd_amount forKey:@"usd_amount"];
//    
//    
//    NSMutableArray *scheduleArray = [NSMutableArray arrayWithArray:scheduleParam.schedule];
//    NSMutableArray *scheduleTempArray = [NSMutableArray arrayWithCapacity:scheduleParam.schedule.count];
//    
//    for (GALBookInputItem *bookInputItem in scheduleArray) {
//        
//        NSMutableArray *scheduleItemArray = [NSMutableArray arrayWithArray:bookInputItem.schedule_item];
//        NSMutableArray *scheduleItemTempArray = [NSMutableArray arrayWithCapacity:[bookInputItem.schedule_item count]];
//        
//        for (GALScheduleItem *scheduleItem in scheduleItemArray){
//            
//            NSDictionary *param = @{@"schedule_item_id": scheduleItem.schedule_item_id == nil ? @"" : scheduleItem.schedule_item_id,
//                                    @"schedule_date": scheduleItem.schedule_date,
//                                    @"schedule_min":scheduleItem.schedule_min,
//                                    @"cost":scheduleItem.cost};
//            
//            [scheduleItemTempArray addObject:param];
//        }
//        
//        NSDictionary *scheduleParam = @{@"booked_lang": bookInputItem.booked_lang,
//                                        @"total_cost": bookInputItem.total_cost,
//                                        @"schedule_date":bookInputItem.schedule_date,
//                                        @"schedule_item":scheduleItemTempArray};
//        
//        [scheduleTempArray addObject:scheduleParam];
//    }
//    
//    [dictParam setValue:scheduleTempArray forKey:@"schedule"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_POST_SCHEDUlES_TEMP params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock(data[@"langcoin_id"]);
//        
//    } errorHandler:errorBlock];
//    
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)deleteSchedule:(NSString *)user_uuid ScheduleId:(NSString *)scheduleId ScheduleState:(NSString *)schedule_state LangcoinSessionId:(NSString *)langcoin_sessionId ReasonId:(NSString *)sc_del_reason_id resultHandler:(scheduleDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:scheduleId forKey:@"schedule_id"];
//    [dictParam setValue:schedule_state forKey:@"schedule_state"];
//    [dictParam setValue:langcoin_sessionId forKey:@"langcoin_session_id"];
//    [dictParam setValue:sc_del_reason_id forKey:@"sc_del_reason_id"];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_DELETE_SCHEDULE params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock(data[@"schedule_id"]);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//
//}
//
//
//#pragma mark - TimeTable
//- (GALRequestOperation *)requestTimeTableList:(NSString *)user_uuid SearchUuid:(NSString *)search_uuid resultHandler:(timeTableBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:search_uuid forKey:@"search_uuid"];
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_GET_TIMETABLES params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        NSString *total_count = data[@"total_count"];
//        NSMutableArray *timeTableList = [self makeTypedArray:data[@"timetable"] withClass:[GALTimeTable class]];
//        resultBlock(total_count, timeTableList);
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//
//}
//
//- (GALRequestOperation *)deleteTimeTableList:(NSString *)user_uuid Flag:(NSString *)flag TimeTableId:(NSString *)timetable_id resultHandler:(timeTableDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:flag forKey:@"flag"];
//    if(timetable_id != nil){
//        [dictParam setValue:timetable_id forKey:@"timetable_id"];
//    }
//    
//    GALRequestOperation *op = [self operationByGetWithPath:NETWORK_DELETE_TIMETABLE params:dictParam resultHandler:^(NSDictionary *data) {
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//- (GALRequestOperation *)registTimeTableList:(NSString *)user_uuid TimeTable:(NSArray *)timetable resultHandler:(timeTableRegistBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    
//    NSMutableArray *timetableArray = [NSMutableArray arrayWithCapacity:timetable.count];
//    
//    for (GALTimeTable *table in timetable) {
//        
//        NSMutableArray *selectedDay = [NSMutableArray arrayWithArray:table.selected_day];
//        NSMutableArray *selelctedArray = [NSMutableArray arrayWithCapacity:selectedDay.count];
//        for(NSDictionary *dic in selectedDay){
//            NSDictionary *weekParam = @{@"dayofweek":[dic objectForKey:@"dayofweek"]};
//            [selelctedArray addObject:weekParam];
//        }
//        
//        NSDictionary *param = @{@"start_time": table.start_time,
//                                @"end_time": table.end_time,
//                                @"selected_day":selelctedArray};
//        
//        [timetableArray addObject:param];
//    }
//    
//    [dictParam setValue:timetableArray forKey:@"timetable"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_POST_TIMETABLE params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//
//
//#pragma mark - setting
//- (GALRequestOperation *)updateNationality:(NSString *)user_uuid Country:(NSString *)country resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:country forKey:@"user_country"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_UPDATE_NATIONALITY params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *)updateGender:(NSString *)user_uuid Gender:(NSString *)gender resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:gender forKey:@"user_gender"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_UPDATE_GENDER params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *)updateSearch:(NSString *)user_uuid IsTeachSearch:(NSString *)is_teach_search IsLearnSearch:(NSString *)is_learn_search resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:is_teach_search forKey:@"is_search_teach"];
//    [dictParam setValue:is_learn_search forKey:@"is_search_learn"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_UPDATE_SEARCH params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//- (GALRequestOperation *)updateNotification:(NSString *)user_uuid IsNoticeMessage:(NSString *)is_notice_message IsNoticeEmail:(NSString *)is_notice_email resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock{
//    
//    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
//    [dictParam setValue:user_uuid forKey:@"user_uuid"];
//    [dictParam setValue:is_notice_message forKey:@"is_notice_message"];
//    [dictParam setValue:is_notice_email forKey:@"is_notice_email"];
//    
//    GALRequestOperation *op = [self operationByPostWithPath:NETWORK_UPDATE_NOTIFICATION params:dictParam resultHandler:^(NSDictionary *data){
//        
//        resultBlock();
//        
//    } errorHandler:errorBlock];
//    
//    return op;
//}
//
//#pragma mark - etc method
//- (NSMutableArray *)makeTypedArray:(NSArray *)array withClass:(__unsafe_unretained Class)cls {
//    
//    if(array ==nil || [array isKindOfClass:[NSNull class]]){
//        return nil;
//    }
//    
//    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[array count]];
//    for (id item in array) {
//        id model = [cls new];
//        [model injectFromObject:item arrayClass:nil];
//        [result addObject:model];
//    }
//    return result;
//}

@end










