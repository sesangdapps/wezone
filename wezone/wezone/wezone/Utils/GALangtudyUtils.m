//
//  GALangtudyUtils.m
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALangtudyUtils.h"
#import "AESExtention.h"

#include <CommonCrypto/CommonDigest.h>

#import "BDRSACryptor.h"
#import "BDRSACryptorKeyPair.h"
#import "Reachability.h"


@implementation GALangtudyUtils

#pragma mark UserDefaults

+ (BOOL)isLogin{
    if([ApplicationDelegate loginData].user_info == nil){
        return false;
    }else{
        return true;
    }
}

+ (void)saveValue:(NSString *)value Key:(NSString *)key{
    AESExtention *aes = [AESExtention sharedAESExtention];
    NSString* encryptKey = [aes aes256EncryptString:key];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(value == nil){
        [defaults setValue:value forKey:encryptKey];
    }else{
        NSString* encryptValue = [aes aes256EncryptString:value];
        [defaults setValue:encryptValue forKey:encryptKey];
    }
    [defaults synchronize];
}

+ (NSString *)getValue:(NSString *)key{
    AESExtention *aes = [AESExtention sharedAESExtention];
    NSString* ecryptKey = [aes aes256EncryptString:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [defaults valueForKey:ecryptKey];
    if (value != nil) {
        NSString* decryptValue = [aes aes256DecryptString:value];
        return decryptValue;
    }
    return nil;
}

+ (void)removeValue:(NSString *)key {
    AESExtention *aes = [AESExtention sharedAESExtention];
    NSString* ecryptKey = [aes aes256EncryptString:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:ecryptKey];
}

#pragma mark Vailidate

+ (void)checkContent:(NSString *)content withLength:(NSUInteger)length withSubject:(NSString *)subject
              withOk:(void (^)(BOOL isOver, NSString *limitContent))okBlock withCancel:(void (^)())cancelBlock {
    if (content.length <= length) {
        okBlock(NO, content);
    }
    else {
        NSString *message = [NSString stringWithFormat:@"%@은(는) %d자를 넘을 수 없습니다. %d자만 사용하시겠습니까?", subject, length, length];
        [GALangtudyUtils showAlert:GALAlertTypeYesNo message:message close:^(GALAlertButton buttonType) {
            if (buttonType == GALAlertButtonYes) {
                NSString *limitContent = [content substringToIndex:length];
                okBlock(NO, limitContent);
            }
            else if (buttonType == GALAlertButtonNo && cancelBlock) {
                cancelBlock();
            }
        }];
    }
}

#pragma mark Alert

+ (NSString *)getAlertMessageByError:(NSError *)error {
    NSString *message = nil;
    //    if (error.userInfo && error.userInfo.count > 0) {
    //        message = [error localizedDescription];
    //    }
    //    else {
    //        message = error.domain;
    //    }
    if (error) {    //2014.10.11 by KimES
        if ([error code] == -1009) {
            message = @"무선 인터넷(4G/WiFi) 연결이 불안정합니다. 네트워크 연결을 확인해주세요.";
        } else if ([error code] == ERROR_CODE) {
            if (error.userInfo && error.userInfo.count > 0) {
                message = [error.userInfo objectForKey:@"error_desc"];
            }
            else {
                message = error.domain;
            }
        } else {
            message = @"일시적 오류로 인해 서비스 연결이 지연되고 있습니다. 잠시 후 다시 시도해주세요.";
        }
    }
    
    return message;
}

+ (void)showAlert:(NSError *)error close:(void (^)())closeBlock {
    NSString *message = [self getAlertMessageByError:error];
    [self showAlert:GALAlertTypeOk message:message title:@"알림" close:closeBlock];
}

+ (void)showAlertWithButtons:(NSArray *)buttonTitles error:(NSError *)error title:(NSString *)title close:(void (^)(int buttonIndex))closeBlock {
    NSString *message = [self getAlertMessageByError:error];
    [self showAlertWithButtons:buttonTitles message:message title:title close:closeBlock];
}

+ (void)showAlert:(GALAlertType)type message:(NSString *)message close:(void (^)(GALAlertButton buttonType))closeBlock {
    [self showAlert:type message:message title:nil close:closeBlock];
}

+ (void)showAlert:(GALAlertType)type message:(NSString *)message title:(NSString *)title close:(void (^)(GALAlertButton buttonType))closeBlock {
    GALAlertView *alertView = [[GALAlertView alloc] init];
    
    //    [alertView setContainerView:[self createDemoView]];
    [alertView setMessage:message];
    [alertView setTitle:title];
    
    NSArray *btns = nil;
    switch (type) {
        case GALAlertTypeOk:         btns = @[LSSTRING(@"ok")]; break;
        case GALAlertTypeOkCancel:   btns = @[LSSTRING(@"cancel"),LSSTRING(@"ok")]; break;
        case GALAlertTypeYesNo:      btns = @[LSSTRING(@"no"),LSSTRING(@"yes")]; break;
    }
    
    [alertView setButtonTitles:btns];
    [alertView setOnButtonTouchUpInside:^(GALAlertView *alertView, int buttonIndex) {
        GALAlertButton btn = 0;
        switch (type) {
            case GALAlertTypeOk:         btn = GALAlertButtonOk; break;
            case GALAlertTypeOkCancel:   btn = buttonIndex == 0 ? GALAlertButtonCancel : GALAlertButtonOk; break;
            case GALAlertTypeYesNo:      btn = buttonIndex == 0 ? GALAlertButtonNo : GALAlertButtonYes; break;
        }
        if (closeBlock != NULL)
            closeBlock(btn);
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

+ (void)showAlertWithButtons:(NSArray *)buttonTitles message:(NSString *)message close:(void (^)(int buttonIndex))closeBlock {
    [self showAlertWithButtons:buttonTitles message:message title:nil close:closeBlock];
}

+ (void)showAlertWithButtons:(NSArray *)buttonTitles message:(NSString *)message title:(NSString *)title close:(void (^)(int buttonIndex))closeBlock {
    GALAlertView *alertView = [[GALAlertView alloc] init];
    [alertView setMessage:message];
    [alertView setTitle:title];
    [alertView setButtonTitles:buttonTitles];
    [alertView setOnButtonTouchUpInside:^(GALAlertView *alertView, int buttonIndex) {
        if (closeBlock != NULL)
            closeBlock(buttonIndex);
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

#pragma mark ActivityIndicator


+ (void)showActivityIndicator {
    [[GALActivityIndicator sharedInstance] show];
}

+ (void)hideActivityIndicator {
    [[GALActivityIndicator sharedInstance] hide];
}

#pragma mark font size return
+ (float)getFontSize {
    NSString *mode = [GALangtudyUtils getValue:FONT_SIZE];
    if (mode.length) {
        return [mode floatValue];
    }
    return 15.f;
}

+ (NSString *)sha512:(NSString *)input {
    //    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//+ (NSString *)rsaEnc:(NSString *)input {
//    BDError *error = [[BDError alloc] init];
//    BDRSACryptor *RSACryptor = [[BDRSACryptor alloc] init];
//    NSString *privateKey = nil;
//    NSString *publicKey = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----", ApplicationDelegate.appVersion.publicKey];
//    BDRSACryptorKeyPair *RSAKeyPair = [[BDRSACryptorKeyPair alloc] initWithPublicKey:publicKey privateKey:privateKey];
//    NSString *result = [RSACryptor encrypt:input key:RSAKeyPair.publicKey error:error];
//    return result;
//}

#pragma mark - URL

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

+ (BOOL) validateEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    }
    else
        return YES;
}

+ (UIImage *) getLevelImage:(NSString *) level{
    
    if(level == nil){
        return [UIImage imageNamed:@"icon_badge_level_one"];
    }
    
    CGFloat levleFloat = [level floatValue];
    
    if(levleFloat >=0 && levleFloat < 1.5){
        return [UIImage imageNamed:@"icon_badge_level_one"];
    }else if(levleFloat >= 1.5 && levleFloat < 2.5){
        return [UIImage imageNamed:@"icon_badge_level_two"];
    }else if(levleFloat >=2.5 && levleFloat < 3.5){
        return [UIImage imageNamed:@"icon_badge_level_three"];
    }else if(levleFloat >= 3.5 && levleFloat < 4.5){
        return [UIImage imageNamed:@"icon_badge_level_four"];
    }else if(levleFloat >= 4.5){
        return [UIImage imageNamed:@"icon_badge_level_five"];
    }else{
        return [UIImage imageNamed:@"icon_badge_level_one"];
    }
}

+ (NSString *) getLevelString:(NSString *) level{
    
    if(level == nil){
        return LSSTRING(@"beginner");
    }
    
    CGFloat levleFloat = [level floatValue];
    
    if(levleFloat >=0 && levleFloat < 1.5){
        return LSSTRING(@"beginner");
    }else if(levleFloat >= 1.5 && levleFloat < 2.5){
        return LSSTRING(@"pre_intermediate");
    }else if(levleFloat >=2.5 && levleFloat < 3.5){
        return LSSTRING(@"intermediate");
    }else if(levleFloat >= 3.5 && levleFloat < 4.5){
        return LSSTRING(@"upper_intermediate");
    }else if(levleFloat >= 4.5){
        return LSSTRING(@"advanced");
    }else{
        return LSSTRING(@"beginner");
    }
}

+ (UIImage *) getMaskImage:(NSString *)status{
    
    if(status == nil ){
        return [UIImage imageNamed:@"mask_profile_off"];
    }
    
    if([status isEqualToString:@"O"]){
        return [UIImage imageNamed:@"mask_profile_availavle"];
    }else if([status isEqualToString:@"C"]){
        return [UIImage imageNamed:@"mask_profile_on"];
    }else{
        return [UIImage imageNamed:@"mask_profile_off"];
    }
}

+ (UIImage *) getProfileMaskImage:(NSString *)status{
    
    if(status == nil ){
        return [UIImage imageNamed:@"mask_photo_off"];
    }
    
    if([status isEqualToString:@"O"]){
        return [UIImage imageNamed:@"mask_photo_availavle"];
    }else if([status isEqualToString:@"C"]){
        return [UIImage imageNamed:@"mask_photo_on"];
    }else{
        return [UIImage imageNamed:@"mask_photo_off"];
    }
}
//
//+ (NSString *) getCallMessage:(NSString *)type{
//    
//    NSString *strTemp;
//    
//    if([type isEqualToString:STATE_REQUEST]){
//        strTemp =  LSSTRING(@"call_request");
//    } else if([type isEqualToString:STATE_REQUEST_DISCONNECT]){
//        strTemp = LSSTRING(@"call_disconnect");
//    }else if([type isEqualToString:STATE_RECEIVE]){
//        strTemp = LSSTRING(@"call_receive");
//    }else if([type isEqualToString:STATE_REFUSE]){
//        strTemp = LSSTRING(@"call_refuse");
//    }else if([type isEqualToString:STATE_ONCALL]){
//        strTemp = LSSTRING(@"call_oncall");
//    }else if([type isEqualToString:STATE_TIMEOUT]){
//        strTemp = LSSTRING(@"call_timeout");
//    }else if([type isEqualToString:STATE_UNSUPPORTED]){
//        strTemp = LSSTRING(@"call_unsupport");
//    }else if([type isEqualToString:STATE_HANGUP]){
//        strTemp = LSSTRING(@"call_hangup");
//    }
//    
//    return strTemp;
//}
//
//+ (UIImage *) getCallIcon:(NSString *) type{
//    
//    UIImage *image;
//    
//    if([type isEqualToString:STATE_REQUEST]){
//        image = [UIImage imageNamed:@"call_request"];
//    } else if([type isEqualToString:STATE_REQUEST_DISCONNECT]){
//        image = [UIImage imageNamed:@"call_disconnect"];
//    }else if([type isEqualToString:STATE_RECEIVE]){
//        image = [UIImage imageNamed:@"call_request"];
//    }else if([type isEqualToString:STATE_REFUSE]){
//        image = [UIImage imageNamed:@"call_refuse"];
//    }else if([type isEqualToString:STATE_ONCALL]){
//        image = [UIImage imageNamed:@"call_oncall"];
//    }else if([type isEqualToString:STATE_TIMEOUT]){
//        image = [UIImage imageNamed:@"call_timeout"];
//    }else if([type isEqualToString:STATE_UNSUPPORTED]){
//        image = [UIImage imageNamed:@"call_unsupported"];
//    }else if([type isEqualToString:STATE_HANGUP]){
//        image = [UIImage imageNamed:@"call_hangup"];
//    }
//    
//    return image;
//}
//
//+ (GALLangData *) getMainLangData:(NSMutableArray *) langList {
//    
//    if(langList == nil)
//        return nil;
//    
//    GALLangData *tempLang = nil;
//    
//    for(NSObject *obj in langList){
//        GALLangData *langData = [GALLangData new];
//        [langData injectFromObject:obj arrayClass:[GALLangData class]];
//        
//        if([@"T" isEqualToString:[langData is_main]]){
//            tempLang = langData;
//        }
//    }
//    
//    if(tempLang == nil){
//        for(NSObject *obj in langList){
//            GALLangData *langData = [GALLangData new];
//            [langData injectFromObject:obj arrayClass:[GALLangData class]];
//            
//            if([@"L" isEqualToString:[langData lang_mode]]){
//                tempLang = langData;
//                return tempLang;
//            }
//        }
//    }
//    
//    return tempLang;
//}
//
//+ (NSMutableArray *) getLangListWithOutMain:(NSMutableArray *) langList withLangMain:(GALLangData *)main{
//    
//    NSMutableArray *tempArray = [NSMutableArray array];
//    
//    NSString *langMode = main.lang_mode;
//    
//    for(NSObject *obj in langList){
//        GALLangData *langData = [GALLangData new];
//        [langData injectFromObject:obj arrayClass:[GALLangData class]];
//        
//        if([langMode isEqualToString:[langData lang_mode]]){
//            if(![[main lang_code] isEqualToString:[langData lang_code]]){
//                [tempArray addObject:langData];
//            }
//        }
//    }
//    
//    return tempArray;
//}
//
//+ (GALLangData *) getSearchLangData:(NSMutableArray *) langList withLangMode:(NSString *)mode withLangCode:(NSString *)code{
//    
//    if(langList == nil)
//        return nil;
//    
//    GALLangData *tempLang = nil;
//    
//    for(NSObject *obj in langList){
//        GALLangData *langData = [GALLangData new];
//        [langData injectFromObject:obj arrayClass:[GALLangData class]];
//        
//        if([mode isEqualToString:[langData lang_mode]]){
//            if([code isEqualToString:[langData lang_code]]){
//                tempLang = langData;
//            }
//        }
//    }
//    
//    return tempLang;
//}

+ (CGSize) getLabelHeightwithContents:(NSString *)contents withFontSize:(CGFloat)fontSize{
    return [GALangtudyUtils getLabelHeightwithWidth:320.0f withContents:contents withFontSize:fontSize];
}

+ (CGSize) getLabelHeightwithWidth:(CGFloat) width withContents:(NSString *)contents withFontSize:(CGFloat)fontSize{
    
    CGSize textSize = CGSizeZero;
    
    if(IS_IOS7_OR_LATER){
        NSDictionary *attributesDictionary = [ NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:fontSize], NSFontAttributeName,
                                              UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
                                              nil ];
        CGRect rectText = [contents boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributesDictionary
                                                 context:nil];
        textSize = rectText.size;
    }else{
        textSize = [contents sizeWithFont:[UIFont fontWithName:@"Helvetica" size:fontSize]
                        constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    }
    return textSize;
}

+ (BOOL) isNull:(NSString *)str{

    if(str == nil || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]){
        return YES;
    }else{
        return NO;
    }
}


//+ (NSString *) getCancelReasonName:(NSString *)value{
//
//    NSArray *imageTypeArray = [[NSArray alloc] initWithObjects:kCancelResonValue];
//    NSInteger pos = -1;
//    
//    for(NSInteger i=0; i<imageTypeArray.count; i++){
//        if([value isEqualToString:[imageTypeArray objectAtIndex:i]]){
//            pos = i;
//        }
//    }
//    
//    switch (pos) {
//        case 0:
//            return LSSTRING(@"cancel_reason_01");
//            
//        case 1:
//            return LSSTRING(@"cancel_reason_02");
//            
//        case 2:
//            return LSSTRING(@"cancel_reason_03");
//            
//        case 3:
//            return LSSTRING(@"cancel_reason_04");
//            
//        default:
//            return LSSTRING(@"cancel_reason_05");
//    }
//    
//}


+ (NSString *) getLocationString:(NSInteger) pos{
    
    switch (pos) {
        case 0:
            return LSSTRING(@"all");
            
        case 1:
            return LSSTRING(@"africa");
            
        case 2:
            return LSSTRING(@"antarctica");
            
        case 3:
            return LSSTRING(@"asia");
            
        case 4:
            return LSSTRING(@"australia");
            
        case 5:
            return LSSTRING(@"europe");
            
        case 6:
            return LSSTRING(@"north_america");
        
        case 7:
            return LSSTRING(@"south_america");
            
        default:
            return LSSTRING(@"all");
    }
}

+ (NSString *) getLocationCode:(NSInteger) pos{
    
    switch (pos) {
        case 0:
            return @"ALL";
            
        case 1:
            return @"AF";
            
        case 2:
            return @"AN";
            
        case 3:
            return @"AS";
            
        case 4:
            return @"OC";
            
        case 5:
            return @"EU";
            
        case 6:
            return @"NA";
            
        case 7:
            return @"SA";
            
        default:
            return @"ALL";
    }
}

+ (NSString *) getLevelName:(NSInteger) pos{
    
    switch (pos) {
        case 0:
            return LSSTRING(@"all");
            
        case 1:
            return LSSTRING(@"beginner");
            
        case 2:
            return LSSTRING(@"pre_intermediate");
            
        case 3:
            return LSSTRING(@"intermediate");
            
        case 4:
            return LSSTRING(@"upper_intermediate");
            
        case 5:
            return LSSTRING(@"advanced");
            
        default:
            return LSSTRING(@"all");
    }
}

    
#pragma mark - Image Rotate Function

+ (UIImage *)scaleAndRotateImage:(UIImage *)image orientation:(UIImageOrientation) orientation {
    int kMaxResolution = MAX ( image.size.width, image.size.height ); // Or whatever
    return [GALangtudyUtils scaleAndRotateImage:image orientation:orientation withMaxResolution:kMaxResolution];
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image orientation:(UIImageOrientation) orientation withMaxResolution:(int)kMaxResolution {
    CGImageRef imgRef = image . CGImage ;
    CGFloat width = CGImageGetWidth ( imgRef );
    CGFloat height = CGImageGetHeight ( imgRef );
    CGAffineTransform transform = CGAffineTransformIdentity ;
    CGRect bounds = CGRectMake ( 0 , 0 , width , height );
    if ( width > kMaxResolution || height > kMaxResolution ) {
        CGFloat ratio = width / height ;
        if ( ratio > 1 ) {
            bounds.size.width = kMaxResolution ;
            bounds.size.height = roundf ( bounds.size.width / ratio );
        }else {
            bounds.size.height = kMaxResolution ;
            bounds.size.width = roundf ( bounds.size.height * ratio );
        }
    }
    CGFloat scaleRatio = bounds.size.width / width ;
    CGSize imageSize = CGSizeMake ( CGImageGetWidth ( imgRef ), CGImageGetHeight ( imgRef ));
    CGFloat boundHeight ;
    switch ( orientation ) {
        case UIImageOrientationUp : //EXIF = 1
            transform = CGAffineTransformIdentity ;
            break ;
        case UIImageOrientationUpMirrored : //EXIF = 2
            transform = CGAffineTransformMakeTranslation ( imageSize.width , 0.0 );
            transform = CGAffineTransformScale ( transform , - 1.0 , 1.0 );
            break ;
        case UIImageOrientationDown : //EXIF = 3
            transform = CGAffineTransformMakeTranslation ( imageSize.width , imageSize.height );
            transform = CGAffineTransformRotate ( transform , M_PI );
            break ;
        case UIImageOrientationDownMirrored : //EXIF = 4
            transform = CGAffineTransformMakeTranslation ( 0.0 , imageSize.height );
            transform = CGAffineTransformScale ( transform , 1.0 , - 1.0 );
            break ;
        case UIImageOrientationLeftMirrored : //EXIF = 5
            boundHeight = bounds.size.height ;
            bounds.size.height = bounds.size.width ;
            bounds.size.width = boundHeight ;
            transform = CGAffineTransformMakeTranslation ( imageSize.height , imageSize.width );
            transform = CGAffineTransformScale ( transform , - 1.0 , 1.0 );
            transform = CGAffineTransformRotate ( transform , 3.0 * M_PI / 2.0 );
            break ;
        case UIImageOrientationLeft : //EXIF = 6
            boundHeight = bounds.size.height ;
            bounds.size.height = bounds.size.width ;
            bounds.size.width = boundHeight ;
            transform = CGAffineTransformMakeTranslation ( 0.0 , imageSize.width );
            transform = CGAffineTransformRotate ( transform , 3.0 * M_PI / 2.0 );
            break ;
        case UIImageOrientationRightMirrored : //EXIF = 7
            boundHeight = bounds.size.height ;
            bounds.size.height = bounds.size.width ;
            bounds.size.width = boundHeight ;
            transform = CGAffineTransformMakeScale ( - 1.0 , 1.0 );
            transform = CGAffineTransformRotate ( transform , M_PI / 2.0 );
            break ;
        case UIImageOrientationRight : //EXIF = 8
            boundHeight = bounds.size.height ;
            bounds.size.height = bounds.size.width ;
            bounds.size.width = boundHeight ;
            transform = CGAffineTransformMakeTranslation ( imageSize.height , 0.0 );
            transform = CGAffineTransformRotate ( transform , M_PI / 2.0 );
            break ;
        default:
            return image;
    }
    UIGraphicsBeginImageContext ( bounds.size );
    CGContextRef context = UIGraphicsGetCurrentContext ();
    if ( orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft ) {
        CGContextScaleCTM ( context , - scaleRatio , scaleRatio );
        CGContextTranslateCTM ( context , - height , 0 );
    }
    else {
        CGContextScaleCTM ( context , scaleRatio , - scaleRatio );
        CGContextTranslateCTM ( context , 0 , - height );
    }
    CGContextConcatCTM ( context , transform );
    CGContextDrawImage ( UIGraphicsGetCurrentContext (), CGRectMake ( 0 , 0 , width , height ), imgRef );
    UIImage * imageCopy = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return imageCopy ;
}


+ (BOOL) isWiFiConnect{
    
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (netStatus)
    {
    case NotReachable:
            return false;
    case ReachableViaWWAN:
            return false;
    case ReachableViaWiFi:
            return true;
            
        default:
            return false;
            
    }
}

+ (BOOL) isLTEConnect{
    
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
            return false;
        case ReachableViaWWAN:
            return true;
        case ReachableViaWiFi:
            return false;
            
        default:
            return false;
            
    }
}

+ (NSString *) getRoundString:(NSString *)str{
    
    if(str == nil)
        return @"";
    
    double temp = [str doubleValue];
    double tempDouble = round(temp * 10.0) / 10.0;
    
    return [NSString stringWithFormat:@"%.1f",tempDouble];
}

+ (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+ (NSString *) percentDecodingString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}


+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
{
    float oldHeight = sourceImage.size.height;
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = sourceImage.size.width* scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
