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
@synthesize title;
@synthesize subtitle;
@synthesize pinColor;
- (instancetype)initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates
                              title:(NSString *)paramTitle
                           subtitle:(NSString *)paramSubtitle {
    self = [super init];
    if (self != nil) {
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubtitle;
        pinColor = MKPinAnnotationColorGreen;
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
