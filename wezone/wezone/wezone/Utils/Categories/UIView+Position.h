//
//  UIView+Position.h
//  IdeaPlaza
//
//  Created by sumin on 13. 6. 20..
//  Copyright (c) 2013년 스마트개발팀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

@property (nonatomic) CGPoint	frameOrigin;
@property (nonatomic) CGSize	frameSize;

@property (nonatomic) CGFloat	frameX;
@property (nonatomic) CGFloat	frameY;

@property (nonatomic) CGFloat	frameRight;
@property (nonatomic) CGFloat	frameBottom;

@property (nonatomic) CGFloat	frameWidth;
@property (nonatomic) CGFloat	frameHeight;

@end
