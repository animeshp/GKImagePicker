//
//  GKImageCropViewController.m
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import "GKImageCropViewController.h"
#import "GKImageCropView.h"

@interface GKImageCropViewController ()

@property (nonatomic, strong) GKImageCropView *imageCropView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *useButton;
@property (nonatomic, getter = isReturning) BOOL returning;

- (void)_actionCancel;
- (void)_actionUse;
- (void)_setupNavigationBar;
- (void)_setupCropView;

@end

@implementation GKImageCropViewController

#pragma mark -
#pragma Private Methods


- (void)_actionCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)_actionUse{
    if (!self.isReturning) {
        self.returning = YES;
        if (self.imageCropView.scrollView.isZooming || self.imageCropView.scrollView.isZoomBouncing || self.imageCropView.scrollView.isDragging || self.imageCropView.scrollView.isDecelerating) {
            self.imageCropView.delegate = self;
        } else {
            [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
            self.delegate = nil;
        }
    }
}


- (void)_setupNavigationBar{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(_actionCancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GKIuse", @"")
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(_actionUse)];
}


- (void)_setupCropView{
    CGRect frame = self.view.bounds;
    self.imageCropView = [[GKImageCropView alloc] initWithFrame:frame imageToCrop:self.sourceImage crop:self.crop cropSize:self.cropSize minimumCropSize:self.minimumCropSize];
    [self.view addSubview:self.imageCropView];
}

- (void)_setupCancelButton{
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [[self.cancelButton titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [[self.cancelButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [self.cancelButton setFrame:CGRectMake(0, 0, 58, 30)];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
    [self.cancelButton  addTarget:self action:@selector(_actionCancel) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)_setupUseButton{
    
    self.useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [[self.useButton titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [[self.useButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [self.useButton setFrame:CGRectMake(0, 0, 58, 30)];
    [self.useButton setTitle:@"Choose" forState:UIControlStateNormal];
    [self.useButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
    [self.useButton  addTarget:self action:@selector(_actionUse) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIImage *)_toolbarBackgroundImage{
    
    CGFloat components[] = {
        1., 1., 1., 1.,
        123./255., 125/255., 132./255., 1.
    };
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), 50), YES, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawLinearGradient(ctx, gradient, CGPointZero, CGPointMake(0, 50), nil);
        
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
	CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)_setupToolbar{
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolbar.translucent = YES;
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:self.toolbar];
    
    [self _setupCancelButton];
    [self _setupUseButton];
    
        
//        [NSLocalizedString(@"GKImoveAndScale", @"") drawInRect:CGRectMake(10, (height - heightSpan) + (heightSpan / 2 - 20 / 2) , width - 20, 20)
//                                                      withFont:[UIFont boldSystemFontOfSize:20]
//                                                 lineBreakMode:NSLineBreakByTruncatingTail
//                                                     alignment:NSTextAlignmentCenter];
//        
//    }
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        info.text = NSLocalizedString(@"GKImoveAndScale", @"");
    } else {
        info.text = @"";
    }
    info.textColor = [UIColor whiteColor];
    info.backgroundColor = [UIColor clearColor];
    info.shadowColor = [UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1];
    info.shadowOffset = CGSizeMake(0, -1);
    info.font = [UIFont boldSystemFontOfSize:18];
    [info sizeToFit];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *lbl = [[UIBarButtonItem alloc] initWithCustomView:info];
    UIBarButtonItem *use = [[UIBarButtonItem alloc] initWithCustomView:self.useButton];
    
    [self.toolbar setItems:[NSArray arrayWithObjects:cancel, flex, lbl, flex, use, nil]];
}

#pragma mark -
#pragma Super Class Methods

- (void)dealloc
{
    self.imageCropView.delegate = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"GKIchoosePhoto", @"");
    
    [self _setupNavigationBar];
    [self _setupCropView];
    [self _setupToolbar];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.toolbar = nil;
    self.cancelButton = nil;
    self.useButton = nil;
    self.imageCropView = nil;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        self.toolbar.frame = CGRectMake(0, self.view.safeAreaLayoutGuide.layoutFrame.size.height - 50, self.view.frame.size.width, 50);
    } else {
        self.toolbar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (self.isReturning && !self.imageCropView.scrollView.isZooming && !self.imageCropView.scrollView.isZoomBouncing && !self.imageCropView.scrollView.isDragging && !self.imageCropView.scrollView.isDecelerating) {
        [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
        self.imageCropView.delegate = nil;
        self.delegate = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isReturning && !self.imageCropView.scrollView.isZooming && !self.imageCropView.scrollView.isZoomBouncing && !self.imageCropView.scrollView.isDragging && !self.imageCropView.scrollView.isDecelerating) {
        [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
        self.imageCropView.delegate = nil;
        self.delegate = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isReturning && !self.imageCropView.scrollView.isZooming && !self.imageCropView.scrollView.isZoomBouncing && !self.imageCropView.scrollView.isDragging && !self.imageCropView.scrollView.isDecelerating && !decelerate) {
        [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
        self.imageCropView.delegate = nil;
        self.delegate = nil;
    }
}

@end
