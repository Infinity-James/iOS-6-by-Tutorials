//
//  BTMasterViewController.m
//  AppearanceChapter
//
//  Created by Adam Burkepile on 7/16/12.
//  Copyright (c) 2012 Adam Burkepile. All rights reserved.
//

#import "BTThemeViewController.h"
#import "BTPhotosViewController.h"
#import "DefaultTheme.h"
#import "ForestTheme.h"
#import "PrettyInPinkTheme.h"
#import "ThemeManager.h"

@implementation BTThemeViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.themes = @[@"Default",@"Forest",@"Pretty in Pink"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.themes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	[ThemeManager customiseTableViewCell:cell];

    NSString *object = self.themes[indexPath.row];
    cell.textLabel.text = object;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = indexPath.row;
	
	if ([self.themes[idx] isEqualToString:@"Forest"])
		[ThemeManager setSharedTheme:[ForestTheme new]];
	else if ([self.themes[idx] isEqualToString:@"Pretty in Pink"])
		[ThemeManager setSharedTheme:[PrettyInPinkTheme new]];
	else
		[ThemeManager setSharedTheme:[DefaultTheme new]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ibaCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
