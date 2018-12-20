#import <UIKit/UIKit.h>

@interface CustomSearchController : UISearchController
-(instancetype)initWithPlaceholder:(NSString*)palceholder;
-(void)addSelfToVC:(UIViewController*)vc;
-(void)removeSelfToVC:(UIViewController*)vc;
-(void)becomeFirstResponderAfterDelay;
-(void)setCancelImage;
@property BOOL customButtons;
@end
