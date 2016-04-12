#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#import "ViewController.h"

@interface UIImagePickerController(Nonrotating)

- (BOOL)shouldAutorotate;

@end

@implementation UIImagePickerController(Nonrotating)

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

@interface ViewController ()  <AVCaptureVideoDataOutputSampleBufferDelegate>
{
	dispatch_queue_t					_captureQueue;
	EAGLContext							*_context;
	CIContext							*_coreImageContext;
	UISegmentedControl					*_filterSegment;
	GLKView								*_glView;
	BOOL								_scaleFactorSet;
	AVCaptureSession					*_session;
}

@end

@implementation ViewController

#pragma mark - Action & Selector Methods

- (IBAction)recordSelected
{
	
}

- (IBAction)videoPickerSelected
{
	
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
	return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate Methods

/**
 *	notifies the delegate that a new video frame was written
 *
 *	@param	captureOutput				capture output object
 *	@param	sampleBuffer				cmsamplebuffer object containing video frame data and additional info about frame (format, presentation time...)
 *	@param	connection					connection from which the video was received
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection
{
	//	get pixel buffer reference fram samplebufferref
	CVPixelBufferRef pixelBuffer		= (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
	NSInteger width						= CVPixelBufferGetWidth(pixelBuffer);
	NSInteger height					= CVPixelBufferGetHeight(pixelBuffer);
	
	if (!_scaleFactorSet)
		_glView.contentScaleFactor		= width / _glView.bounds.size.width,
		_scaleFactorSet					= YES;
	
	//	create ciimage from pixel buffer
	CIImage *image						= [CIImage imageWithCVPixelBuffer:pixelBuffer];
	
	if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		image							= [image imageByApplyingTransform:CGAffineTransformMakeRotation(M_PI)];
		image							= [image imageByApplyingTransform:CGAffineTransformMakeTranslation(width, height)];
	}
	
	//	apply selected filter to the image
	image								= [self checkSelectedFilterForImage:image];
	
	//	use core image context to render the image to the render buffer then display the buffer to the glview
	[_coreImageContext drawImage:image inRect:image.extent fromRect:image.extent];
	[_context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - Convenience & Helper Methods

- (CIImage *)checkSelectedFilterForImage:(CIImage *)image
{
	CIImage *returnImage				= image;
	
	switch (_filterSegment.selectedSegmentIndex)
	{
		case 0:		break;
		case 1:		break;
		case 2:		break;
		case 3:		returnImage = [self kaleidoscope:image];	break;
		case 4:		returnImage = [self bloom:image];			break;
		default:	break;
	}
	
	return returnImage;
}

/**
 *	initialises the contexts we need
 */
- (void)createContexts
{
	//	eaglcontext manages the state and communicates opengl commands to gpu
	_context							= [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	NSAssert(_context, @"EAGLContext was not successfully created.");
	
	//	instantiate cicontext which is gpu-based, it will handle drawing in core image
	_coreImageContext					= [CIContext contextWithEAGLContext:_context];
	NSAssert(_coreImageContext, @"Core Image Context was not successfully created.");
}

/**
 *	set up capture session that takes video from camera and outputs pixel data to delegate method
 */
- (void)setupSession
{
	//	create avcapturesession object and start the catch of configuration changes which will be handled atomically at end
	_session							= [[AVCaptureSession alloc] init];
	[_session beginConfiguration];
	
	//	set incoming video resolution
	if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh])
		[_session setSessionPreset:AVCaptureSessionPresetHigh];
	
	//	get array of all input devices on current hardware and get the default camera (the back camera)
	NSArray *devices					= [AVCaptureDevice devices];
	AVCaptureDevice *videoDevice		= [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	//	if we find a front camera we'll use that, if not we'll use the default back camera
	for (AVCaptureDevice *device in devices)
		if (device.position == AVCaptureDevicePositionFront && [device hasMediaType:AVMediaTypeVideo])
		{
			videoDevice					= device;
			break;
		}
	
	//	create input object using the device we just determined and add to session
	NSError *error;
	AVCaptureDeviceInput *videoInput	= [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
	[_session addInput:videoInput];
	
	//	creates output object which supplies raw pixel data for each frame and set pixel format (32bgra recommend for core image)
	AVCaptureVideoDataOutput *videoOutput	= [[AVCaptureVideoDataOutput alloc] init];
	[videoOutput setAlwaysDiscardsLateVideoFrames:YES];
	[videoOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey	: @(kCVPixelFormatType_32BGRA)}];
	
	//	create new queue for processing data and set delegate which receives pixel buffers
	_captureQueue						= dispatch_queue_create("com.andbeyond.captureProcessingQueue", NULL);
	[videoOutput setSampleBufferDelegate:self queue:_captureQueue];
	
	//	adds output to the session, commit the configuration as a batch and start a capture session
	[_session addOutput:videoOutput];
	[_session commitConfiguration];
	[_session startRunning];
}

#pragma mark - Filter Methods

/**
 *	adds a bloom effect to an image
 *
 *	@param	inputImage					image to add a bloom effect to
 */
- (CIImage *)bloom:(CIImage *)inputImage
{
	//	initialise filer and set parameter values
	CIFilter *bloom						= [CIFilter filterWithName:@"CIBloom"];
	[bloom setValue:inputImage forKey:kCIInputImageKey];
	[bloom setValue:@100.0f forKey:@"inputRadius"];
	[bloom setValue:@1.0f forKey:@"inputIntensity"];
	
	return bloom.outputImage;
}

- (CIImage *)kaleidoscope:(CIImage *)inputImage
{
	CIFilter *kaleidoscope				= [CIFilter filterWithName:@"CIXiffoldRotatesTile"];
	[kaleidoscope setValue:inputImage forKey:kCIInputImageKey];
	[kaleidoscope setValue:[CIVector vectorWithCGPoint:CGPointMake(_glView.bounds.size.width / 2, _glView.bounds.size.height / 2)] forKey:@"inputCenter"];
	[kaleidoscope setValue:@200 forKey:@"inputWidth"];
	
	CFAbsoluteTime timeNow				= CFAbsoluteTimeGetCurrent();
	timeNow								= (fmodl(timeNow, 4 * 6.28f) / 4.0) - M_PI;
	[kaleidoscope setValue:@(timeNow) forKey:@"inputAngle"];
	
	CIFilter *crop						= [CIFilter filterWithName:@"CICrop"];
	[crop setValue:kaleidoscope.outputImage forKey:kCIInputImageKey];
	[crop setValue:[CIVector vectorWithCGRect:inputImage.extent] forKey:@"inputRectangle"];
	
	return crop.outputImage;
}

#pragma mark - Set Up View

/**
 *	add the controls and buttons on the view
 */
- (void)addControls
{
	//	set up a segmented control which allows for selecting different filters on the video
	_filterSegment						= [[UISegmentedControl alloc] initWithItems:@[@"Edge", @"Old", @"Faces", @"Kaleidoscope", @"Bloom"]];
	_filterSegment.segmentedControlStyle= UISegmentedControlStyleBar;
	
	for (NSInteger index = 0; index < _filterSegment.numberOfSegments; index++)
		[_filterSegment setWidth:90.0f forSegmentAtIndex:index];
	
	[_filterSegment setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:_filterSegment];
}

/**
 *	adds the glkview which is a default implementation of an opengl es aware view
 */
- (void)addGLKView
{
	//	initialise with our opengl with an eagl context
	_glView								= [[GLKView alloc] initWithFrame:self.view.frame context:_context];
	_glView.layer.anchorPoint			= CGPointMake(0.5, 0.5);
	_scaleFactorSet						= NO;
	
	[self.view addSubview:_glView];
}

/**
 *	add bar button items to the navigation bar
 */
- (void)addNavigationButtons
{
	UIBarButtonItem *videoPicker		= [[UIBarButtonItem alloc] initWithTitle:@"Video Picker"
																		   style:UIBarButtonItemStylePlain
																		  target:self
																		  action:@selector(videoPickerSelected)];
	UIBarButtonItem *record				= [[UIBarButtonItem alloc] initWithTitle:@"Record"
																		   style:UIBarButtonItemStylePlain
																		  target:self
																		  action:@selector(recordSelected)];
	[self.navigationItem setLeftBarButtonItem:videoPicker];
	[self.navigationItem setRightBarButtonItem:record];
}

/**
 *	handle the look and properties of the view
 */
- (void)setUpView
{
	[self addGLKView];
	[self addNavigationButtons];
	[self addControls];
	
	[self.view setNeedsUpdateConstraints];
}

#pragma mark - UIViewController Methods

/**
 *	called when the view controller’s view needs to update its constraints
 */
- (void)updateViewConstraints
{
	[super updateViewConstraints];
	
	//	remove all constraints
	[self.view removeConstraints:self.view.constraints];
	
	//	objects to be used in creating constraints
	NSLayoutConstraint *constraint;
	NSArray *constraints;
	NSDictionary *viewsDictionary;
	
	//	dictionary of views to apply constraints to
	viewsDictionary	= NSDictionaryOfVariableBindings(_filterSegment);
	
	//	set up constraints for segmented control
	constraint							= [NSLayoutConstraint constraintWithItem:_filterSegment attribute:NSLayoutAttributeCenterX
													relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX
													multiplier:1.0f constant:0.0f];
	[self.view addConstraint:constraint];
	
	constraints							= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_filterSegment]"
																options:kNilOptions metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
}

#pragma mark - View Lifecycle


/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self setUpView];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self createContexts];
	[self setupSession];
}

@end