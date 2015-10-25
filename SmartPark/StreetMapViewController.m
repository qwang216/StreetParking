//
//  StreetMapViewController.m
//  SmartPark
//
//  Created by Jason Wang on 10/24/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "StreetMapViewController.h"
#import "APIManager.h"

@interface StreetMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
//IBOutlet
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

//Location Property
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) MKCoordinateRegion currentRegion;
@property (nonatomic) NSString *resultAddress;
@property (nonatomic) CLLocationCoordinate2D resultCoordinate2D;

//Keyboard
@property (nonatomic) UITapGestureRecognizer *tapReconizer;


//API Data Holder
@property (nonatomic) NSMutableDictionary *googleResponseObject;
@property (nonatomic) NSMutableDictionary *streetParkingObject;



@end

@implementation StreetMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.searchBar.delegate = self;
    
    [self checkForLocationServices];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self keyboardGestureRecognizer];
    
    
}


#pragma mark - IBActions

- (IBAction)refreshButtonTapped:(UIBarButtonItem *)sender {
    [self.mapView setRegion:self.currentRegion animated:YES];
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

- (IBAction)infoButtonTapped:(UIBarButtonItem *)sender {
}


#pragma mark - LocationMethods
-(void)checkForLocationServices{
    
    if ([CLLocationManager locationServicesEnabled] ) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
    } else {
        UIAlertController *locationServicesAlert = [UIAlertController alertControllerWithTitle:@"Enable Location Services" message:@"Please Enable The Location Services In Setting" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Location Services Not Enabled");
        }];
        [locationServicesAlert addAction:okAction];
        [self presentViewController:locationServicesAlert animated:YES completion:nil];
    }
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    
//    CLLocation *oldLocation;
//    if (locations.count > 1) {
//        oldLocation = [locations objectAtIndex:locations.count - 2];
//    } else {
//        oldLocation = nil;
//    }
    
    self.currentRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 800, 800);
}

#pragma mark - SearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [APIManager searchGoogleAPIWithStringAddress:searchBar.text completionHandler:^(id reponse, NSError *error) {
        
        if ([reponse[@"status"] isEqualToString:@"OK"]) {
            self.googleResponseObject = [[NSMutableDictionary alloc]init];
            self.googleResponseObject = reponse;
            self.resultAddress = self.googleResponseObject[@"results"][0][@"formatted_address"];
            self.resultCoordinate2D = CLLocationCoordinate2DMake([self.googleResponseObject[@"results"][0][@"geometry"][@"location"][@"lat"]doubleValue], [self.googleResponseObject[@"results"][0][@"geometry"][@"location"][@"lng"]doubleValue]);
            NSLog(@"lat-%f   lng-%f", self.resultCoordinate2D.latitude, self.resultCoordinate2D.longitude);
            [self processHerokuAPI];
        } else {
            NSLog(@"Display a Alert");
        }
    }];
}

-(void)processHerokuAPI{
    // grab Radius from NSUserDefault

    [APIManager searchStreetParkingHerokuWithLocation:self.resultCoordinate2D withRadius:50 completionHandler:^(id reponse, NSError *error) {
        if (!error) {
            self.streetParkingObject = [[NSMutableDictionary alloc]init];
            self.streetParkingObject = reponse;
            [self updateMap];
        } else {
            NSLog(@"Alert Error!!");
        }
    }];
}

-(void)updateMap {
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSArray *listOfSigns = [self.streetParkingObject objectForKey:@"results"];
    
    for (NSDictionary *streetSign in listOfSigns) {
        [self addMappAnnotationForStreetSign: streetSign];
    }
}

-(void)addMappAnnotationForStreetSign: (NSDictionary *)sign{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    double lat = [sign[@"latitude"] doubleValue];
    double lng = [sign[@"longtitude"] doubleValue];
    CLLocationCoordinate2D latLng = CLLocationCoordinate2DMake(lat, lng);
    
    mapPin.coordinate = latLng;
    mapPin.title = sign[@"signdesc"];
    [self.mapView addAnnotation:mapPin];
}

#pragma mark - KeyboardBehaviors

-(void)keyboardGestureRecognizer {
    NSNotificationCenter *keyboard = [NSNotificationCenter defaultCenter];
    [keyboard addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [keyboard addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tapReconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnyWhere:)];
}

-(void)keyboardWillShow: (NSNotification *)show {
    [self.view addGestureRecognizer:self.tapReconizer];
}

-(void)keyboardWillHide: (NSNotification *)hide {
    [self.view removeGestureRecognizer:self.tapReconizer];
}

-(void)didTapAnyWhere: (UITapGestureRecognizer *)reconizer {
    [self.searchBar resignFirstResponder];
}


@end