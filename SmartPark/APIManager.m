//
//  APIManager.m
//  SmartPark
//
//  Created by Jason Wang on 10/25/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import "APIManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIManager


+(void)searchStreetParkingHerokuWithLocation:(CLLocationCoordinate2D)location
                                  withRadius:(int)radius
                           completionHandler:(void(^)(id reponse, NSError *error))handler {
    NSString *url = [NSString stringWithFormat:@"http://street-parking.herokuapp.com/find?lat=%flng=-%f&radius=%d", location.latitude, location.longitude, radius];
    NSLog(@"Check how many decimals in the Float Number %@",url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        handler(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        handler(nil,error);
    }];
    
}


+(void)searchGoogleAPIWithStringAddress:(NSString *)address
                      completionHandler:(void(^)(id reponse, NSError *error))handler {
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",address];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        handler(responseObject, nil);
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        handler(nil, error);
    }];
}


@end