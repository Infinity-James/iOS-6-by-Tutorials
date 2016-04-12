//
//  BTDetailViewController.m
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import "BTPhotosViewController.h"
#import "BTPhotoViewController.h"
#import "ThemeManager.h"

@interface BTPhotosViewController ()
@property (nonatomic,strong) NSMutableArray* photos;
@property (strong, nonatomic) UIPageViewController *pageViewController;

- (void)configureView;
@end

@implementation BTPhotosViewController

#pragma mark - Managing the detail item

- (void)configureView
{
    if (self.pageViewController) {
        [self.pageViewController.view removeFromSuperview];
        [self.pageViewController removeFromParentViewController];
    }
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:@{UIPageViewControllerOptionInterPageSpacingKey: @25.0}];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:0 storyboard:self.storyboard]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSBundle* bundle = [NSBundle mainBundle];
    
    self.photos = [NSMutableArray array];
    [self.photos addObject:[NSData dataWithContentsOfFile:[bundle pathForResource:@"photo1" ofType:@"png"]]];
    [self.photos addObject:[NSData dataWithContentsOfFile:[bundle pathForResource:@"photo2" ofType:@"png"]]];
    [self.photos addObject:[NSData dataWithContentsOfFile:[bundle pathForResource:@"photo3" ofType:@"png"]]];
    [self.photos addObject:[NSData dataWithContentsOfFile:[bundle pathForResource:@"photo4" ofType:@"png"]]];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[ThemeManager customiseView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BTPhotoViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.photos count] == 0) || (index >= [self.photos count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    BTPhotoViewController *photoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    [photoViewController setPhotoData:self.photos[index]];
    return photoViewController;
}

- (NSUInteger)indexOfViewController:(BTPhotoViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.photos indexOfObject:viewController.photoData];
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(BTPhotoViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(BTPhotoViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.photos count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.photos count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    if (![pageViewController respondsToSelector:@selector(photoData)])
        return 0;
    
    return [self indexOfViewController:(BTPhotoViewController*)pageViewController];
}

- (IBAction)ibaAddPhoto:(id)sender {
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setDelegate:self];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* edittedImage = info[UIImagePickerControllerOriginalImage];
    [self.photos addObject:UIImagePNGRepresentation(edittedImage)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self configureView];
}
@end
