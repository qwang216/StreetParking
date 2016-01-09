//
//  AddressAPI.m
//  SmartPark
//
//  Created by Jason Wang on 1/2/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "AddressAPI.h"


@implementation AddressAPI

-(void)searchGoogleAPIWithStringAddress:(NSString *)address
                      completionHandler:(void(^)(NSString *formattedAddress, CLLocationCoordinate2D resultCoordinate2D, NSError *error))handler {
    address= [address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",address];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"OK"]) {
            NSString *formattedAddress = responseObject[@"results"][0][@"formatted_address"];
            CLLocationCoordinate2D addressCoordinate2D = CLLocationCoordinate2DMake([responseObject[@"results"][0][@"geometry"][@"location"][@"lat"] doubleValue], [responseObject[@"results"][0][@"geometry"][@"location"][@"lng"] doubleValue]);
            handler(formattedAddress, addressCoordinate2D, nil);
        } else {
            handler(nil, kCLLocationCoordinate2DInvalid, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handler(nil, kCLLocationCoordinate2DInvalid, error);
        NSLog(@"Google error == %@",error.userInfo);

    }];
    
}

@end
