//
//  ViewController.m
//  MapIt
//
//  Created by Jason Wang on 9/27/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ViewController.h"
#import "StreetParkingAPIManager.h"
//#import "FoursquareAPIManager.h"



@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextFiel;
@property (nonatomic) NSMutableDictionary *searchResults;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the delegate to 'self.searchTextField' to 'self'
    self.searchTextFiel.delegate = self;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.7, -74.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.8f, 0.8f);
    [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    
    
    
    self.locationManager = [[CLLocationManager alloc] init];

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}


- (IBAction)mapType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
            
        default:
            break;
    }
}

// called when the user taps the search button
- (IBAction)searchButtonTapped:(UIButton *)sender {
    
    [self performSearch];
}



- (void)performSearch {
    [self.view endEditing:YES];
    
    MKUserLocation *userLocation = self.mapView.userLocation;
    
    [StreetParkingAPIManager searchStreetParkingWithGivenLocation:userLocation.coordinate withRadius:[self.searchTextFiel.text floatValue] completionHandler:^(id response, NSError *error) {
        
        self.searchResults = response;
        
        [self updateMap];
    }];
    
//    [FoursquareAPIManager searchFoursquarePlacesForTerm:self.searchTextFiel.text
//                                               location:userLocation.coordinate
//                                      completionHandler:^(id response, NSError *error) {
//                                          
//                                          self.searchResults = response[@"response"][@"venues"];
//                                          NSLog(@"%@",response);
//                                          [self updateMap];
//                                          
//                                      }];
}

- (void)updateMap {
    
    // removes all previous pins
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSArray *listOfSigns = [self.searchResults objectForKey:@"results"];
    
    for (NSDictionary *streetSign in listOfSigns) {
        [self addMapAnnotationForVenue:streetSign];
    }
}

- (void)addMapAnnotationForVenue:(NSDictionary *)sign {
    
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    double lat = [sign[@"latitude"] doubleValue];
    double lng = [sign[@"longtitude"] doubleValue];
    CLLocationCoordinate2D latLng = CLLocationCoordinate2DMake(lat, lng);
    
    mapPin.coordinate = latLng;
    mapPin.title = sign[@"signdesc"];

//    NSArray *categories = venue[@"categories"];
//    if (categories.count > 0) {
//        NSDictionary *firstCategory = categories[0]; // grab the first category
//        mapPin.subtitle = firstCategory[@"name"]; // grab the name for the first category
//    }
    
    [self.mapView addAnnotation:mapPin];
}

#pragma mark - Text Field Delegate

// called when user taps the return key on the keyboar
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self performSearch];
    
    return YES;
}





@end
