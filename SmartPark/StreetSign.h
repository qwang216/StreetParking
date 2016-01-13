//
//  StreetSign.h
//  SmartPark
//
//  Created by Jason Wang on 1/3/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreetSign : NSObject
@property (nonatomic) NSString *description;
@property (nonatomic) double lng;
@property (nonatomic) double lat;
@property (nonatomic) NSArray <NSString *> *days;
@property (nonatomic) NSString *fromTime;
@property (nonatomic) NSString *toTime;

-(instancetype)initWithRegulationDays:(NSArray <NSString *> *)dates;

@end
