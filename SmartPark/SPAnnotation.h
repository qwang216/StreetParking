//
//  SPAnnotation.h
//  SmartPark
//
//  Created by Jason Wang on 1/13/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SPAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

//@property (nonatomic, unsafe_unretained , readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
