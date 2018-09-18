#import "MyLocationButtonHelper.h"
@interface MyLocationButtonHelper()<CLLocationManagerDelegate>
@property ISHHoverBar* hoverBar;
@property(weak) MKMapView* mapView;
@end

@implementation MyLocationButtonHelper{
    CLLocationManager *locationManager;
}
-(instancetype)initWithHoverBar:(ISHHoverBar*)hoverBar  mapView:(MKMapView*) mapView{
    self.hoverBar = hoverBar;
    self.mapView = mapView;
    [self setupMyLocationButton];
    return self;
}


- (void)setupMyLocationButton{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied ||
        CLLocationManager.authorizationStatus == kCLAuthorizationStatusRestricted){
        self.hoverBar.hidden = YES;
    } else{
        [locationManager requestWhenInUseAuthorization];
    }
    UIBarButtonItem *mapBarButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    [self.hoverBar setBorderColor: UIColor.clearColor];
    [self.hoverBar setItems:@[mapBarButton]];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    self.hoverBar.hidden =
    CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied ||
    CLLocationManager.authorizationStatus == kCLAuthorizationStatusRestricted;
}
@end
