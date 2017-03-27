//
//  AESExtention.h
//  NationalAssembleSystem
//
//  Created by KwangKuk Jung on 11. 8. 23..
//  Copyright 2011 Wide-Wit. All rights reserved.
//

#import <Foundation/Foundation.h>
                          
@interface AESExtention : NSObject {

}

+ (instancetype)sharedAESExtention;
+ (instancetype)userAESExtention:(NSString *)userCn;

- (NSString *)getHashKeyWith:(NSString *)str;

- (NSData *)aes128EncryptWithData:(NSData *)data;
- (NSData *)aes128DecryptWithData:(NSData *)data;

- (NSString *)aes128EncryptString:(NSString*)textString;
- (NSString *)aes128DecryptString:(NSString*)textString;

- (NSString *)aes256EncryptString:(NSString*)textString;
- (NSString *)aes256DecryptString:(NSString*)textString;

@end
