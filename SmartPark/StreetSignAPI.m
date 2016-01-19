//
//  StreetSignAPI.m
//  SmartPark
//
//  Created by Jason Wang on 1/2/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "StreetSignAPI.h"
#import <AFNetworking/AFNetworking.h>

@implementation StreetSignAPI

-(void)searchStreetParkingHerokuWithLocation:(CLLocationCoordinate2D)location
                                  withRadius:(NSString *)radius
                           completionHandler:(void(^)(NSMutableArray <StreetSign *> *listOfSigns, NSError *error))handler {
    NSString *url = [NSString stringWithFormat:@"https://street-parking.herokuapp.com/find?lat=%f&lng=%f&radius=%@&group_signs=1",location.latitude, location.longitude, radius];
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"StreetSign response object %@",responseObject);
        NSMutableArray <StreetSign *> *listOfSigns = [NSMutableArray new];
        for (NSArray *streetSignArray in responseObject[@"results"]) {
            for (NSDictionary *streetSignDict in streetSignArray) {
                StreetSign *streetSign = [StreetSign new];
                streetSign.lng = [[streetSignDict objectForKey:@"longtitude"] doubleValue];
                streetSign.lat = [[streetSignDict objectForKey:@"latitude"] doubleValue];
                streetSign.description = streetSignDict[@"description"];
                streetSign.fromTime = streetSignDict[@"from_time"];
                streetSign.toTime = streetSignDict[@"to_time"];
                if (streetSignDict[@"days"]) {
                    streetSign.days = streetSignDict[@"days"];
                }
                [listOfSigns addObject:streetSign];

            }
        }
        handler(listOfSigns, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handler(nil, error);
    }];
}

@end
