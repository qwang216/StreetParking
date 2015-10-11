//
//  StreetParkingAPIManager.m
//  MapIt
//
//  Created by Jason Wang on 10/7/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import "StreetParkingAPIManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation StreetParkingAPIManager

+ (void)searchStreetParkingWithGivenLocation:(CLLocationCoordinate2D)location withRadius:(float)radius completionHandler:(void (^)(id response, NSError *error))handler {
    
    NSString *streetParkingURL = [NSString stringWithFormat:@"https://street-parking.herokuapp.com/find?lat=%f&lng=%f&radius=%f", location.latitude, location.longitude, radius];
    
    NSLog(@"%@",streetParkingURL);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [manager GET:streetParkingURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(responseObject, nil);
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
    
    
}


@end
