//
//  MainController.m
//  ConstraintsApp
//
//  Created by James Valaitis on 05/12/2012.
//  Copyright (c) 2012 &Beyond. All rights reserved.
//

#import "MainController.h"

@interface MainController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet	UITableView			*tableView;
@property (nonatomic, weak) IBOutlet	UILabel				*filterNameLabel;
@property (nonatomic, weak) IBOutlet	UIView				*filterBar;
@property (nonatomic, strong) IBOutlet	NSLayoutConstraint	*spaceBetweenFilterBarAndMainTable;

@end

@implementation MainController
{
	NSUInteger		_activeFilterIndex;
	NSArray			*_filterNames;
	UITableView		*_filterTableView;
	NSArray			*_verticalConstraintsBeforeAnimation;
	NSArray			*_verticalConstraintsAfterAnimation;
}

#pragma mark - Action & Selector Methods

- (IBAction)filterButtonPressed
{
	if (!_filterTableView)
		[self showFilterTable];
	else
		[self hideFilterTable];
}

#pragma mark - Convenience Methods

- (void)hideFilterTable
{
	[self.view removeConstraints:_verticalConstraintsAfterAnimation];
	[self.view addConstraints:_verticalConstraintsBeforeAnimation];
	
	[UIView animateWithDuration:0.3f animations:
	^{
		[self.view layoutIfNeeded];
	}
	completion:^(BOOL finished)
	{
		[_filterTableView removeFromSuperview];
		_filterTableView	= nil;
		
		[self.view addConstraint:self.spaceBetweenFilterBarAndMainTable];
	}];
}

- (void)showFilterTable
{
	_filterTableView				= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[_filterTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_filterTableView setDataSource:self];
	[_filterTableView setDelegate:self];
	_filterTableView.rowHeight		= 24.0f;
	_filterTableView.backgroundColor= [UIColor blackColor];
	_filterTableView.separatorColor	= [UIColor darkGrayColor];
	
	[self.view addSubview:_filterTableView];
	
	NSDictionary *viewsDictionary	= @{@"filterTableView" : _filterTableView,
										@"filterBar" : self.filterBar,
										@"mainTableView" : self.tableView};
	
	NSArray* constraints			= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[filterTableView]|"
															   options:kNilOptions metrics:nil views:viewsDictionary];
	[self.view addConstraints:constraints];
	
	constraints						= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[filterBar][filterTableView(0)][mainTableView]"
																	 options:kNilOptions metrics:nil views:viewsDictionary];
	_verticalConstraintsBeforeAnimation = constraints;
	[self.view addConstraints:constraints];
	[self.view layoutIfNeeded];
	[self.view removeConstraints:constraints];
	
	[self.view removeConstraint:self.spaceBetweenFilterBarAndMainTable];
	
	constraints						= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[filterBar][filterTableView(96.0)][mainTableView]"
															   options:kNilOptions metrics:nil views:viewsDictionary];
	_verticalConstraintsAfterAnimation = constraints;
	[self.view addConstraints:constraints];
	
	[UIView animateWithDuration:0.3f animations:
	^{
		[self.view layoutIfNeeded];
	}];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView)
		return 50;
	else
		return _filterNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier	= @"Cell";
	
	UITableViewCell *cell			= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
		cell						= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
															 reuseIdentifier:CellIdentifier];
	
	if (tableView == self.tableView)
		cell.textLabel.text			= [NSString stringWithFormat:@"Row %d", indexPath.row];
	else
	{
		cell.textLabel.text			= _filterNames[indexPath.row];
		cell.accessoryType			= (_activeFilterIndex == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
		cell.textLabel.font			= [UIFont systemFontOfSize:14.0f];
		cell.textLabel.textColor	= [UIColor whiteColor];
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (tableView == _filterTableView)
	{
		_activeFilterIndex			= indexPath.row;
		self.filterNameLabel.text	= _filterNames[_activeFilterIndex];
		[self hideFilterTable];
	}
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	
	_filterNames					= @[ @"Show All", @"By Name", @"By Date", @"By Popularity" ];
	_activeFilterIndex = 0;
	
	self.filterNameLabel.text		= _filterNames[_activeFilterIndex];
}

@end
