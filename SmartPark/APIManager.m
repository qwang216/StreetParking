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
                                  withRadius:(NSString *)radius
                           completionHandler:(void(^)(id response, NSError *error))handler {
    NSString *url = [NSString stringWithFormat:@"http://street-parking.herokuapp.com/find?lat=%flng=%f&radius=%@", location.latitude, location.longitude, radius];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    manager.responseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        handler(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        handler(nil,error);
    }];
    
}


+(void)searchGoogleAPIWithStringAddress:(NSString *)address
                      completionHandler:(void(^)(id response, NSError *error))handler {
    address = [address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",address];
    NSLog(@"Google URL %@",url);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        handler(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        handler(nil, error);
    }];
}


@end
