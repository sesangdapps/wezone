//
//  LocationManager.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 14..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSTimer *gpsUpdateTimer;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) BOOL hasLocationInfo;
@property (assign, nonatomic) BOOL enableLocation;


+ (instancetype)sharedLocationManager;
- (BOOL) requestLocation;

@end
