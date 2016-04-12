#import "DataModel.h"
#import "DetailViewController.h"
#import "Item.h"
#import "MasterViewController.h"
#import "NSDictionary+RWFlatten.h"
#import "Section.h"

@interface MasterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet	UITableView			*tableView;
@property (nonatomic, weak) IBOutlet	UISegmentedControl	*segmentedControl;
	
@end

@implementation MasterViewController
{
	DataModel	*_dataModel;
	BOOL		_sortedByName;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		_dataModel		= [[DataModel alloc] init];
		_sortedByName	= YES;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	if (_sortedByName)
		self.segmentedControl.selectedSegmentIndex = 0;
	else
		self.segmentedControl.selectedSegmentIndex = 1;

	[self updateTableContents];
	
	NSLog(@"View did load.");
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	
	NSLog(@"Did receive a memory warning.");
	
	if ([self isViewLoaded] && !self.view.window)
	{
		self.view		= nil;
		[_dataModel clearSortedItems];

		NSLog(@"Unloading view man.");
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowDetail"])
	{
		DetailViewController *controller	= segue.destinationViewController;
		
		controller.completionBlock			= ^(BOOL success)
		{
			if (success)
			{
				[self updateTableContents];
			}
			
			[self dismissViewControllerAnimated:YES completion:nil];
		};

		UITableViewCell *cell				= sender;
		NSIndexPath *indexPath				= [self.tableView indexPathForCell:cell];

		if (_sortedByName)
		{
			NSString *sectionName			= _dataModel[indexPath.section];
			Section *section				= _dataModel[sectionName];
			controller.itemToEdit			= section.items[indexPath.row];
		}
		else
		{
			controller.itemToEdit			= _dataModel.sortedItems[indexPath.row];
		}
	}
}

- (IBAction)sortChanged:(UISegmentedControl *)sender
{
	if (sender.selectedSegmentIndex == 0)
		_sortedByName = YES;
	else
		_sortedByName = NO;

	[self updateTableContents];
}

#pragma mark - Application Logic

- (void)updateTableContents
{
	// Lazily sort the list by value if we haven't done that yet.
	if (!_sortedByName && !_dataModel.sortedItems)
	{
		[_dataModel sortByValue];
	}

	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (_sortedByName)
		return _dataModel.sortedSectionNames.count;
	else
		return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (_sortedByName)
		return _dataModel[section];
	else
		return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_sortedByName)
	{
		NSString *sectionName		= _dataModel[section];
		Section *section			= _dataModel[sectionName];
		return section.items.count;
	}
	else
	{
		return _dataModel.sortedItems.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NumberCell"];
	
	Item *item;

	if (_sortedByName)
	{
		NSString *sectionName		= _dataModel[indexPath.section];
		item						= _dataModel[sectionName][indexPath.row];
	}
	else
	{
		item						= _dataModel.sortedItems[indexPath.row];
	}
	
	cell.textLabel.text				= item.name;
	cell.detailTextLabel.text		= item.value.description;

	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
