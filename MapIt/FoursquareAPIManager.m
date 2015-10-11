//
//  FoursquareAPIManager.m
//  MapIt
//
//  Created by Michael Kavouras on 9/27/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

#import "FoursquareAPIManager.h"
#import <AFNetworking/AFNetworking.h>

#define kFSClientID @"IN4V05KYYXLPDXGIHMCDSPVIAG30BTOG4NC3AEAYFYIQZID0"
#define kFSClientSecret @"CD31L2IZKSYQ1AAGTHQQEF2GHXJLI43CXYV1KVCEEUQZQ2G4"

@implementation FoursquareAPIManager

+ (void)searchFoursquarePlacesForTerm:(NSString *)term
                             location:(CLLocationCoordinate2D)location
                    completionHandler:(void(^)(id response, NSError *error))handler {
    

//    NSString *APIBase = @"https://api.foursquare.com";
//    NSString *APIVersion = @"v2";
//    NSString *APIEndpoint = @"venues/search";
    
    term = [term stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    NSString *urlString = [NSString stringWithFormat:@"https://street-parking.herokuapp.com/find?lat=40.7135097&lng=-73.9859414&radius=50"];
    
    NSLog(@"URL: %@", urlString);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        handler(responseObject, nil);
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        handler(nil, error);
        NSLog(@"Error %@", error);
    }];

}












@end
