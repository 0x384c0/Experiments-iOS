#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject
+ (RACSignal *)getCurrentLocationWithVC:(UIViewController*)vc;
@end
