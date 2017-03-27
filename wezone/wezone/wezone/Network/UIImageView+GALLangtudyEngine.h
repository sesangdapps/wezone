//
//  UIImageView+GALLangtudyEngine.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 22..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GALLangtudyEngine)

- (NSOperation *)setImageAndCacheWithURLString:(NSString *)url;

- (NSOperation *)setImageAndCacheWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

- (NSOperation *)setImageAndCacheWithURLString:(NSString *)url
                              placeholderImage:(UIImage *)placeholderImage
                             completionHandler:(GALImageBlock)imageBlock
                                  errorHandler:(GALErrorBlock)errorBlock;

@end
