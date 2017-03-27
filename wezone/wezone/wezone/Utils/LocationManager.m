//
//  LocationManager.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 14..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "LocationManager.h"

#define GPS_UPLOAD_INTERVAL     5 * 60

@implementation LocationManager

+ (instancetype)sharedLocationManager {
    
    static id _sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[super alloc] init];
    });
    return _sharedLocationManager;
}

-(instancetype)init {
    
    self = [super init];
    
    if ( self ) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterBackground:) name: @"applicationDidEnterBackground" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationWillEnterForeground:) name: @"applicationWillEnterForeground" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidBecomeActive:) name: @"applicationDidBecomeActive" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationWillTerminate:) name: @"applicationWillTerminate" object: nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didReceiveRemoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationWillEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationWillTerminate" object:nil];
}

// 위치정보 요청
- (BOOL) requestLocation {
    
    if ( ![CLLocationManager locationServicesEnabled] ) {
        self.enableLocation = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName: @"locationChanged" object: nil userInfo:nil];
        return NO;
    }
    self.enableLocation = YES;
    
    if ( self.locationManager ) {
        self.locationManager.delegate = nil;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//        self.locationManager.allowsBackgroundLocationUpdates = YES;
//    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
            //case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            [GALangtudyUtils showAlertWithButtons:@[@"확인", @"취소"] message:@"위치정보를 사용 할 수 없습니다.\n설정화면으로 이동하시겠습니까?" close:^(int buttonIndex) {
                
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else {
                    self.enableLocation = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"locationChanged" object: nil userInfo:nil];
                }
            }];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:
            [self.locationManager startUpdatingLocation];
            break;
    }
    return YES;
}

// 위치정보 사용 권한 요청
- (BOOL) requestLocationPermission {
    
    if ( self.locationManager ) {
        self.locationManager.delegate = nil;
    }
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//        self.locationManager.allowsBackgroundLocationUpdates = YES;
//    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
            //case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            
            [GALangtudyUtils showAlertWithButtons:@[@"확인", @"취소"] message:@"위치정보를 사용 할 수 없습니다.\n설정화면으로 이동하시겠습니까?" close:^(int buttonIndex) {
                
                if(buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else {
                    self.enableLocation = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"locationChanged" object: nil userInfo:nil];
                }
            }];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
            
        default:
            break;
    }
    return YES;
}

#pragma mark - CLLocationManagerDelegate

-(void)sopGpsProcess {
    
    if ( self.gpsUpdateTimer ) {
        [self.gpsUpdateTimer invalidate];
        self.gpsUpdateTimer = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    switch (status) {
            //        case kCLAuthorizationStatusNotDetermined:
            //        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            [self sopGpsProcess];
            
            [GALangtudyUtils showAlertWithButtons:@[@"확인", @"취소"] message:@"위치정보를 사용 할 수 없습니다.\n설정화면으로 이동하시겠습니까?" close:^(int buttonIndex) {
                
                if(buttonIndex == 0){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }else{
                    
                }
            }];
            
        }
            break;
            
        default:
            //[_viewController showIndicator];
            self.enableLocation = YES;
            
            [self.locationManager startUpdatingLocation];
            
//            if ( self.gpsUpdateTimer == nil ) {
//                self.gpsUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:GPS_UPLOAD_INTERVAL target:_locationManager selector:@selector(startUpdatingLocation) userInfo:nil repeats:YES];
//                [[NSRunLoop mainRunLoop] addTimer:self.gpsUpdateTimer forMode:NSDefaultRunLoopMode];
//            }
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location error %@", [error description]);
    
    self.enableLocation = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"locationChanged" object: nil userInfo:nil];
    //    [Common showAlert:@"" message:@"위치정보를 가져오는데 실패했습니다." btn1:@"확인" btn2:nil handler:^(UIAlertAction *action, int btnIndex) {
    //
    //        if ( btnIndex == 1 ) {
    //            _sLatitude = @"";
    //            _sLongitude = @"";
    //
    //            if ( _callBackFunc && !_sendGpsCallback ) {
    //
    //                [self gpsUpload];
    //            }
    //        }
    //    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation) {
        self.enableLocation = YES;
        self.hasLocationInfo = YES;
        self.longitude = currentLocation.coordinate.longitude;
        self.latitude = currentLocation.coordinate.latitude;
        
        ApplicationDelegate.loginData.user_latitude = [NSString stringWithFormat:@"%f", self.latitude];
        ApplicationDelegate.loginData.user_longitude = [NSString stringWithFormat:@"%f", self.longitude];
       
        [[NSNotificationCenter defaultCenter] postNotificationName: @"locationChanged" object: nil userInfo:nil];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)noti {
    
    //[Log saveRemoteLog:@"system" message:@"applicationDidEnterBackground"];
    
    if ( self.locationManager ) {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}


- (void)applicationWillEnterForeground:(NSNotification *)noti {
    
    //[Log saveRemoteLog:@"system" message:@"applicationWillEnterForeground"];
    
    if ( self.locationManager ) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //[Log saveRemoteLog:@"system" message:@"applicationDidBecomeActive"];
    
    if ( self.locationManager ) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
    }
}


- (void)applicationWillTerminate:(NSNotification *)noti {
    
    //[Log saveRemoteLog:@"system" message:@"applicationWillTerminate"];
    
    if ( self.locationManager ) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
    }
}

@end
