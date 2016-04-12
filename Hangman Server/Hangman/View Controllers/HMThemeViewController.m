//
//  HMThemeViewController.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMThemeViewController.h"
#import "HMContentController.h"
#import "HMTheme.h"

@implementation HMThemeViewController {
    NSIndexPath * _selectedIndexPath;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockedThemesChanged:) name:HMContentControllerUnlockedThemesDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)unlockedThemesChanged:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [HMContentController sharedInstance].unlockedThemes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    HMTheme * theme = [HMContentController sharedInstance].unlockedThemes[indexPath.row];
    if ([HMContentController sharedInstance].currentTheme == theme) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = theme.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray * indexPathsToReload = [NSMutableArray array];
    if (_selectedIndexPath) {
        [indexPathsToReload addObject:_selectedIndexPath];
    }
    if (![indexPath isEqual:_selectedIndexPath]) {
        [indexPathsToReload addObject:indexPath];
    }
    
    HMTheme * theme = [HMContentController sharedInstance].unlockedThemes[indexPath.row];
    [[HMContentController sharedInstance] setCurrentTheme:theme];
        
    [self.tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationNone];
}

@end
