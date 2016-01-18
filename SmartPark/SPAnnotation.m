//
//  SPAnnotation.m
//  SmartPark
//
//  Created by Jason Wang on 1/13/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "SPAnnotation.h"

NSString *const kReusablePinRed = @"Red";
NSString *const kReusablePinGreen = @"Green";
NSString *const kReusablePinPurple = @"Purple";



@implementation SPAnnotation
@synthesize coordinate;

-(id)initWithLocation:(CLLocationCoordinate2D)coord; {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

+ (NSString *) reusableIdentifierforPinColor: (MKPinAnnotationColor)paramColor {
    NSString *result = nil;
    switch (paramColor) {
        case MKPinAnnotationColorRed: {
            result = kReusablePinRed;
            break;
        }
        case MKPinAnnotationColorGreen: {
            result = kReusablePinGreen;
            break;
        }
        case MKPinAnnotationColorPurple: {
            result = kReusablePinPurple;
            break;
        }
    }
    return result;
}

@end
