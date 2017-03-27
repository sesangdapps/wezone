
#import "GALActivityIndicator.h"

static GALActivityIndicator *_sharedActivityIndicator;

@interface GALActivityIndicator () {
    int displayCount;
}
@property (nonatomic, retain) UIView *activityView;
@property (nonatomic, retain) UIImageView *imgView;

@end

@implementation GALActivityIndicator

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (id)init
{
    self = [super init];
    if (self) {
        displayCount = 0;
    }
    return self;
}

- (void)show {
    if (self.activityView == nil) {
        //
        //  UIViewController+OverlayView.m
        //  IdeaPlaza
        //
        //  Created by sumin on 13. 6. 13..
        
        UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
//        UIImageView *mBgImgView = [[UIImageView alloc] initWithFrame:wrapView.bounds];
//        [mBgImgView setImage:[UIImage imageNamed:@"loading_bg_120.png"]];

        NSArray *aniArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"animat_langcoin_01.png"],
                           [UIImage imageNamed:@"animat_langcoin_02.png"],
                           [UIImage imageNamed:@"animat_langcoin_03.png"],
                           nil];

        
        self.imgView = [[UIImageView alloc] initWithFrame:wrapView.bounds];
        self.imgView.animationImages = aniArray;
        self.imgView.animationRepeatCount = 0;
        self.imgView.animationDuration = 0.5f;
//        [mImgView setImage:[UIImage imageNamed:@"icon.png"]];
        
//        [wrapView addSubview:mBgImgView];
        [wrapView addSubview:self.imgView];

        [self.imgView startAnimating];
        
//        NSMutableArray* keyFrameValues = [NSMutableArray array];
//        [keyFrameValues addObject:[NSNumber numberWithFloat:0.0]];
//        [keyFrameValues addObject:[NSNumber numberWithFloat:M_PI]];
////        [keyFrameValues addObject:[NSNumber numberWithFloat:M_PI*1.5]];
//        [keyFrameValues addObject:[NSNumber numberWithFloat:M_PI*2.0]];
//        
//        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//        [animation setValues:keyFrameValues];
//        [animation setValueFunction:[CAValueFunction functionWithName: kCAValueFunctionRotateY]];// kCAValueFunctionRotateZ]];
//        [animation setDuration:0.8];
//        [animation setRepeatCount:MAXFLOAT];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        [mImgView.layer addAnimation:animation forKey:@"transform.rotation"];
        
        self.activityView = wrapView;
        [self addSubview:self.activityView];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        self.activityView.layer.opacity = 0.1f;
        self.activityView.layer.transform = CATransform3DMakeScale(0.9f, 0.9f, 1.0);
        self.activityView.center = CGPointMake(self.bounds.size.width / 2,  self.bounds.size.height / 2);
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
            self.activityView.layer.opacity = 1.0f;
            self.activityView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        } completion:NULL];
    }
    
    @synchronized(self) {
        displayCount ++;
    }
}

- (void)hide {
    @synchronized(self) {
        --displayCount;
    }
    
    if (displayCount < 1) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
            self.activityView.layer.opacity = 0.1f;
            self.activityView.layer.transform = CATransform3DMakeScale(0.9f, 0.9f, 1.0);
        } completion:^(BOOL finished) {
            [self.imgView stopAnimating];
            self.imgView = nil;
            [self.activityView removeFromSuperview];
            self.activityView = nil;
            [self removeFromSuperview];
        }];
    }
}


@end
