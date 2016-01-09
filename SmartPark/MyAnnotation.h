//
//  MyAnnotation.h
//  SmartPark
//
//  Created by Jason Wang on 1/8/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

extern NSString *const kReusablePinRedC;
extern NSString *const kReusablePinGreenC;
extern NSString *const kReusablePinBlueC;


@interface MyAnnotation : NSObject <MKAnnotation>

@property (readonly, nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, unsafe_unretained) MKPinAnnotationView *myPinColor;


-(instancetype)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subtitle:(NSString *)paramSubtitle;

//+(NSString *)reusableIdentifierforPinColor:(MKPinAnnotationView *)paramColor;
@end
