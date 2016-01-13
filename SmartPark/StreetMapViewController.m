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
#import "AddressAPI.h"
#import "StreetSign.h"
#import "StreetSignAPI.h"
#import "SPAnnotation.h"

@interface StreetMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
//IBOutlet
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

//Location Property
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) MKCoordinateRegion currentRegion;

//Keyboard
@property (nonatomic) UITapGestureRecognizer *tapReconizer;


@property (nonatomic) NSString *radiusRange;


@end

@implementation StreetMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"radius"] == nil) {
        self.radiusRange = @"50";
        [self saveToNSUserDefaults];
    }
    
    self.myMapView.delegate = self;
    self.myMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.myMapView];
    self.searchBar.delegate = self;
    
    [self checkForLocationServices];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self keyboardGestureRecognizer];
    
    
}


#pragma mark - IBActions

- (IBAction)refreshButtonTapped:(UIBarButtonItem *)sender {
    
    [self.myMapView setRegion:self.currentRegion animated:YES];
    
}


- (IBAction)mapType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.myMapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.myMapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.myMapView.mapType = MKMapTypeSatellite;
            break;
            
        default:
            break;
    }
    
}

- (IBAction)infoButtonTapped:(UIBarButtonItem *)sender {
    UIAlertController *radiusSelection = [UIAlertController alertControllerWithTitle:@"Radius" message:@"Select One For Your Default Radius Search" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *oneHundredMeter = [UIAlertAction actionWithTitle:@"100 Meters" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.radiusRange = @"100";
        [self saveToNSUserDefaults];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *oneFiftyMeter = [UIAlertAction actionWithTitle:@"150 Meters" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.radiusRange = @"150";
        [self saveToNSUserDefaults];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *twoHundred = [UIAlertAction actionWithTitle:@"200 Meters" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.radiusRange = @"200";
        [self saveToNSUserDefaults];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [radiusSelection addAction:oneHundredMeter];
    [radiusSelection addAction:oneFiftyMeter];
    [radiusSelection addAction:twoHundred];
    [self presentViewController:radiusSelection animated:YES completion:nil];
}

- (void)saveToNSUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:self.radiusRange forKey:@"radius"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - LocationMethods
- (void)checkForLocationServices {
    
    if ([CLLocationManager locationServicesEnabled] ) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
    } else {
        UIAlertController *locationServicesAlert = [UIAlertController alertControllerWithTitle:@"Enable Location Services" message:@"Please Enable The Location Services In Setting" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Location Services Not Enabled");
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [locationServicesAlert addAction:okAction];
        [self presentViewController:locationServicesAlert animated:YES completion:nil];
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    self.currentRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 800, 800);
}

#pragma mark - SearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    AddressAPI *address = [AddressAPI new];
    [address searchGoogleAPIWithStringAddress:searchBar.text completionHandler:^(NSString *formattedAddress, CLLocationCoordinate2D resultCoordinate2D, NSError *error) {
        if (!error) {
            [self addressConfirmationAlertWithAddress:formattedAddress andLocationCoordinate:resultCoordinate2D];
        } else {
            
        }
    }];
    

}

- (void)addressConfirmationAlertWithAddress:(NSString *)address andLocationCoordinate:(CLLocationCoordinate2D)coordinate {
    // display comfirm address alart
    UIAlertController *confirmAddress = [UIAlertController alertControllerWithTitle:@"Confirm Address" message:address preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dropMapPinOnDestination:coordinate withAddressString:address];
        
        [self queryStreetSignsWithCLLocationCoordinate:coordinate];
        
        // zoom to destination
        MKCoordinateRegion destinationRegion = MKCoordinateRegionMakeWithDistance(coordinate, [self.radiusRange integerValue] + 300, [self.radiusRange integerValue] + 300);
        [self.myMapView setRegion:destinationRegion animated:YES];
        
    }];
    
    [confirmAddress addAction:cancelAction];
    [confirmAddress addAction:yesAction];
    [self presentViewController:confirmAddress animated:YES completion:nil];
}

- (void)dropMapPinOnDestination:(CLLocationCoordinate2D)coordinate withAddressString:(NSString *)address {
    // drop destination pin
    [self.myMapView removeAnnotations:self.myMapView.annotations];
    SPAnnotation *destinationPin = [[SPAnnotation alloc]initWithCoordinates:coordinate title:address subtitle:@""];
    destinationPin.pinColor= MKPinAnnotationColorGreen;
    [self.myMapView addAnnotation:destinationPin];
}


- (void)queryStreetSignsWithCLLocationCoordinate:(CLLocationCoordinate2D) coordinate {
    
    self.radiusRange = [[NSUserDefaults standardUserDefaults] objectForKey:@"radius"];
    StreetSignAPI *queryStreetSign = [StreetSignAPI new];
    [queryStreetSign searchStreetParkingHerokuWithLocation:coordinate withRadius:self.radiusRange completionHandler:^(NSMutableArray<StreetSign *> *listOfSigns, NSError *error) {
        
        if (!error) {
            for (StreetSign *streetSign in listOfSigns) {
                [self addMappAnnotationForStreetSign:streetSign];
            }
        } else {
#warning alert message with street sign no found
            NSLog(@"street sign no found");
        }
        
    }];
    
}

- (void)addMappAnnotationForStreetSign:(StreetSign *)sign {
    CLLocationCoordinate2D latLng = CLLocationCoordinate2DMake(sign.lat, sign.lng);
    SPAnnotation *strAnnotation = [[SPAnnotation alloc]initWithCoordinates:latLng title:sign.description subtitle:@""];
    strAnnotation.pinColor = MKPinAnnotationColorPurple;
    [self.myMapView addAnnotation:strAnnotation];
}


#pragma mark - Annotation Delegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *result = nil;
    if ([annotation isKindOfClass:[SPAnnotation class]] == NO) {
        return result;
    }
    if ([mapView isEqual:self.myMapView]) {
        return result;
    }
    
    SPAnnotation *senderAnnotation = (SPAnnotation *)annotation;
    NSString *pinReusableID = [SPAnnotation reusableIdentifierforPinColor:senderAnnotation.pinColor];
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableID];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableID];
        [annotationView setCanShowCallout:YES];
    }
    annotationView.pinColor = senderAnnotation.pinColor;
    result = annotationView;
    return result;
}


#pragma mark - KeyboardBehaviors

- (void)keyboardGestureRecognizer {
    NSNotificationCenter *keyboard = [NSNotificationCenter defaultCenter];
    [keyboard addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [keyboard addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tapReconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnyWhere:)];
}

- (void)keyboardWillShow: (NSNotification *)show {
    [self.view addGestureRecognizer:self.tapReconizer];
}

- (void)keyboardWillHide: (NSNotification *)hide {
    [self.view removeGestureRecognizer:self.tapReconizer];
}

- (void)didTapAnyWhere: (UITapGestureRecognizer *)reconizer {
    [self.searchBar resignFirstResponder];
}


@end