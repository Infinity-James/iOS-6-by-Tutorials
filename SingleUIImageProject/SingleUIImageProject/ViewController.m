//
//  ViewController.m
//  SingleUIImageProject
//
//  Created by Jake Gundersen on 7/9/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
	EAGLContext								*_context;
	CIContext								*_coreImageContext;
	CIImage									*_image;
	CIFilter								*_sepiaFilter;
}

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (IBAction)changeSlider:(id)sender;

@end

@implementation ViewController

#pragma mark - Action & Selector Methods

- (IBAction)changeSlider:(UISlider *)slider
{
	//	update the intensity of the sepia filter to match the slider
	[_sepiaFilter setValue:@(slider.value) forKey:@"inputIntensity"];
	
	//	use the core image context to efficiently get reference to a core graphics image
	CGImageRef cgImage						= [_coreImageContext createCGImage:_sepiaFilter.outputImage fromRect:_sepiaFilter.outputImage.extent];
	
	//	use the cgimage to get a yiimage to display in the image view
	self.imageView.image					= [UIImage imageWithCGImage:cgImage];
	
	//	clean up the cgimage as it is part of core foundation
	CGImageRelease(cgImage);
}

#pragma mark - Autorotation

/**
 *	returns whether the view controller’s contents should auto rotate
 */
- (BOOL)shouldAutorotate
{
	return YES;
}

/**
 *	returns all of the interface orientations that the view controller supports
 */
- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Convenience & Helper Methods

/**
 *	initialises the contexts we need
 */
- (void)createContexts
{
	_context								= [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	NSAssert(_context, @"EAGL Context was not successfully created.");
	
	_coreImageContext						= [CIContext contextWithEAGLContext:_context];
	NSAssert(_coreImageContext, @"Core Image Context was not successfully created.");
}

/**
 *	creates ciimage from png file and displays as uiimage on image view
 */
- (void)createCIImageForName:(NSString *)imageName andType:(NSString *)fileType
{
	NSString *imagePath						= [[NSBundle mainBundle] pathForResource:imageName ofType:fileType];
    NSURL *imageURL							= [NSURL fileURLWithPath:imagePath];
    _image									= [CIImage imageWithContentsOfURL:imageURL];
}

/**
 *	returns a cifilter for an image
 */
- (void)createSepiaFilterForCIImage:(CIImage *)image withIntensity:(NSNumber *)intensity
{
	_sepiaFilter							= [CIFilter filterWithName:@"CISepiaTone"];
	[_sepiaFilter setValue:image forKey:kCIInputImageKey];
	[_sepiaFilter setValue:intensity forKey:@"inputIntensity"];
}

- (void)printOutAvailableFilters
{
	NSArray *filters						= [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
	
	NSLog(@"Amount of filters: %i", filters.count);
	
	for (NSString *filter in filters)
		NSLog(@"Filter name: %@\n", filter),	NSLog(@"Filter Attributes: %@", [CIFilter filterWithName:filter].attributes);
}

/**
 *	sort out image view
 */
- (void)sortOutImageView
{
	//	get the png file as a ciimage and create the sepia filter for the image
	[self createCIImageForName:@"hubble" andType:@"png"];
	[self createSepiaFilterForCIImage:_image withIntensity:@1.0];
	
	//	use the core image context to efficiently get reference to a core graphics image
	CGImageRef cgImage						= [_coreImageContext createCGImage:_sepiaFilter.outputImage fromRect:_sepiaFilter.outputImage.extent];
	
	//	use the cgimage to get a yiimage to display in the image view
	self.imageView.image					= [UIImage imageWithCGImage:cgImage];
	
	//	clean up the cgimage as it is part of core foundation
	CGImageRelease(cgImage);
}

#pragma mark - View Lifecycle

/**
 *	sent to the view controller when the app receives a memory warning
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self printOutAvailableFilters];
	
	[self createContexts];
	[self sortOutImageView];
}

@end