//
//  UIView+Layout.m
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "UIView+Layout.h"
#import "Layout.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
#pragma clang diagnostic ignored "-Wnonnull"


@implementation UIView (Layout)

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag {
    
    self = [self init];
    [self setFrame:rect];
    if ( tag > 0 ) {
        [self setTag:tag];
    }
    if ( parent ) {
        [parent addSubview:self];
    }    
    return self;
}

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color {
    
    self = [self init:rect parent:parent tag:tag];
    if ( color ) {
        [self setBackgroundColor:color];
    }
    return self;
}

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
        
    self = [self init:rect parent:parent tag:tag color:color];
    if ( borderColor ) {
        self.layer.borderColor = [borderColor CGColor];
        self.layer.borderWidth = borderWidth / [Layout screenScale];
    }
    return self;
}

- (void)setX:(float)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(float)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setWidth:(float)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(float)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setPosition:(CGPoint)point {
    CGRect rect = self.frame;
    rect.origin = point;
    self.frame = rect;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)posLeft:(UIView *)view margin:(float)margin {
    
    if ( view ) {
        [self setX:view.frame.origin.x - self.frame.size.width - margin];
    }
}

- (void)posRight:(UIView *)view margin:(float)margin {
    
    if ( view ) {
        [self setX:view.frame.origin.x + view.frame.size.width + margin];
    }
}

- (void)posAbove:(UIView *)view margin:(float)margin {
    
    if ( view ) {
        [self setY:view.frame.origin.y - self.frame.size.height - margin];
    }
}

- (void)posBelow:(UIView *)view margin:(float)margin {
    
    if ( view ) {
        [self setY:view.frame.origin.y + view.frame.size.height + margin];
    }
}

- (void)posVerticalCenter:(UIView *)view {
    
    if ( view ) {
        [self setY:view.frame.origin.y + self.frame.size.height / 2 - self.frame.size.height / 2];
    }
}

- (void)posHorizontalCenter:(UIView *)view {
    
    if ( view ) {
        [self setX:view.frame.origin.x + view.frame.size.width / 2 - self.frame.size.width / 2];
    }
}

- (void)alignBottom:(UIView *)view margin:(float)margin {
    
    if ( view ) {
        [self setY:view.frame.size.height - self.frame.size.height - margin];
    }
}

- (void)alignRight:(UIView *)view margin:(float)margin {
    
    if ( view ) {
        [self setX:view.frame.size.width - self.frame.size.width - margin];
    }
}

- (void)sizeToFitWidth:(UIView *)view padding:(float)padding {
    
    if ( view ) {
        [self setWidth:view.frame.origin.x + view.frame.size.width + padding];
    }
}

- (void)sizeToFitHeight:(UIView *)view padding:(float)padding {

    if ( view ) {
        [self setHeight:view.frame.origin.y + view.frame.size.height + padding];
    }
}

- (void)setColor:(UIColor *)color {
    
    if ( color ) {
        [self setBackgroundColor:color];
    }
}

- (void)setBorder:(UIColor *)color width:(float)width corner:(float)corner {
    
   
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:width / [Layout screenScale]];
    [self.layer setCornerRadius:corner];
}

- (void)setShadow:(UIColor *)color opacity:(float)opacity radius:(float)radius {
  
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = color.CGColor;
}

- (void)addTarget:(id)target action:(SEL)action {
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesture];
}


+ (instancetype)makeHorizontalLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color {
    
    float h = rect.size.height / [Layout screenScale];
    rect.origin.y += rect.size.height - h / 2;
    rect.size.height = h;
    
    return [[UIView alloc] init:rect parent:parent tag:tag color:color];
}

+ (instancetype)makeTopLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color {
    
    float h = rect.size.height / [Layout screenScale];
    rect.size.height = h;
    
    rect.origin.y = floor(rect.origin.y);

    return [[UIView alloc] init:rect parent:parent tag:tag color:color];
}

+ (instancetype)makeBottomLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color {
    
    rect.origin.y = round(rect.origin.y);

    float h = rect.size.height / [Layout screenScale];
    rect.origin.y += rect.size.height - h;
    rect.size.height = h;
    
    rect.origin.y = floor(rect.origin.y);

    return [[UIView alloc] init:rect parent:parent tag:tag color:color];
}

+ (instancetype)makeVerticalLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color {
    
    float w = rect.size.width / [Layout screenScale];
    rect.origin.x += rect.size.width - w / 2;
    rect.size.width = w;
    
    return [[UIView alloc] init:rect parent:parent tag:tag color:color];
}

+ (instancetype)makeLeftLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color {
    
    float w = rect.size.width / [Layout screenScale];
    rect.size.width = w;
    
    return [[UIView alloc] init:rect parent:parent tag:tag color:color];
}

+ (instancetype)makeRightLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color {
    
    float w = rect.size.width / [Layout screenScale];
    rect.origin.x += rect.size.width - w;
    rect.size.width = w;
    
    return [[UIView alloc] init:rect parent:parent tag:tag color:color];
}

@end
#pragma clang diagnostic pop

//@interface UIScrollView(Layoyt)
//
//+ (UIScrollView *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag;
//+ (UIScrollView *)create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;
//+ (UIScrollView *)create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
//@end
//
//@interface UITableView(Layoyt)
//
//+ (UITableView *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag;
//+ (UITableView *)create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;
//+ (UITableView *)create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
//@end
//
//@interface UIImageView(Layout)
//
//+ (UIImageView *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag;
//+ (UIImageView *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag image:(UIImage *)image;
//+ (UIImageView *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag imageName:(NSString *)imageName;
//
//@end
//
//@interface UILabel(Layout)
//
//+ (UILabel *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag;
//+ (UILabel *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text color:(UIColor *)color bgColor:(UIColor *)bgColor align:(NSTextAlignment)align font:(NSString *)font size:(CGFloat)size;
//
//@end
//
//@interface UITextField(Layout)
//
//+ (UITextField *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag;
//+ (UITextField *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text placeholder:(NSString*)placeholder bgColor:(UIColor *)bgColor color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size;
//+ (UITextField *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text placeholder:(NSString*)placeholder bgImageName:(NSString *)bgImageName color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size;
//+ (UITextField *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text placeholder:(NSString*)placeholder bgImageName:(NSString *)bgImageName color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size type:(UIKeyboardType)type password:(BOOL)password delegate:(id<UITextFieldDelegate>)delegate;
//+ (UITextField *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text placeholder:(NSString*)placeholder bgImageName:(NSString *)bgImageName color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size type:(UIKeyboardType)type password:(BOOL)password delegate:(id<UITextFieldDelegate>)delegate rightImage:(NSString *)rightImage;
//@end
//
//
//@interface UIButton(Layout)
//
//+ (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag;
//+ (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag target:(id)target action:(SEL)selector;
//+ (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage target:(id)target action:(SEL)selector;
//+ (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName target:(id)target action:(SEL)selector;
//
//
//- (id) addImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage;
//- (id) addImage:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName;
//- (id) addBackgroundImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage;
//- (id) addBackgroundImage:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName;
//
//- (id) addTitle:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size;
//
//- (id) addAttributeTitle:(NSMutableAttributedString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size;
//
//- (void) setAttributeTitle:(NSMutableAttributedString *)title;
//- (void) setTitle:(NSString *)title;
//

/*
 + (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)selector;
 + (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)selector;
 + (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage title:(NSString *)title target:(id)target action:(SEL)selector;
 + (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)selector;
 
 + (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage title:(NSString *)title color:(UIColor *)color font:(NSString*)font size:(CGFloat)size target:(id)target action:(SEL)selector;
 
 + (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title color:(UIColor *)color font:(NSString*)font size:(CGFloat)size target:(id)target action:(SEL)selector;
 
 + (UIButton *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag title:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor font:(NSString*)font size:(CGFloat)size target:(id)target action:(SEL)selector;
 
 - (void) addTitle:title:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size;
 */
//@end
