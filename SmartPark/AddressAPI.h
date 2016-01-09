//
//  AddressAPI.h
//  SmartPark
//
//  Created by Jason Wang on 1/2/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>


@interface AddressAPI : NSObject
-(void)searchGoogleAPIWithStringAddress:(NSString *)address
                      completionHandler:(void(^)(NSString *formattedAddress, CLLocationCoordinate2D resultCoordinate2D, NSError *error))handler;

@end
