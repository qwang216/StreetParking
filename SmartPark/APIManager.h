//
//  APIManager.h
//  SmartPark
//
//  Created by Jason Wang on 10/25/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface APIManager : NSObject

+(void)searchStreetParkingHerokuWithLocation:(CLLocationCoordinate2D)location
                                  withRadius:(NSString *)radius
                           completionHandler:(void(^)(id response, NSError *error))handler;


+(void)searchGoogleAPIWithStringAddress:(NSString *)address
                      completionHandler:(void(^)(id response, NSError *error))handler;
@end
