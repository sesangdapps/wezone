//
//  LocationTypeViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "LocationTypeViewController.h"
#import "LocationDistanceViewController.h"

@interface LocationTypeViewController ()
{
    NSString *_title;
    WezoneModel *_wezone;
    
    LocationTypeCompletionBlock _completion;
    NSString *_locationType;
    NSString *_value;
}
@end

@implementation LocationTypeViewController

-(instancetype)init:(NSString *)title wezone:(WezoneModel *)wezone completion:(LocationTypeCompletionBlock)completion {
    
    self = [self init];
    if ( self ) {
        
        _title = title;
        _wezone = wezone;
        _completion = completion;
        
        _locationType = _wezone.location_type;
        if ( [_locationType isEqualToString:@"G"] ) {
            _value = _wezone.location_data;
        } else {
            _value = @"";
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:NO title:_title bgColor:UIColor_main];
    [self makeLeftBackButton];
    [self makeRightButton:@"btn_check" target:self selector:@selector(onClickRegist)];
    
    float y = 0;
    float line = 50;
    float w = [Layout revert:self.bodyView.frame.size.width];
    
    NSString *location_data = [NSString stringWithFormat:@"%@m", [CommonUtil moneyFormat:[_wezone.location_data intValue] maxFraction:0]];
    if ( [_wezone.location_data intValue] >= 1000 ) {
        location_data = [NSString stringWithFormat:@"%@km", [CommonUtil moneyFormat:(float)[_wezone.location_data intValue] / 1000 maxFraction:1]];
    }
    y += [self makeArrowLine:[self getStringWithKey:@"wezone_location_type_gps"] content:location_data icon:nil parent:self.bodyView tag:10 x:0 y:0 w:w h:line selector:@selector(onClickGPS:)];
    
    
    NSString *beacon = [self getStringWithKey:@"not_use"];
    y += [self makeArrowLine:[self getStringWithKey:@"wezone_location_type_beacon"] content:beacon icon:nil parent:self.bodyView tag:20 x:0 y:y w:w h:line selector:@selector(onClickBeacon:)];
}

- (float)makeArrowLine:(NSString *)title content:(NSString *)content icon:(NSString *)icon parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w h:(float)h selector:(SEL)selector {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:tag color:UIColor_main];
    [view addTarget:self action:selector];
    
    if ( icon ) {
        [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (h - 25) / 2, 25, 25)] parent:view tag:0 imageName:icon];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(45, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    } else {
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    }
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2, 0, w / 2 - 45, h)] parent:view tag:tag + 2 text:content color:UIColor_sub_text bgColor:nil align:NSTextAlignmentRight font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 40, (h - 25) / 2, 25, 25)] parent:view tag:tag + 3 target:self action:selector] addImageName:@"btn_chevron_right_black"];
    
    [view setHeight:[Layout aspecValue:h]];
    
    [UIView makeBottomLine:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1) parent:view tag:tag + 4 color:UIColor_line];
    
    return h;
}

- (void)onClickGPS:(id)sender {
    
    LocationDistanceViewController *vc = [[LocationDistanceViewController alloc] init:[_wezone.location_data intValue] completion:^(int distance) {
        
        UILabel *label1 = [[self.bodyView viewWithTag:10] viewWithTag:10 + 2];
        UILabel *label2 = [[self.bodyView viewWithTag:20] viewWithTag:20 + 2];
        
        _locationType = @"G";
        _value = [NSString stringWithFormat:@"%d", distance];
        
        if ( distance >= 1000 ) {
            label1.text = [NSString stringWithFormat:@"%@km", [CommonUtil moneyFormat:(float)distance / 1000 maxFraction:1]];
        } else {
            label1.text = [NSString stringWithFormat:@"%@m", [CommonUtil moneyFormat:distance maxFraction:0]];
        }
        label2.text = [self getStringWithKey:@"not_use"];
        
    }];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickBeacon:(id)sender {
    
}

- (void)onClickRegist {

    if ( _completion ) {
        _completion(_locationType, _value);
    }
    [self goBack];
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
