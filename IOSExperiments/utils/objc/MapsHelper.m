#import "MapsHelper.h"

@implementation MapsHelper
+(void) showMapWithAddress:(NSString *)address vc:(UIViewController*)vc{
    if ([self isEmptyAddress:address])
        return;
    
    [self showMapWithParams:[NSString stringWithFormat:@"search?q=%@",address] vc:vc];
}
+(void) showMapWithLatitude:(NSNumber<RLMDouble>*)latitude
                  longitude:(NSNumber<RLMDouble>*)longitude
                         vc:(UIViewController*)vc{
    if ([self isEmptyLatitude:latitude longitude:longitude])
        return;
    
    [self showMapWithParams:[NSString stringWithFormat:@"search?q=%@,%@",latitude,longitude] vc:vc];
}
+(void) showMapWithParams:(NSString *)params vc:(UIViewController*)vc{
    NSString *iosMapsUrlString = [[NSString stringWithFormat:@"maps://%@",params]
                                  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *iosMapsUrl =  [NSURL URLWithString: iosMapsUrlString];
    
    NSString *googleMapsUrlString = [[NSString stringWithFormat:@"comgooglemaps://%@",params]
                                     stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *googleMapsUrl =  [NSURL URLWithString: googleMapsUrlString];
    
    if ([UIApplication.sharedApplication canOpenURL:googleMapsUrl]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OPEN_IN_MAPS",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [UIApplication.sharedApplication openURL:iosMapsUrl];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OPEN_IN_GOOGLE_MAPS",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [UIApplication.sharedApplication openURL:googleMapsUrl];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL",nil) style:UIAlertActionStyleCancel handler:nil]];
        [vc presentViewController:alertController animated:YES completion:nil];
    } else {
        [UIApplication.sharedApplication openURL:iosMapsUrl];
    }
}

+(BOOL) isEmptyAddress:(NSString*)address{
    if (
        address == nil ||
        [address isEqualToString:@""]
        ) {
        return YES;
    } else{
        return NO;
    }
}
+(BOOL) isEmptyLatitude:(NSNumber<RLMDouble>*)latitude
              longitude:(NSNumber<RLMDouble>*)longitude{
    return latitude.doubleValue == 0 || longitude.doubleValue == 0;
}
@end
