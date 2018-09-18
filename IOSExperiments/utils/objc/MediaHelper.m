#import "MediaHelper.h"
#import "QBImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
@import Photos;
@interface MediaHelper()<TOCropViewControllerDelegate,MediaPickerControllerDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(weak) UIViewController<MediaHelperDelegate> *vc;
@end

@implementation MediaHelper{
    MediaPickerController *mediaPickerController;
    CGRect imageViewFrame;
}

-(instancetype)initWithVC:(UIViewController<MediaHelperDelegate>*)vc imageViewFrame:(CGRect) imageViewFrame{
    self->imageViewFrame = imageViewFrame;
    return [self initWithVC:vc];
}

-(instancetype)initWithVC:(UIViewController<MediaHelperDelegate>*)vc{
    self.vc = vc;
    
    mediaPickerController = [MediaPickerController.alloc initWithType:MediaPickerControllerTypeImageOnly presentingViewController:self.vc];
    mediaPickerController.delegate = self;
    
    return self;
}
-(void)showPhotoPicker{
    @weakify(self)
    [self checkPernmissionsWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self->mediaPickerController show];
        });
    }];
}
-(void)showMultiplePhotosPicker{
    @weakify(self)
    [self checkPernmissionsWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)])
                [vc addAction: [UIAlertAction actionWithTitle:@"TAKE_A_PHOTO".localized style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self showCameraPicker];
                }]];
            [vc addAction: [UIAlertAction actionWithTitle:@"CHOOSE_EXISTING_PHOTOS".localized style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self showQBImagePickerController];
            }]];
            [vc addAction: [UIAlertAction actionWithTitle:@"CANCEL".localized style:(UIAlertActionStyleCancel) handler:nil]];
            [self.vc presentViewController:vc animated:YES completion:nil];
        });
    }];
}

-(void)showQBImagePickerController{
    QBImagePickerController *qbImagePicker = [QBImagePickerController new];
    qbImagePicker.delegate = self;
    qbImagePicker.allowsMultipleSelection = YES;
    qbImagePicker.mediaType = QBImagePickerMediaTypeImage;
    qbImagePicker.maximumNumberOfSelection = 10;
    [self.vc presentViewController:qbImagePicker animated:YES completion:NULL];
}
-(void)showCameraPicker{
    UIImagePickerController *vc = UIImagePickerController.new;
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    vc.delegate = self;
    [self.vc presentViewController:vc animated:YES completion:nil];
}

#pragma mark MediaPickerControllerDelegate
- (void)mediaPickerControllerDidPickImage:(UIImage *)image{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
    cropController.delegate = self;
    [self.vc.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    [self.vc presentViewController:cropController animated:YES completion:nil];
}

#pragma mark TOCropViewControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    if (imageViewFrame.size.height != 0 && imageViewFrame.size.width != 0){
        @weakify(self)
        [cropViewController dismissAnimatedFromParentViewController:self.vc withCroppedImage:image toFrame:imageViewFrame completion:^{
            @strongify(self)
            [self.vc didSelectImage:image];
        }];
    } else {
        @weakify(self)
        [cropViewController dismissViewControllerAnimated:YES completion:^{
            @strongify(self)
            [self.vc didSelectImage:image];
        }];
        
    }
    
    
}

#pragma mark QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    for (PHAsset *asset in assets) {
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestImageDataForAsset:asset options:0 resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *image = [UIImage imageWithData:imageData.copy];
            if (image)
                [self.vc didSelectImage:image];
         }];
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.vc didSelectImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Others
-(void)checkPernmissionsWithCompletion:(void(^)())completion{
    @weakify(self)
    [self getLibraryAccess:^{
        @strongify(self)
        [self getCameraAccess:completion];
    }];
}
-(void)getLibraryAccess:(void(^)())completion{
    PHAuthorizationStatus mediaLibraryStatus = PHPhotoLibrary.authorizationStatus;
    if (mediaLibraryStatus == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                completion();
            }
        }];
    } else if (mediaLibraryStatus == PHAuthorizationStatusAuthorized){
        completion();
    } else if (mediaLibraryStatus == PHAuthorizationStatusDenied || mediaLibraryStatus == PHAuthorizationStatusRestricted){
        [self showAlertWithVC:self.vc text:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"]];
    }
}
-(void)getCameraAccess:(void(^)())completion{
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (cameraStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted){
                completion();
            }
        }];
    } else if (cameraStatus == AVAuthorizationStatusAuthorized){
        completion();
    } else if (cameraStatus == AVAuthorizationStatusRestricted || cameraStatus == AVAuthorizationStatusDenied){
        [self showAlertWithVC:self.vc text:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSCameraUsageDescription"]];
    }
}

-(void)showAlertWithVC:(UIViewController*)vc text:(NSString*)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"ACCESS_ERROR".localized message:text preferredStyle:UIAlertControllerStyleAlert];
        
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"MENU_SETTINGS".localized
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [[UIApplication sharedApplication] openURL:settingsURL];
                                                  }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"CANCEL".localized
                                                    style:UIAlertActionStyleCancel
                                                  handler:nil]];
        [vc presentViewController:alertVc animated:YES completion:nil];
    });
}

#pragma mark Attachments
-(void)downloadImages:(NSArray<Image*>*)images{
    NSMutableArray<RACSignal*>* signals = NSMutableArray.new;
    NSUInteger counter = 0;
    for (Image *image in images){
        if (image.pictures.getOriginalUrl)
            [signals addObject:[self getSignalForDownloadImage:image.pictures.getOriginalUrl
                                                       counter:[NSString stringWithFormat:@"%lu/%lu ",(unsigned long)counter,(unsigned long)images.count]]];
        counter += 1;
    }
    if (signals.count)
        [[RACSignal concat:signals]
         subscribeNext:^(UIImage *image) {
             UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
             [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"IMAGE_SAVED_MESSAGE", nil)];
         }
         error:^(NSError *error) {
             [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ERROR_ONS_SAVING_IMAGE_MESSAGE", nil)];
         }];
}
-(RACSignal*)getSignalForDownloadImage:(NSURL *)imageUrl counter:(NSString*)counter{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [SDWebImageDownloader.sharedDownloader
         downloadImageWithURL:imageUrl
         options:0
         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
             NSLog(@" %li  %li", (long) expectedSize, (long) receivedSize);
             [SVProgressHUD showProgress:(float) receivedSize / (float) expectedSize status: [counter stringByAppendingString: @"SAVING_IMAGE_MESSAGE".localized]];
         }
         completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
             if (image && finished)
                 [subscriber sendNext:image];
             else
                 [subscriber sendError: nil];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
    return signal;
}
-(void)viewImages:(RLMArray<Image>*)images{
    LPPhotoViewer *pvc = [[LPPhotoViewer alloc] init];
    pvc.imgArr = [Image getUrlsFromAttachments:images];
    if (pvc.imgArr.count)
        [pvc showFromViewController:self.vc sender:nil];
}
-(void)viewImage:(Image*)image{
    if (image.pictures.original){
        LPPhotoViewer *pvc = [[LPPhotoViewer alloc] init];
        pvc.imgArr = @[image.pictures.getOriginalUrl.absoluteString];
        [pvc showFromViewController:self.vc sender:nil];
    }
}
@end
