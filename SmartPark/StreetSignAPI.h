//
//  StreetSignAPI.h
//  SmartPark
//
//  Created by Jason Wang on 1/2/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "StreetSign.h"


@interface StreetSignAPI : NSObject

-(void)searchStreetParkingHerokuWithLocation:(CLLocationCoordinate2D)location
                                  withRadius:(NSString *)radius
                           completionHandler:(void(^)(NSMutableArray <StreetSign *> *listOfSigns, NSError *error))handler;

@end
