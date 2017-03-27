//
//  UIImageView+GALLangtudyEngine.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 22..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "UIImageView+GALLangtudyEngine.h"
#import "UIImageView+AFNetworking.h"


@implementation UIImageView (SDGoriEngine)

- (NSOperation *)setImageAndCacheWithURLString:(NSString *)url {
    return [self setImageAndCacheWithURLString:url placeholderImage:nil completionHandler:nil errorHandler:nil];
}

- (NSOperation *)setImageAndCacheWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    return [self setImageAndCacheWithURLString:url placeholderImage:placeholderImage completionHandler:nil errorHandler:nil];
}

- (NSOperation *)setImageAndCacheWithURLString:(NSString *)url
                              placeholderImage:(UIImage *)placeholderImage
                             completionHandler:(GALImageBlock)imageBlock
                                  errorHandler:(GALErrorBlock)errorBlock {
    
    //    __weak __typeof(self)weakSelf = self;
    //    [self setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //        if (imageBlock) {
    //            imageBlock(image, NO);
    //        }
    //        __strong __typeof(weakSelf)strongSelf = weakSelf;
    //        strongSelf.image = image;
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //        if (errorBlock) {
    //            errorBlock(nil, error);
    //        }
    //
    //    }];
    
    if (placeholderImage)
        self.image = placeholderImage;
    
    __weak __typeof(self)weakSelf = self;
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    return [engine getImageWithUrl:url completionHandler:^(UIImage *image, BOOL isInCache) {
        if (imageBlock) {
            imageBlock(image, isInCache);
        }
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.image = image;
    } errorHandler:errorBlock];
}

@end
