//
//  SPAnnotation.h
//  SmartPark
//
//  Created by Jason Wang on 1/13/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

extern NSString *const kReusablePinRed;
extern NSString *const kReusablePinGreen;
extern NSString *const kReusablePinPurple;

@interface SPAnnotation : NSObject <MKAnnotation>

@property (nonatomic, unsafe_unretained , readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;

- (instancetype) initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates
                              title:(NSString *)paramTitle
                           subtitle:(NSString *)paramSubtitle;

+ (NSString *) reusableIdentifierforPinColor: (MKPinAnnotationColor)paramColor;

@end
