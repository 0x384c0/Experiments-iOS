#import <Foundation/Foundation.h>
@protocol MediaHelperDelegate
-(void)didSelectImage:(UIImage*)image;
@end

@interface MediaHelper : NSObject
-(instancetype)initWithVC:(UIViewController<MediaHelperDelegate>*)vc;
-(instancetype)initWithVC:(UIViewController<MediaHelperDelegate>*)vc imageViewFrame:(CGRect) imageViewFrame;
-(void)showPhotoPicker;
-(void)showMultiplePhotosPicker;
-(void)downloadImages:(NSArray<Image*>*)images;
-(void)viewImages:(RLMArray<Image>*)images;
-(void)viewImage:(Image*)image;
@end
