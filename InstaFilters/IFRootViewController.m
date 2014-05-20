//
//  IFRootViewController.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "IFRootViewController.h"
#import "IFFiltersViewController.h"
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>

@interface IFRootViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *lowQualityVideoButton;
@property (nonatomic, strong) UIButton *highQualityVideoButton;
@property (nonatomic, strong) UITextView *firstTextView;
@property (nonatomic, strong) UITextView *secondTextView;
@property (nonatomic, strong) UITextView *thirdTextView;
@property (nonatomic, strong) UITextView *diwupTextView;
@property (nonatomic, strong) UIButton *tweetButton;
@property (nonatomic, strong) UIButton *emailButton;

- (void)startButtonPressed:(id)sender;
- (void)startButtonTouched:(id)sender;
- (void)startButtonTouchCancelled:(id)sender;
- (void)tweetButtonPressed:(id)sender;
- (void)emailButtonPressed:(id)sender;
@end

@implementation IFRootViewController

@synthesize startButton;
@synthesize lowQualityVideoButton;
@synthesize highQualityVideoButton;
@synthesize firstTextView;
@synthesize secondTextView;
@synthesize thirdTextView;
@synthesize diwupTextView;
@synthesize tweetButton;
@synthesize emailButton;

#pragma mark - Init
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
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.tag = 1;
    self.startButton.frame = CGRectMake(240, 40, 64, 45);
    [self.startButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabBar-camera" ofType:@"png"]] forState:UIControlStateNormal];
    self.startButton.adjustsImageWhenHighlighted = NO;
    [self.startButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchDown];
    [self.startButton addTarget:self action:@selector(startButtonTouchCancelled:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragOutside];

    self.lowQualityVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lowQualityVideoButton.tag = 2;
    self.lowQualityVideoButton.frame = CGRectMake(240, 125, 64, 45);
    [self.lowQualityVideoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabBar-camera" ofType:@"png"]] forState:UIControlStateNormal];
    self.lowQualityVideoButton.adjustsImageWhenHighlighted = NO;
    [self.lowQualityVideoButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.lowQualityVideoButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchDown];
    [self.lowQualityVideoButton addTarget:self action:@selector(startButtonTouchCancelled:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragOutside];

    self.highQualityVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.highQualityVideoButton.tag = 3;
    self.highQualityVideoButton.frame = CGRectMake(240, 207, 64, 45);
    [self.highQualityVideoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabBar-camera" ofType:@"png"]] forState:UIControlStateNormal];
    self.highQualityVideoButton.adjustsImageWhenHighlighted = NO;
    [self.highQualityVideoButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.highQualityVideoButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchDown];
    [self.highQualityVideoButton addTarget:self action:@selector(startButtonTouchCancelled:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragOutside];

    self.firstTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, 235, 100)];
    self.secondTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, 235, 100)];
    self.thirdTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 190, 235, 100)];
    
    self.firstTextView.userInteractionEnabled = NO;
    self.secondTextView.userInteractionEnabled = NO;
    self.thirdTextView.userInteractionEnabled = NO;
    
    self.firstTextView.font = [UIFont systemFontOfSize:15.0f];
    self.secondTextView.font = [UIFont systemFontOfSize:15.0f];
    self.thirdTextView.font = [UIFont systemFontOfSize:15.0f];
    
    self.firstTextView.text = @"A standard implementation of Instagram's filters view controller.";
    self.secondTextView.text = @"A video enabled version, with good fps(frames per second). Quality: 240 pixel x 240 pixel.";
    self.thirdTextView.text = @"Another video enabled version, with lower fps.\nQuality: 480 pixel x 480 pixel. ";
    
    self.diwupTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 290, 300, 50)];
    self.diwupTextView.font = [UIFont systemFontOfSize:15.0f];
    self.diwupTextView.text = @"Twitter: @diwup\nEmail: diwufet@gmail.com";
    self.diwupTextView.userInteractionEnabled = NO;    
    
    self.tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tweetButton.backgroundColor = [UIColor grayColor];
    self.tweetButton.frame = CGRectMake(13, 380, 140, 35);
    [self.tweetButton setTitle:@"Tweet this repo" forState:UIControlStateNormal];
    [self.tweetButton addTarget:self action:@selector(tweetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.tweetButton.showsTouchWhenHighlighted = YES;
    
    self.emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emailButton.backgroundColor = [UIColor grayColor];
    self.emailButton.frame = CGRectMake(163, 380, 140, 35);
    [self.emailButton setTitle:@"Email me" forState:UIControlStateNormal];
    [self.emailButton addTarget:self action:@selector(emailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.emailButton.showsTouchWhenHighlighted = YES;
    
    [self.view addSubview:self.firstTextView];
    [self.view addSubview:self.secondTextView];
    [self.view addSubview:self.thirdTextView];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.lowQualityVideoButton];
    [self.view addSubview:self.highQualityVideoButton];
    
    [self.view addSubview:self.diwupTextView];
    [self.view addSubview:self.tweetButton];
    [self.view addSubview:self.emailButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

#pragma mark - Buttons methods
- (void)startButtonPressed:(id)sender {
    
    __block IFFiltersViewController *filtersViewController = [[IFFiltersViewController alloc] init];

    UIButton *aButton = (UIButton *)sender;
    
    switch (aButton.tag) {
        case 1: {
            filtersViewController.shouldLaunchAsAVideoRecorder = NO;
            filtersViewController.shouldLaunchAshighQualityVideo = NO;
            break;
        }
         
        case 2: {
            filtersViewController.shouldLaunchAsAVideoRecorder = YES;
            filtersViewController.shouldLaunchAshighQualityVideo = NO;
            break;
        }
        case 3: {
            filtersViewController.shouldLaunchAsAVideoRecorder = YES;
            filtersViewController.shouldLaunchAshighQualityVideo = YES;
            break;
        }
        default:
            break;
    }

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:filtersViewController animated:YES completion:^(){
        filtersViewController = nil;
        [aButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabBar-camera" ofType:@"png"]] forState:UIControlStateNormal];

    }];
}
- (void)startButtonTouched:(id)sender {
    UIButton *aButton = (UIButton *)sender;
    [aButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabBar-camera-on" ofType:@"png"]] forState:UIControlStateNormal];

}
- (void)startButtonTouchCancelled:(id)sender {
    UIButton *aButton = (UIButton *)sender;
    [aButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabBar-camera" ofType:@"png"]] forState:UIControlStateNormal];

}
- (void)tweetButtonPressed:(id)sender {
    if ([TWTweetComposeViewController canSendTweet] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You need to set up your Twitter account on your iPhone first." delegate:nil cancelButtonTitle:@"Oh ok" otherButtonTitles:nil];
        [alertView show];
    } else {
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        [tweetViewController setInitialText:@"Instagram filters hacked and open sourced. Supports both photo and video. via @diwup https://github.com/diwu/InstaFilters"];
        
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            // do nothing
            [self dismissViewControllerAnimated:YES completion:^() {
                // do nothing
            }];
        }];
        
        // Present the tweet composition view controller modally.
        [self presentViewController:tweetViewController animated:YES completion:^() {
            // do nothing
        }];

    }
}
- (void)emailButtonPressed:(id)sender {
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You need to set up your email account on your iPhone first." delegate:nil cancelButtonTitle:@"Oh ok" otherButtonTitles:nil];
        [alertView show];
    } else {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:[NSArray arrayWithObject:@"diwufet@gmail.com"]];
        [mailController setSubject:@"InstaFilters"];
        [self presentViewController:mailController animated:YES completion:^() {
            // do nothing
        }];
    }
}

#pragma mark - Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:^() {
        // do nothing
    }];

}


@end
