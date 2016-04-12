//
//  HMWordsViewController.m
//  Hangman
//
//  Created by Ray Wenderlich on 7/12/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMWordsViewController.h"
#import "HMContentController.h"
#import "HMWords.h"

@implementation HMWordsViewController {
    NSIndexPath * _selectedIndexPath;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockedWordsChanged:) name:HMContentControllerUnlockedWordsDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)unlockedWordsChanged:(NSNotification *)notification {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [HMContentController sharedInstance].unlockedWords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    HMWords * words = [HMContentController sharedInstance].unlockedWords[indexPath.row];
    if ([HMContentController sharedInstance].currentWords == words) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = words.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath isEqual:_selectedIndexPath]) return;
    
    HMWords * words = [HMContentController sharedInstance].unlockedWords[indexPath.row];
    [[HMContentController sharedInstance] setCurrentWords:words];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath, _selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end

