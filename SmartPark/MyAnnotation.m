//
//  MyAnnotation.m
//  SmartPark
//
//  Created by Jason Wang on 1/8/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "MyAnnotation.h"

NSString *const kReusablePinRedC = @"Red";
NSString *const kReusablePinGreenC = @"Green";
NSString *const kReusablePinBlueC = @"Blue";

@implementation MyAnnotation
#warning idk ehhhh.... 
//+(NSString *)reusableIdentifierforPinColor:(MKPinAnnotationView *)paramColor {
//    NSString *result = nil;
//    switch (paramColor.pinTintColor) {
//        case ;
//            result = kReusablePinRed;
//            break;
//        case MKPinAnnotationColorGreen:
//            result = kReusablePinGreen;
//            break;
//        case MKPinAnnotationColorPurple:
//            result = kReusablePinBlue;
//            break;
//        default:
//            break;
//    }
//    return result;
//}

-(instancetype)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subtitle:(NSString *)paramSubtitle {
    
    if (self = [super init]) {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubtitle;
        return self;
    }
    return nil;
    
}
@end
