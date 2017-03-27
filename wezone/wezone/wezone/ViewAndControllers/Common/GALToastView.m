//
//  SDToastView.m
//  ShinhanGori
//
//  Created by sumin on 2014. 2. 12..
//  Copyright (c) 2014년 SDS 스마트개발센터. All rights reserved.
//

#import "GALToastView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GALToastView {
    UIImageView *toastBgImageView;
    UIButton *toastBgButton;
    UIImageView *toastIconView;
    UILabel *titleLabel;
    UILabel	*toastLabel;
    UIButton *moveButton;
    UIButton *closeButton;
    NSTimer* timer;
}

static GALToastView *_sharedInstance = nil;

+ (GALToastView*)toastView
{
    static id _sharedInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GALToastView alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        toastBgImageView = [[UIImageView alloc] init];
        toastBgButton = [[UIButton alloc] init];
        toastIconView = [[UIImageView alloc] init];
        titleLabel	= [[UILabel alloc] init];
        toastLabel	= [[UILabel alloc] init];
        moveButton = [[UIButton alloc] init];
        closeButton = [[UIButton alloc] init];
        [closeButton addTarget:self action:@selector(__hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/*
 * Abstract HToast Show
 */
- (void)__show {
    if (timer)
        [self stopTImer];

    [UIView beginAnimations:@"Show" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDidStopSelector:@selector(__animationDidStop:finished:context:)];
    [self setAlpha:1.0f];
    [UIView commitAnimations];

}

-(void)stopTImer
{
    [timer invalidate];
    timer = nil;
}
/*
 * Abstract HToast Hide
 */
- (void)__hide {
	[UIView beginAnimations:@"Hide" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDidStopSelector:@selector(__animationDidStop:finished:context:)];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
}

/*
 * Abstract UIView AnimationDidStopSelector
 */
- (void)__animationDidStop:(NSString *)aAnimationID finished:(NSNumber *)aFinished context:(void *)aContext {
	/* aAnimationID이 @"Show"인경우 1.5초뒤에 Hide하고 @"Hide"인경우 바로 Hide한다 */
	if ([aAnimationID isEqualToString:@"Show"]){
        timer = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(__hide) userInfo:nil repeats:NO];
    }
	else if ([aAnimationID isEqualToString:@"Hide"])
        [self removeFromSuperview];
}

- (void) onToastClick:(id)sender{
    
}

- (GALToastView *)__setViewWithIcon:(NSString *)img_url withImageIcon:(UIImage *)image Title:(NSString *)title Text:(NSString *)aText target:(id)aTarget selector:(SEL)aSelector{
    UIScreen		*mainScreen		= [UIScreen mainScreen];
    UIFont			*textFont		= [UIFont systemFontOfSize:12.0f];
    
    CGRect		toastFrame	= CGRectZero;
    toastFrame.origin.x		= 10.0f;
    toastFrame.origin.y     = 20.0f;
    toastFrame.size.width	= mainScreen.bounds.size.width - 30.0f;
    toastFrame.size.height	= 80.0f;
    
    GALToastView	*toast = [GALToastView toastView];
    [toast setFrame:toastFrame];
    [toastBgImageView setFrame:toastFrame];
    [toastBgImageView setImage:[UIImage imageNamed:@"message_pupup"]];
    [toast addSubview:toastBgImageView];
    
    [toastIconView setFrame:CGRectMake(12.0f, 22.0f, 36.0f, 36.0f)];
    
    if(img_url != nil){
        NSString *fullUrl = [NSString stringWithFormat:@"%@%@",SERVICE_FILE_URL,img_url];
        [toastIconView setImageAndCacheWithURLString:fullUrl placeholderImage:[UIImage imageNamed:@"nopicture"]];
        [toast addSubview:toastIconView];
    }else{
        [toastIconView setImage:image];
    }
    
    CGRect labelFrame = CGRectMake(57.0f, 0.0f, toastFrame.size.width - 100.0f, 30.0f);
    NSInteger numberOfLine = 2;
    
    if(title != nil){
        labelFrame.origin.y = 22.0f;
        [titleLabel setFrame:labelFrame];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:textFont];
        //[titleLabel setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        [titleLabel setTextColor:UIColorFromRGB(0x3DB57D)];
        [titleLabel setNumberOfLines:numberOfLine];
        [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleLabel setText:title];
        [toast addSubview:titleLabel];
        labelFrame.origin.y += 18.0f;
    }else{
        
        labelFrame.size.height = toast.bounds.size.height;
        //        numberOfLine = 0;
    }
    
    [toastLabel setFrame:labelFrame];
    [toastLabel setFont:textFont];
    [toastLabel setTextColor:[UIColor grayColor]];
    [toastLabel setNumberOfLines:numberOfLine];
    [toastLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [toastLabel setText:aText];
    [toast addSubview:toastLabel];
    //	[toast setAlpha:0.0f];
    
    
    
    if(aSelector != nil){
        
        CGRect moveBtnFrame = CGRectMake(toastFrame.size.width - 50.0f - 10.0f - 30.0f, 60.0f, 30.0f, 30.0f);
        
        [toastBgButton setFrame:moveBtnFrame];
        [toastBgButton setBackgroundColor:[UIColor clearColor]];
        
        [toastBgButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [toastBgButton addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
        [toastBgButton setTitle:LSSTRING(@"move") forState:UIControlStateNormal];
        toastBgButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [toastBgButton.titleLabel setFont:textFont];
        [toastBgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [toast addSubview:toastBgButton];
    }
    
    [closeButton setFrame:CGRectMake(toastFrame.size.width - 50.0f, 60.0f, 30.0f, 30.0f)];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    [closeButton setTitle:LSSTRING(@"close") forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:textFont];
    closeButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [toast addSubview:closeButton];
    
    toast.layer.shadowColor = [[UIColor blackColor] CGColor];
    toast.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    toast.layer.shadowRadius = 2.0f;
    toast.layer.shadowOpacity = 1.0f;
    
    return toast;
}

- (GALToastView *)__setViewWithIcon:(UIImage *)icon Title:(NSString *)title Text:(NSString *)aText target:(id)aTarget selector:(SEL)aSelector{
	return [self __setViewWithIcon:nil withImageIcon:icon Title:title Text:aText target:aTarget selector:aSelector];
}


+ (GALToastView *)__createViewWithText:(NSString *)aText originY:(CGFloat)aOriginY {
	UIScreen		*mainScreen		= [UIScreen mainScreen];
	NSLineBreakMode	lineBreakMode	= NSLineBreakByWordWrapping;
    
	CGFloat			widthMargin		= 10.0f;
	UIFont			*textFont		= [UIFont systemFontOfSize:14.0f];
	CGSize			textSize		= [aText sizeWithFont:textFont constrainedToSize:CGSizeMake(mainScreen.bounds.size.width - widthMargin*2, 9999.0f) lineBreakMode:lineBreakMode];
	
	CGRect		toastFrame	= CGRectZero;
	toastFrame.size.width	= mainScreen.bounds.size.width - widthMargin*2;
	toastFrame.size.height	= MAX(textSize.height + 20.0f, 38.0f);
	toastFrame.origin.x		= widthMargin;
	if (aOriginY == -1.0f)	toastFrame.origin.y	= mainScreen.bounds.size.height - toastFrame.size.height - 15.0f;
	else					toastFrame.origin.y	= aOriginY;
	
	GALToastView	*toast	= [[GALToastView alloc] initWithFrame:toastFrame];
	[toast setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f]];
	[toast.layer setMasksToBounds:YES];
	[toast.layer setCornerRadius:5.0f];
	
	UILabel	*toastLabel	= [[UILabel alloc] initWithFrame:toast.bounds];
	[toastLabel setBackgroundColor:[UIColor clearColor]];
	[toastLabel setTextAlignment:NSTextAlignmentCenter];
	[toastLabel setFont:textFont];
	[toastLabel setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
	[toastLabel setNumberOfLines:0];
	[toastLabel setLineBreakMode:lineBreakMode];
	[toastLabel setText:aText];
	[toast addSubview:toastLabel];
	[toast setAlpha:0.0f];
	
	return toast;
}

- (void)showWithImageUrl:(NSString *)aImgUrl Title:(NSString *)aTitle Text:(NSString *)aText target:(id)aTarget selector:(SEL)aSelector{
    GALToastView *toast = [GALToastView toastView];
    toast = [self __setViewWithIcon:aImgUrl withImageIcon:nil Title:aTitle Text:aText target:aTarget selector:aSelector];
    //UIWindow	*keyWindow	= [[UIApplication sharedApplication] keyWindow];
    UIWindow	*topWindow	= [[[UIApplication sharedApplication] windows] lastObject];
    [topWindow addSubview:toast];
    [self __show];
}

- (void)showWithIcon:(UIImage *)aIcon Title:(NSString *)aTitle Text:(NSString *)aText target:(id)aTarget selector:(SEL)aSelector{
    GALToastView *toast = [GALToastView toastView];
    toast = [self __setViewWithIcon:aIcon Title:aTitle Text:aText target:aTarget selector:aSelector];
    //UIWindow	*keyWindow	= [[UIApplication sharedApplication] keyWindow];
    UIWindow	*topWindow	= [[[UIApplication sharedApplication] windows] lastObject];
    [topWindow addSubview:toast];
    [self __show];
}

+ (void)showWithIcon:(UIImage *)aIcon Title:(NSString *)aTitle Text:(NSString *)aText{
//    [self showWithIcon:aIcon Title:aTitle Text:aText target:nil selector:nil];
}

+ (void)showWithText:(NSString *)aText originY:(CGFloat)aOriginY {
	GALToastView		*toast		= [self __createViewWithText:aText originY:aOriginY];
	//UIWindow	*keyWindow	= [[UIApplication sharedApplication] keyWindow];
	UIWindow	*topWindow	= [[[UIApplication sharedApplication] windows] lastObject];
	[topWindow addSubview:toast];
	[toast __show];
}

+ (void)showWithText:(NSString *)aText {
	[self showWithText:aText originY:-1.0f];
}

@end
