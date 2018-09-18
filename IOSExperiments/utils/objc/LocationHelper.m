#import "LocationHelper.h"
#import "INTULocationManager.h"

@implementation LocationHelper

+ (RACSignal *)getCurrentLocationWithVC:(UIViewController*)vc{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
        [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                           timeout:10.0
                              delayUntilAuthorized:YES
                                             block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                 if (status == INTULocationStatusSuccess) {
                                                     [subscriber sendNext:currentLocation];
                                                 } else {
                                                     NSString *message;
                                                     if (status == INTULocationStatusServicesDenied ||
                                                         status == INTULocationStatusServicesDisabled){
                                                         message = @"Location services are off";
                                                         [self showSettingAlertFromVC:vc
                                                                              status:status
                                                          ];
                                                     } else {
                                                         message = [NSString stringWithFormat: @"Not enough location acuuracy. \nWanted accuracy: 100 meters. \nAcheived accuracy: %f meters",currentLocation.horizontalAccuracy];
                                                     }
                                                     
                                                     NSError *error = [NSError errorWithDomain:@"LocationHelper" code:CUSTOM_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey:message}];
                                                     [subscriber sendError:error];
                                                     [subscriber sendCompleted];
                                                 }
                                             }];
        
        return nil;
    }];
    return signal;
    
}

+(void)showSettingAlertFromVC:(UIViewController*)vc status:(INTULocationStatus)status{
    
    NSString *message =
    status == INTULocationStatusServicesDenied ?
    @"To use location you must turn on 'While Using the App' in the Location Services Settings" :
    @"Location Service is not enabled";
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Location services are off"
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"MENU_SETTINGS".localized
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * _Nonnull action) {
                                                  [[UIApplication sharedApplication] openURL:settingsURL];
                                              }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"CANCEL".localized
                                                style:UIAlertActionStyleCancel
                                              handler:nil]];
    [vc presentViewController:alertVc animated:YES completion:nil];
}

@end
