//
//  StreetSign.m
//  SmartPark
//
//  Created by Jason Wang on 1/3/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "StreetSign.h"

@implementation StreetSign

@synthesize description;
@synthesize lng;
@synthesize lat;
@synthesize days;
@synthesize fromTime;
@synthesize toTime;

-(instancetype)initWithRegulationDays:(NSArray <NSString *> *)dates {
    if (self = [super init]) {
        if (dates) {
            self.days = [[NSArray alloc]initWithArray:dates];
        }
        self.days = nil;
        return self;
    }
    return nil;
}

@end
