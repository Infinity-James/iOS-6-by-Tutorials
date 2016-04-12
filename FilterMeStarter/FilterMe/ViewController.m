//
//  ViewController.m
//  FilterMe
//
//  Created by Jake Gundersen on 7/11/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.

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
	UISegmentedControl					*_effectPicker;
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
	//	get pixel buffer reference fram samplebufferref and then get height and width of pixel buffer
	CVPixelBufferRef pixelBuffer		= (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
	NSInteger width						= CVPixelBufferGetWidth(pixelBuffer);
	NSInteger height					= CVPixelBufferGetHeight(pixelBuffer);
	NSLog(@"Sample Buffer: (%i, %i)", width, height);
}

#pragma mark - Convenience & Helper Methods

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

#pragma mark - Set Up View

- (void)addControls
{
	_effectPicker						= [[UISegmentedControl alloc] initWithItems:@[@"Edge", @"Old", @"Faces", @"Kaleidoscope", @"Bloom"]];
	_effectPicker.segmentedControlStyle	= UISegmentedControlStyleBar;
	
	for (NSInteger index = 0; index < _effectPicker.numberOfSegments; index++)
		[_effectPicker setWidth:90.0f forSegmentAtIndex:index];
	
	[_effectPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:_effectPicker];
}

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

- (void)setUpView
{
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
	viewsDictionary	= NSDictionaryOfVariableBindings(_effectPicker);
	
	//	set up constraints for segmented control
	constraint							= [NSLayoutConstraint constraintWithItem:_effectPicker attribute:NSLayoutAttributeCenterX
													relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX
													multiplier:1.0f constant:0.0f];
	[self.view addConstraint:constraint];
	
	constraints							= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_effectPicker]"
																options:kNilOptions metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
}

#pragma mark - View Lifecycle

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupSession];
	[self setUpView];
}

@end