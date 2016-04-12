#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeAppearance];
    
    return YES;
}

- (void)customizeAppearance
{
    
    // customize the appearance of the navigation bar and toolbar
    UIImage *navBarBackground = [[UIImage imageNamed:@"toolbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarBackground forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:navBarBackground forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // customize title text for *all* UINavigationBars and UIToolBars
    NSDictionary *fontAttribs = @{
        UITextAttributeTextColor : [UIColor colorWithRed:77.0/255.0 green:46.0/255.0 blue:10.0/255.0 alpha:1.0],
        UITextAttributeTextShadowColor : [UIColor colorWithRed:241.0/255.0 green:225.0/255.0 blue:203/255.0 alpha:1.0],
        UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
        UITextAttributeFont : [UIFont fontWithName:@"Georgia" size:24.0]
    };
    
    [[UINavigationBar appearance] setTitleTextAttributes: fontAttribs];
}

@end
