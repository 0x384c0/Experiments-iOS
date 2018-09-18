#import <Foundation/Foundation.h>

@interface MapsHelper : NSObject
+(void) showMapWithAddress:(NSString *)address vc:(UIViewController*)vc;
+(void) showMapWithLatitude:(NSNumber<RLMDouble>*)latitude
                  longitude:(NSNumber<RLMDouble>*)longitude
                         vc:(UIViewController*)vc;
+(BOOL) isEmptyAddress:(NSString*)address;
@end
