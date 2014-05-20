//
//  IFFiltersViewController.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#define kFilterImageViewTag 9999
#define kFilterImageViewContainerViewTag 9998
#define kBlueDotImageViewOffset 25.0f
#define kFilterCellHeight 72.0f 
#define kBlueDotAnimationTime 0.2f
#define kFilterTableViewAnimationTime 0.2f
#define kGPUImageViewAnimationOffset 27.0f
#import "IFFiltersViewController.h"
#import "InstaFilters.h"
#import "UIImage+IF.h"

@interface IFFiltersViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IFVideoCameraDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *transparentBackButton;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *cameraToolBarImageView;
@property (nonatomic, strong) UIImageView *cameraCaptureBarImageView;
@property (nonatomic, strong) UIButton *toggleFiltersButton;
@property (nonatomic, unsafe_unretained) BOOL isFiltersTableViewVisible;
@property (nonatomic, strong) UITableView *filtersTableView;
@property (nonatomic, strong) UIView *filterTableViewContainerView;
@property (nonatomic, strong) UIImageView *blueDotImageView;
@property (nonatomic, strong) UIImageView *cameraTrayImageView;
@property (nonatomic, strong) IFVideoCamera *videoCamera;
@property (nonatomic, strong) UIButton *photoAlbumButton;
@property (nonatomic, strong) UIButton *shootButton;
@property (nonatomic, unsafe_unretained) IFFilterType currentType;
@property (nonatomic, strong) UIButton *cancelAlbumPhotoButton;
@property (nonatomic, strong) UIButton *confirmAlbumPhotoButton;
@property (nonatomic, unsafe_unretained) BOOL isInVideoRecorderMode;
@property (nonatomic, unsafe_unretained) BOOL isHighQualityVideo;
- (void)backButtonPressed:(id)sender;
- (void)toggleFiltersButtonPressed:(id)sender;
- (void)photoAlbumButtonPressed:(id)sender;
- (void)shootButtonPressed:(id)sender;
- (void)shootButtonTouched:(id)sender;
- (void)shootButtonCancelled:(id)sender;
- (void)cancelAlbumPhotoButtonPressed:(id)sender;
- (void)confirmAlbumPhotoButtonPressed:(id)sender;

@end

@implementation IFFiltersViewController

@synthesize backButton;
@synthesize transparentBackButton;
@synthesize backgroundImageView;
@synthesize cameraToolBarImageView;
@synthesize cameraCaptureBarImageView;
@synthesize toggleFiltersButton;
@synthesize isFiltersTableViewVisible;
@synthesize filtersTableView;
@synthesize filterTableViewContainerView;
@synthesize blueDotImageView;
@synthesize cameraTrayImageView;
@synthesize videoCamera;
@synthesize photoAlbumButton;
@synthesize shootButton;
@synthesize currentType;
@synthesize cancelAlbumPhotoButton;
@synthesize confirmAlbumPhotoButton;
@synthesize shouldLaunchAsAVideoRecorder;
@synthesize isInVideoRecorderMode;
@synthesize shouldLaunchAshighQualityVideo;
@synthesize isHighQualityVideo;

#pragma mark - Video Camera Delegate
- (void)IFVideoCameraWillStartCaptureStillImage:(IFVideoCamera *)videoCamera {
    
    self.shootButton.hidden = YES;
    
    if (self.isInVideoRecorderMode == NO) {
        self.photoAlbumButton.hidden = YES;
    }
    
    [self.cancelAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraRejectDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    [self.confirmAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAcceptDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    self.cancelAlbumPhotoButton.hidden = NO;
    self.confirmAlbumPhotoButton.hidden = NO;
}
- (void)IFVideoCameraDidFinishCaptureStillImage:(IFVideoCamera *)videoCamera {
    [self.cancelAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraReject" ofType:@"png"]] forState:UIControlStateNormal];
    [self.confirmAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAccept" ofType:@"png"]] forState:UIControlStateNormal];
}
- (void)IFVideoCameraDidSaveStillImage:(IFVideoCamera *)videoCamera {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Your image was saved in Camera Roll." delegate:nil cancelButtonTitle:@"Sweet" otherButtonTitles:nil];
    [alertView show];
    
    [self.cancelAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraReject" ofType:@"png"]] forState:UIControlStateNormal];
    [self.confirmAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAccept" ofType:@"png"]] forState:UIControlStateNormal];
    self.cancelAlbumPhotoButton.enabled = YES;
    self.confirmAlbumPhotoButton.enabled = YES;
    
    [self cancelAlbumPhotoButtonPressed:nil];
}

- (BOOL)canIFVideoCameraStartRecordingMovie:(IFVideoCamera *)videoCamera {
    if (shootButton.hidden == YES) {
        return NO;
    } else if (self.videoCamera.isRecordingMovie == YES) {
        return NO;
    } else {
        return YES;
    }
}
- (void)IFVideoCameraWillStartProcessingMovie:(IFVideoCamera *)videoCamera {
    NSLog(@" - 1 -");
    [self.shootButton setTitle:@"Processing" forState:UIControlStateNormal];
    self.shootButton.enabled = NO;
}
- (void)IFVideoCameraDidFinishProcessingMovie:(IFVideoCamera *)videoCamera {
    NSLog(@" - 2 -");

    self.shootButton.enabled = YES;
    [self.shootButton setTitle:@"Record" forState:UIControlStateNormal];

}

#pragma mark - Process Album Photo from Image Pick
- (UIImage *)processAlbumPhoto:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    float original_width = originalImage.size.width;
    float original_height = originalImage.size.height;
    
    if ([info objectForKey:UIImagePickerControllerCropRect] == nil) {
        if (original_width < original_height) {
            /*
             UIGraphicsBeginImageContext(mask.size);
             [ori drawAtPoint:CGPointMake(0,0)];
             [mask drawAtPoint:CGPointMake(0,0)];
             
             UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             return newImage;
             */
            return nil;
        } else {
            return nil;
        }
    } else {
        CGRect crop_rect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        float crop_width = crop_rect.size.width;
        float crop_height = crop_rect.size.height;
        float crop_x = crop_rect.origin.x;
        float crop_y = crop_rect.origin.y;
        float remaining_width = original_width - crop_x;
        float remaining_height = original_height - crop_y;
        
        // due to a bug in iOS
        if ( (crop_x + crop_width) > original_width) {
            NSLog(@" - a bug in x direction occurred! now we fix it!");
            crop_width = original_width - crop_x;
        }
        if ( (crop_y + crop_height) > original_height) {
            NSLog(@" - a bug in y direction occurred! now we fix it!");
            
            crop_height = original_height - crop_y;
        }
        
        float crop_longer_side = 0.0f;
        
        if (crop_width > crop_height) {
            crop_longer_side = crop_width;
        } else {
            crop_longer_side = crop_height;
        }
        //NSLog(@" - ow = %g, oh = %g", original_width, original_height);
        //NSLog(@" - cx = %g, cy = %g, cw = %g, ch = %g", crop_x, crop_y, crop_width, crop_height);
        //NSLog(@" - cls=%g, rw = %g, rh = %g", crop_longer_side, remaining_width, remaining_height);
        if ( (crop_longer_side <= remaining_width) && (crop_longer_side <= remaining_height) ) {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, crop_longer_side, crop_longer_side)];
            
            return tmpImage;
        } else if ( (crop_longer_side <= remaining_width) && (crop_longer_side > remaining_height) ) {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, crop_longer_side, remaining_height)];
            
            float new_y = (crop_longer_side - remaining_height) / 2.0f;
            //UIGraphicsBeginImageContext(CGSizeMake(crop_longer_side, crop_longer_side));
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(crop_longer_side, crop_longer_side), YES, 1.0f);
            [tmpImage drawAtPoint:CGPointMake(0.0f,new_y)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        } else if ( (crop_longer_side > remaining_width) && (crop_longer_side <= remaining_height) ) {
            UIImage *tmpImage = [originalImage cropImageWithBounds:CGRectMake(crop_x, crop_y, remaining_width, crop_longer_side)];
            
            float new_x = (crop_longer_side - remaining_width) / 2.0f;
            //UIGraphicsBeginImageContext(CGSizeMake(crop_longer_side, crop_longer_side));
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(crop_longer_side, crop_longer_side), YES, 1.0f);
            [tmpImage drawAtPoint:CGPointMake(new_x,0.0f)];
            
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        } else {
            return nil;
        }
        
    }
}

#pragma mark - UIImagePicker Delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    self.videoCamera.rawImage = [self processAlbumPhoto:info];
    [self.videoCamera switchFilter:currentType];
    self.shootButton.hidden = YES;
    if (self.isInVideoRecorderMode == NO) {
        self.photoAlbumButton.hidden = YES;
    }
    self.cancelAlbumPhotoButton.hidden = NO;
    self.confirmAlbumPhotoButton.hidden = NO;
    
    if (isFiltersTableViewVisible == YES) {
        [self toggleFiltersButtonPressed:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:^(){
        if (isFiltersTableViewVisible == NO) {
            [self toggleFiltersButtonPressed:nil];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [self dismissViewControllerAnimated:YES completion:^(){

        [self.videoCamera startCameraCapture];
        
    }];
}

#pragma mark - Filters TableView Delegate & Datasource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFilterCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentType = [indexPath row];
    
    [self.videoCamera switchFilter:[indexPath row]];
    
    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    CGRect tempRect = self.blueDotImageView.frame;
    tempRect.origin.y = cellRect.origin.y + kBlueDotImageViewOffset;
    
    [UIView animateWithDuration:kBlueDotAnimationTime animations:^() {
        self.blueDotImageView.frame = tempRect;
    }completion:^(BOOL finished){
        // do nothing
    }];
    
    if (([indexPath row] != [[[tableView indexPathsForVisibleRows] objectAtIndex:0] row]) && ([indexPath row] != [[[tableView indexPathsForVisibleRows] lastObject] row])) {
        
        return;
    }
    
    if ([indexPath row] == [[[tableView indexPathsForVisibleRows] objectAtIndex:0] row]) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *filtersTableViewCellIdentifier = @"filtersTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: filtersTableViewCellIdentifier];
    UIImageView *filterImageView;
    UIView *filterImageViewContainerView;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filtersTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, -7.5, 57, 72)];
        filterImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        filterImageView.tag = kFilterImageViewTag;
        
        filterImageViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 57, 72)];
        filterImageViewContainerView.tag = kFilterImageViewContainerViewTag;
        [filterImageViewContainerView addSubview:filterImageView];
        
        [cell.contentView addSubview:filterImageViewContainerView];
    } else {
        filterImageView = (UIImageView *)[cell.contentView viewWithTag:kFilterImageViewTag];
    }
    
    switch ([indexPath row]) {
        case 0: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];

            break;
        }
        case 1: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileAmaro" ofType:@"png"]];
            
            break;
        }
        case 2: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileRise" ofType:@"png"]];
            
            break;
        }
        case 3: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHudson" ofType:@"png"]];
            
            break;
        }
        case 4: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileXpro2" ofType:@"png"]];
            
            break;
        }
        case 5: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSierra" ofType:@"png"]];
            
            break;
        }
        case 6: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLomoFi" ofType:@"png"]];
            
            break;
        }
        case 7: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileEarlybird" ofType:@"png"]];
            
            break;
        }
        case 8: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSutro" ofType:@"png"]];
            
            break;
        }
        case 9: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileToaster" ofType:@"png"]];
            
            break;
        }
        case 10: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileBrannan" ofType:@"png"]];
            
            break;
        }
        case 11: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileInkwell" ofType:@"png"]];
            
            break;
        }
        case 12: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileWalden" ofType:@"png"]];
            
            break;
        }
        case 13: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHefe" ofType:@"png"]];
            
            break;
        }
        case 14: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileValencia" ofType:@"png"]];
            
            break;
        }
        case 15: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNashville" ofType:@"png"]];
            
            break;
        }
        case 16: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTile1977" ofType:@"png"]];
            
            break;
        }
        case 17: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLordKelvin" ofType:@"png"]];
            break;
        }
            
        default: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];

            break;
        }
    }
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 18;
}


#pragma mark - UI Setup

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    
    self.isInVideoRecorderMode = self.shouldLaunchAsAVideoRecorder;
    self.isHighQualityVideo = self.shouldLaunchAshighQualityVideo;
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraBackground" ofType:@"png"]];
    
    self.cameraToolBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.cameraToolBarImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraToolbar" ofType:@"png"]];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(285, 10, 20, 20);
    [self.backButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraIconCancel" ofType:@"png"]] forState:UIControlStateNormal];
    self.backButton.adjustsImageWhenHighlighted = NO;
    self.backButton.showsTouchWhenHighlighted = YES;
    [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.transparentBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.transparentBackButton.frame = CGRectMake(270, 0, 50, 50);
    self.transparentBackButton.showsTouchWhenHighlighted = YES;
    [self.transparentBackButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.cameraCaptureBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 426, 320, 54)];
    self.cameraCaptureBarImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureBar" ofType:@"png"]];
    
    self.toggleFiltersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toggleFiltersButton.frame = CGRectMake(270, 433, 40, 40);
    [self.toggleFiltersButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraHideFilters" ofType:@"png"]] forState:UIControlStateNormal];
    self.toggleFiltersButton.adjustsImageWhenHighlighted = NO;
    self.toggleFiltersButton.showsTouchWhenHighlighted = YES;
    [self.toggleFiltersButton addTarget:self action:@selector(toggleFiltersButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isInVideoRecorderMode == NO) {
        self.photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoAlbumButton.frame = CGRectMake(10, 433, 40, 40);
        [self.photoAlbumButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraLibrary" ofType:@"png"]] forState:UIControlStateNormal];
        self.photoAlbumButton.adjustsImageWhenHighlighted = NO;
        self.photoAlbumButton.showsTouchWhenHighlighted = YES;
        [self.photoAlbumButton addTarget:self action:@selector(photoAlbumButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.isInVideoRecorderMode == NO) {
        self.shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shootButton.frame = CGRectMake(110, 433, 100, 40);
        [self.shootButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];
        self.shootButton.adjustsImageWhenHighlighted = NO;
        [self.shootButton addTarget:self action:@selector(shootButtonTouched:) forControlEvents:UIControlEventTouchDown];
        [self.shootButton addTarget:self action:@selector(shootButtonCancelled:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragOutside];
        [self.shootButton addTarget:self action:@selector(shootButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.shootButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.shootButton.frame = CGRectMake(110, 433, 100, 40);
        //[self.shootButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];
        //self.shootButton.adjustsImageWhenHighlighted = NO;
        [self.shootButton setTitle:@"Record" forState:UIControlStateNormal];
        [self.shootButton addTarget:self action:@selector(shootButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    
    self.cancelAlbumPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelAlbumPhotoButton.frame = CGRectMake(115, 433, 40, 40);
    [self.cancelAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraReject" ofType:@"png"]] forState:UIControlStateNormal];
    self.cancelAlbumPhotoButton.adjustsImageWhenHighlighted = NO;
    self.cancelAlbumPhotoButton.showsTouchWhenHighlighted = YES;
    self.cancelAlbumPhotoButton.hidden = YES;
    [self.cancelAlbumPhotoButton addTarget:self action:@selector(cancelAlbumPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.confirmAlbumPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmAlbumPhotoButton.frame = CGRectMake(170, 433, 40, 40);
    [self.confirmAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAccept" ofType:@"png"]] forState:UIControlStateNormal];
    self.confirmAlbumPhotoButton.adjustsImageWhenHighlighted = NO;
    self.confirmAlbumPhotoButton.showsTouchWhenHighlighted = YES;
    self.confirmAlbumPhotoButton.hidden = YES;
    [self.confirmAlbumPhotoButton addTarget:self action:@selector(confirmAlbumPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.isFiltersTableViewVisible = YES;
    self.filterTableViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 354, 320, 72)];
    self.filterTableViewContainerView.backgroundColor = [UIColor clearColor];
    
    self.filtersTableView = [[UITableView alloc] initWithFrame:CGRectMake(124, -124, 72, 320) style:UITableViewStylePlain];
    self.filtersTableView.backgroundColor = [UIColor clearColor];
    self.filtersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.filtersTableView.showsVerticalScrollIndicator = NO;
    self.filtersTableView.delegate = self;
    self.filtersTableView.dataSource = self;
    self.filtersTableView.transform	= CGAffineTransformMakeRotation(-M_PI/2);
    
    self.blueDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-3, kBlueDotImageViewOffset + 4, 21, 11)];
    self.blueDotImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraSelectedFilter" ofType:@"png"]];
    self.blueDotImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [self.filtersTableView addSubview:self.blueDotImageView];
    
    self.cameraTrayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 29)];
    self.cameraTrayImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraTray" ofType:@"png"]];
    
    [self.filterTableViewContainerView addSubview:self.cameraTrayImageView];
    [self.filterTableViewContainerView addSubview:self.filtersTableView];
    
    self.videoCamera = [[IFVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack highVideoQuality:self.isHighQualityVideo];
    self.videoCamera.delegate = self;
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.transparentBackButton];
    [self.view addSubview:self.cameraToolBarImageView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.videoCamera.gpuImageView];
    [self.view addSubview:self.filterTableViewContainerView];
    [self.view addSubview:self.cameraCaptureBarImageView];
    [self.view addSubview:self.photoAlbumButton];
    [self.view addSubview:self.shootButton];
    [self.view addSubview:self.cancelAlbumPhotoButton];
    [self.view addSubview:self.confirmAlbumPhotoButton];
    [self.view addSubview:self.toggleFiltersButton];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.videoCamera startCameraCapture];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button methods
- (void)cancelAlbumPhotoButtonPressed:(id)sender {
    self.cancelAlbumPhotoButton.hidden = YES;
    self.confirmAlbumPhotoButton.hidden = YES;
    self.shootButton.hidden = NO;
    if (self.isInVideoRecorderMode == NO) {
        self.photoAlbumButton.hidden = NO;
    }
    [self.videoCamera cancelAlbumPhotoAndGoBackToNormal];
}
- (void)confirmAlbumPhotoButtonPressed:(id)sender {
    [self.cancelAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraRejectDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    [self.confirmAlbumPhotoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraAcceptDisabled" ofType:@"png"]] forState:UIControlStateNormal];
    self.cancelAlbumPhotoButton.enabled = NO;
    self.confirmAlbumPhotoButton.enabled = NO;
    
    [self.videoCamera saveCurrentStillImage];
}

- (void)shootButtonTouched:(id)sender {
    [self.shootButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButtonPressed" ofType:@"png"]] forState:UIControlStateNormal];

}
- (void)shootButtonCancelled:(id)sender {
    [self.shootButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];

}
- (void)photoAlbumButtonPressed:(id)sender {
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:^(){
        // do nothing
        picker = nil;
    }];
}
- (void)shootButtonPressed:(id)sender {
    
    if (self.isInVideoRecorderMode == YES) {
        if (self.videoCamera.isRecordingMovie == NO) {
            NSLog(@" - starts...");
            
            [self.shootButton setTitle:@"STOP" forState:UIControlStateNormal];
            
            self.toggleFiltersButton.enabled = NO;
            self.filtersTableView.userInteractionEnabled = NO;
            if (self.isFiltersTableViewVisible == YES) {
                [self toggleFiltersButtonPressed:nil];
            }
            
            [self.videoCamera startRecordingMovie];
        } else {
            NSLog(@" - stops...");
            [self.videoCamera stopRecordingMovie];
            self.toggleFiltersButton.enabled = YES;
            self.filtersTableView.userInteractionEnabled = YES;
            
        }
    } else {
         [self.shootButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraCaptureButton" ofType:@"png"]] forState:UIControlStateNormal];
         [self.videoCamera takePhoto];
    }
    

}
- (void)backButtonPressed:(id)sender {
    
    if (self.videoCamera.isRecordingMovie == YES) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^() {
        // do nothing
    }];
}

- (void)toggleFiltersButtonPressed:(id)sender {
    
    BOOL originalEnabledValue = self.toggleFiltersButton.enabled;
    
    self.toggleFiltersButton.enabled = NO;
    
    if (isFiltersTableViewVisible == YES) {
        
        [self.toggleFiltersButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraShowFilters" ofType:@"png"]] forState:UIControlStateNormal];
        self.isFiltersTableViewVisible = NO;
        
        CGRect tempRect = self.filterTableViewContainerView.frame;
        tempRect.origin.y = tempRect.origin.y + kFilterCellHeight;
        
        CGRect tempRectForGPUImageView = self.videoCamera.gpuImageView.frame;
        tempRectForGPUImageView.origin.y = tempRectForGPUImageView.origin.y + kGPUImageViewAnimationOffset;

        [UIView animateWithDuration:kFilterTableViewAnimationTime animations:^(){
            self.filterTableViewContainerView.frame = tempRect;
            self.videoCamera.gpuImageView.frame = tempRectForGPUImageView;
        }completion:^(BOOL finished) {
            self.toggleFiltersButton.enabled = originalEnabledValue;
        }];
        

    } else {
        
        [self.toggleFiltersButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"glCameraHideFilters" ofType:@"png"]] forState:UIControlStateNormal];
        self.isFiltersTableViewVisible = YES;
        
        CGRect tempRect = self.filterTableViewContainerView.frame;
        tempRect.origin.y = tempRect.origin.y - kFilterCellHeight;
        
        CGRect tempRectForGPUImageView = self.videoCamera.gpuImageView.frame;
        tempRectForGPUImageView.origin.y = tempRectForGPUImageView.origin.y - kGPUImageViewAnimationOffset;
        
        [UIView animateWithDuration:kFilterTableViewAnimationTime animations:^(){
            self.filterTableViewContainerView.frame = tempRect;
            self.videoCamera.gpuImageView.frame = tempRectForGPUImageView;
        }completion:^(BOOL finished) {
            self.toggleFiltersButton.enabled = originalEnabledValue;
        }];
        

    }
}


#pragma mark - View Will/Did Appear/Disappear
- (void)viewWillAppear:(BOOL)animated {
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    if ([self.videoCamera isRecordingMovie] == YES) {
        [self.videoCamera stopRecordingMovie];
    }
    
    [self.videoCamera stopCameraCapture];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}


@end
