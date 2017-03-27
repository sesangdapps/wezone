//
//  LocationDistanceViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "LocationDistanceViewController.h"

#import "NMapViewResources.h"
#import "LocationManager.h"
#import <NMapViewerSDK/NMapView.h>
#import "UIFont+Layout.h"

@interface DistanceSliderView ()
{
    CGRect _rect;
    int _index;
    DistanceValueChanged _valueChanged;
}
@end

@implementation DistanceSliderView

-(instancetype)init:(CGRect)rect index:(int)index valueChanged:(DistanceValueChanged)valueChanged {
    
    self = [self initWithFrame:rect];
    if ( self ) {
        
        _index = index;
        _valueChanged = valueChanged;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    _rect = rect;
    
    float scale = [Layout screenScale];
    float centerY = rect.origin.y + rect.size.height / 3;
    float imageGap = [Layout aspecValue:6];
    
    float lineH = [Layout aspecValue:4];
    float circleR = [Layout aspecValue:8];
    
    const NSArray *texts = @[@"200m", @"400m", @"1.6km", @"3.2km"];
    
    //_imgSize = CGSizeMake([Layout aspecValue:27], [Layout aspecValue:27]);
    //_minGap = 0.01;// / _rect.size.width * 2;
    //_rect = CGRectMake([Layout aspecValue:20] + _imgSize.width / 2, 0, rect.size.width - [Layout aspecValue:40] - _imgSize.width, rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0xffffff).CGColor);
    CGContextFillRect(context, rect);
    
    float w = rect.size.width / 4;
    float x = - w + w / 2;
    
    for( int i=0; i<5; i++ ) {
        
        if ( i <= _index ) {
            CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0x3f98b6).CGColor);
        } else {
            CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xcccccc).CGColor);
        }
        
        CGContextSetLineWidth(context, lineH);
        CGContextMoveToPoint(context, x + circleR, centerY);
        CGContextAddLineToPoint(context, x + rect.size.width / 4 - circleR, centerY);
        CGContextStrokePath(context);
     
        x += w;
    }
    
    x = w / 2;
    
    for( int i=0; i<4; i++ ) {
        
        if ( i <= _index ) {
            CGContextSetFillColorWithColor(context, UIColorFromRGB(0x3f98b6).CGColor);
        } else {
            CGContextSetFillColorWithColor(context, UIColorFromRGB(0xcccccc).CGColor);
        }

        CGRect circle = CGRectMake(x - circleR / 2, centerY - circleR / 2, circleR, circleR);
        CGContextAddEllipseInRect(context, circle);
        CGContextFillPath(context);
        
        [self drawText:texts[i] x:x y:centerY + circleR color:UIColorFromRGB(0x3f98b6) size:[Layout aspecValue:12]];
        
        x += w;
    }

    CGContextRestoreGState(context);
}

- (void)drawText:(NSString *)text x:(CGFloat)x y:(CGFloat)y color:(UIColor *)color size:(float)size {
    
    CGRect textRect = CGRectMake(x - 50, y, 100, 20);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont defalutFont:nil size:size], NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: textStyle};
    
    [text drawInRect: textRect withAttributes: textFontAttributes];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    [self checkIndex:touchLocation];
    
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    
//    _moveMinValue = NO;
//    _moveMaxValue = NO;
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    [self checkIndex:touchLocation];
 
    
//
//    if ( self.delegate ) {
//        [self.delegate siderValueChanged:self];
//    }
}

- (void)checkIndex:(CGPoint)touchLocation {
    
    float x = _rect.size.width - _rect.size.width / 8 - [Layout aspecValue:20];
    float w = _rect.size.width / 4;
    
    
    int index = -1;
    for( int i=0; i<4; i++ ) {
        if ( touchLocation.x >= x ) {
            index = 3 - i;
            break;
        }
        x -= w;
    }
    if ( index != -1 && index != _index ) {
        _index = index;
        [self setNeedsDisplay];
        if ( _valueChanged ) {
            _valueChanged(_index);
        }
    }
}

@end

@interface LocationDistanceViewController ()<NMapViewDelegate, NMapPOIdataOverlayDelegate>
{
    int _distance;
    LocationDistanceCompletionBlock _completion;
    NMapView *_mapView;
    DistanceSliderView *_distanceView;
    UIView *_rangeView;
    UILabel *_distanceLabel;
}
@end

@implementation LocationDistanceViewController

-(instancetype)init:(int)distance completion:(LocationDistanceCompletionBlock)completion {
    
    self = [self init];
    if ( self ) {
        
        _distance = distance;
        _completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LocationManager *locationManager = [LocationManager sharedLocationManager];
    
    if ( !locationManager.enableLocation ) {
        [locationManager requestLocation];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationChanged:) name: @"locationChanged" object: nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = UIColor_navi;
}

#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:YES title:nil bgColor:UIColor_main];
    [self makeLeftBackButton];
    [self makeRightButton:@"btn_check" target:self selector:@selector(onClickRegist)];
    
    float y = 0;
    float w = [Layout revert:self.bodyView.frame.size.width];
    float h = [Layout revert:self.bodyView.frame.size.height];
    float bottom = 100;
    
    _mapView = [[NMapView alloc] initWithFrame:[Layout aspecRect:CGRectMake(0, 0, w, h - bottom)]];
    [_mapView setDelegate:self];
    [_mapView setClientId:NAVER_CLIENT_ID];
    [self.bodyView addSubview:_mapView];
    
    float size = 100;
    
    [[UIView alloc] init:CGRectMake(0, 0, self.view.frame.size.width, [Layout statusHeight] + NAVI_HEIGHT) parent:self.view tag:0 color:UIColorFromRGBA(0x3f98b6aa)];
    
    // 마스크
    [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, h - bottom)] parent:self.bodyView tag:0 color:UIColorFromRGBA(0x3f98b688)];
    
    // 거리 범위를 정해 주세요.
    [[UILabel alloc] init:CGRectMake([Layout aspecValue:15], [Layout statusHeight] + NAVI_HEIGHT, self.bodyView.frame.size.width, [Layout aspecValue:30]) parent:self.bodyView tag:0 text:[self getStringWithKey:@"wezone_location_distance_desc"] color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentLeft font:@"bold" size:[Layout aspecValue:SIZE_TEXT_M]];
    
    // 거리
    const NSArray *texts = @[@"200", @"400", @"1.6K", @"3.2K"];
    
    _distanceLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, h - bottom - 60, size, 25)] parent:self.bodyView tag:0 text:texts[[self getDistanceIndex:_distance]] color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentLeft font:@"bold" size:[Layout aspecValue:[Layout aspecValue:24]]];
    
    // METER
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, h - bottom - 35, size, 15)] parent:self.bodyView tag:0 text:@"METER" color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:[Layout aspecValue:14]]];
    
    // 범위
    _rangeView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(w / 2 - size / 2, (h - bottom) / 2 - size / 2, size, size)] parent:self.bodyView tag:0 color:UIColorFromRGBA(0x3f98b699)];
    [_rangeView setBorder:UIColorFromRGBA(0xffffff99) width:3 corner:_rangeView.frame.size.width / 2];
    
    UIView *circle = [[UIView alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 10, (h - bottom) / 2 - 10, 20, 20)] parent:self.bodyView tag:0 color:UIColorFromRGB(0xffffff)];
    [circle setBorder:UIColorFromRGB(0xffffff) width:1 corner:circle.frame.size.width / 2];
    y += h - bottom;
    
    // 범위 지정
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, y + 10, w - 30, 30)] parent:self.bodyView tag:0 text:[self getStringWithKey:@"wezone_location_distance_range"] color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    y+= 30;
    
    _distanceView = [[DistanceSliderView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, bottom - 40)] index:[self getDistanceIndex:_distance] valueChanged:^(int index) {
        
        _distance = [self getDistance:index];
        _distanceLabel.text = texts[index];
        [self changeZoomLevel];
    }];
    
    [self.bodyView addSubview:_distanceView];
}

- (void) onClickRegist {
    
    if ( _completion ) {
        _completion(_distance);
    }
    [self goBack];
}

- (int) getDistanceIndex:(int)distance {
    
    if ( distance <= 200 ) return 0;
    else if ( distance <= 400 ) return 1;
    else if ( distance <= 1600 ) return 2;
    else return 3;
}


- (int) getDistance:(int)index {
    
    if ( index <= 0 ) return 200;
    else if ( index == 1 ) return 400;
    else if ( index == 2 ) return 1600;
    else return 3200;
}

- (void) locationChanged:(NSNotification *)notification {
    
    if ( _mapView ) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationChanged" object:nil];
        [_mapView setMapCenter:[self getLocation] atLevel:_mapView.zoomLevel];
    }
}

- (void)changeZoomLevel {
    
    NGeoPoint ngp = [self getLocation];
    
    int level = 12;
    float radius = _distance;
    if ( _distance == 200 ) {
        level = 12;
    } else if ( _distance == 400 ) {
        level = 11;
    } else if ( _distance == 1600 ) {
        level = 9;
    } else if ( _distance == 3200 ) {
        level = 8;
        
    }
    
    [_mapView setZoomLevel:level];
    
//    NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
//    [mapOverlayManager clearOverlays];
//    
//    NMapPathDataOverlay *pathDataOverlay = [mapOverlayManager newPathDataOverlay:[[NMapPathData alloc] init]];
//    
//    NMapCircleData *circleData1 = [[NMapCircleData alloc] initWithCapacity:1];
//    [circleData1 initCircleData];
//    [circleData1 addCirclePointLongitude:ngp.longitude latitude:ngp.latitude radius:radius];
//    
//    NMapCircleStyle *circleStyle1 = [[NMapCircleStyle alloc] init];
//    [circleStyle1 setLineType:NMapPathLineTypeDash];
//    [circleData1 setCircleStyle:circleStyle1];
//    [circleData1 endCircleData];
//    
//    [pathDataOverlay addCircleData:circleData1];
//    [pathDataOverlay showAllPathDataAtLevel:level];
    
    float point = [_mapView metersToPoints:radius];
    NSLog(@"point : %f", point);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_rangeView setSize:CGSizeMake(point * 2, point * 2)];
        [_rangeView setCenter:_mapView.center];
        [_rangeView setBorder:UIColorFromRGBA(0xffffff99) width:3 corner:_rangeView.frame.size.width / 2];
        
    });
}


- (NGeoPoint) getLocation {
    
    NGeoPoint ngp = NGeoPointMake(126.978371, 37.5666091);
    LocationManager *locationManager = [LocationManager sharedLocationManager];
    //        if ( locationManager.enableLocation && locationManager.hasLocationInfo ) {
    //            ngp = NGeoPointMake(locationManager.longitude, locationManager.latitude);
    //        }
    
    return ngp;
}

#pragma mark -
#pragma mark NMapViewDelegate

- (void) onMapView:(NMapView *)mapView initHandler:(NMapError *)error {
    
    if (error == nil) { // success
        
        NGeoPoint ngp = [self getLocation];
        [_mapView setMapCenter:ngp atLevel:11];
        
        [self changeZoomLevel];
//
//        NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
//        [mapOverlayManager clearOverlays];
//        
//        NMapPathDataOverlay *pathDataOverlay = [mapOverlayManager newPathDataOverlay:[[NMapPathData alloc] init]];
//        
//        // add circle data
//        NMapCircleData *circleData1 = [[NMapCircleData alloc] initWithCapacity:1];
//        [circleData1 initCircleData];
//        [circleData1 addCirclePointLongitude:ngp.longitude latitude:ngp.latitude radius:400.0F];
//        // set circle style
//        NMapCircleStyle *circleStyle1 = [[NMapCircleStyle alloc] init];
//        [circleStyle1 setLineType:NMapPathLineTypeDash];
//        [circleData1 setCircleStyle:circleStyle1];
//        [circleData1 endCircleData];
//        
//        [pathDataOverlay addCircleData:circleData1];
//        [pathDataOverlay showAllPathDataAtLevel:11];
//        
//        float point = [_mapView metersToPoints:400];
//        NSLog(@"point : %f", point);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [_rangeView setSize:CGSizeMake(point * 2, point * 2)];
//            [_rangeView setCenter:_mapView.center];
//            [_rangeView setBorder:UIColorFromRGBA(0xffffff99) width:3 corner:_rangeView.frame.size.width / 2];
//            
//        });
//        NSLog(@"point : %f", point);
        
    } else {
        NSLog(@"onMapView:initHandler: %@", [error description]);
    }
}

#pragma mark NMapPOIdataOverlayDelegate

- (UIImage *) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForOverlayItem:(NMapPOIitem *)poiItem selected:(BOOL)selected {
    return [NMapViewResources imageWithType:poiItem.poiFlagType selected:selected];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay anchorPointWithType:(NMapPOIflagType)poiFlagTyp{
    return [NMapViewResources anchorPoint:poiFlagTyp];
}

- (UIView *)onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay viewForCalloutOverlayItem:(NMapPOIitem *)poiItem
         calloutPosition:(CGPoint *)calloutPosition
{
    //    calloutPosition->x = roundf((self.calloutView.bounds.size.width)/2) + 1;
    //    self.calloutLabel.text = poiItem.title;
    //    return self.calloutView;
    return nil;
}

- (UIImage*) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForCalloutOverlayItem:(NMapPOIitem *)poiItem constraintSize:(CGSize)constraintSize selected:(BOOL)selected imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect {
    return nil;
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay calloutOffsetWithType:(NMapPOIflagType)poiFlagType {
    return CGPointMake(0.5, 1.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
