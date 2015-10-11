//
//  StreetParkingAPIManager.h
//  MapIt
//
//  Created by Jason Wang on 10/7/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface StreetParkingAPIManager : NSObject

+ (void)searchStreetParkingWithGivenLocation:(CLLocationCoordinate2D)location withRadius:(float)radius completionHandler:(void (^)(id response, NSError *error))handler;

@end
