//
//  FileController.m
//  RichEditor
//
//  Created by James Valaitis on 22/01/2013.
//  Copyright (c) 2013 &Beyond. All rights reserved.
//

#import "FileController.h"
#import "NoteController.h"
#import "NSObject+AutoCoding.h"

#define kCellIdentifier		@"FileCell"

@interface FileController ()
{
	NSArray				*_fileList;
	NSMutableDictionary	*_renderedStrings;
}

@end

@implementation FileController

#pragma mark - Action & Selector Methods

- (IBAction)addTapped
{	
	NSDateFormatter *dateFormatter		= [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
	NSString *dateString				= [dateFormatter stringFromDate:[NSDate date]];
	
	NSString *fileName					= [[UtilityMethods documentsDirectory] stringByAppendingPathComponent:
										   [NSString stringWithFormat:@"%@.plist", dateString]];
	
	[self pushNoteController:fileName];
}

#pragma mark - Convenience Methods

- (void)addButtons
{
	UIBarButtonItem *addButton			= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																						target:self
																						action:@selector(addTapped)];
	
	[self.navigationItem setRightBarButtonItem:addButton];
}

- (void)pushNoteController:(NSString *)fileName
{
	NoteController *noteController		= [[NoteController alloc] initWithNibName:@"NoteView" bundle:nil];
	noteController.fileName				= fileName;
	[self.navigationController pushViewController:noteController animated:YES];
}

#pragma mark - File Handling Methods

- (void)loadFileList
{
	NSFileManager *fileManager			= [NSFileManager defaultManager];
	NSArray *paths						= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory		= paths.lastObject;
	
	_fileList							= [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
}

#pragma mark - UITableViewDataSource Methods

/**
 *	as the data source, we must define how many sections we want the table view to have
 *
 *	@param	tableView					the table view for which are defining the sections number
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/**
 *	create and return the cells for each row of the table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	indexPath					the index path of the row we are creating a cell for
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell				= [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	cell.textLabel.text					= nil;
	
	cell.imageView.image				= _renderedStrings[_fileList[indexPath.row]];
	
	return cell;
}

/**
 *	define how many rows for each section there are in this table view
 *
 *	@param	tableView					the table view for which we are creating cells
 *	@param	section						the particular section for which we must define the rows
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return _fileList.count;
}

#pragma mark - UITableViewDelegate Methods

/**
 *	handle the fact that a cell was just selected
 *
 *	@param	tableView					the table view containing selected cell
 *	@param	indexPath					the index path of the cell that was selected
 */
- (void)	  tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger selectedIndex				= self.tableView.indexPathForSelectedRow.row;
	NSString *selectedFileName			= _fileList[selectedIndex];
	
	NSString *fileName					= [[UtilityMethods documentsDirectory] stringByAppendingPathComponent:selectedFileName];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self pushNoteController:fileName];
}

/**
 *	define the height of the cell
 *
 *	@param	tableView					the view which owns the cell for which we need to define the height
 *	@param	indexPath					index path of the cell
 */
- (CGFloat)	  tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//	get the relevant file's contents
	NSString *filePath					= [[UtilityMethods documentsDirectory] stringByAppendingPathComponent:_fileList[indexPath.row]];
	NSMutableAttributedString *contents	= [NSMutableAttributedString objectWithContentsOfFile:filePath];
	
	//	get the range from the beginning to either the end of contents (if less than 30), or 30 characters long]
	contents							= [contents attributedSubstringFromRange:NSMakeRange(0, MIN(30, contents.length))].mutableCopy;
	
	//	add a ... at the end to show it trails off
	NSAttributedString *dots			= [[NSAttributedString alloc] initWithString:@"..." attributes:[contents attributesAtIndex:0
																													effectiveRange:nil]];
	[contents appendAttributedString:dots];
	
	NSLog(@"Contents: %@", contents);
	
	//	get the bounds of the string with actual width, but allow algorithm to calculate height, and we let the string span multiple lines
	CGRect bounds						= [contents boundingRectWithSize:CGSizeMake(300, 10000)
																options:NSStringDrawingUsesLineFragmentOrigin
																context:nil];
	
	//	begin drawing the string to an image context
	UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
	
	[contents drawWithRect:bounds options:NSStringDrawingUsesLineFragmentOrigin context:nil];
	UIImage *renderedText				= UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	//	store our image and return the height of it
	_renderedStrings[_fileList[indexPath.row]]	= renderedText;
	
	return bounds.size.height + 30;
}

#pragma mark - View Lifecycle

/**
 *	notifies the view controller that its view was added to a view hierarchy
 */
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self loadFileList];
	
	self.title				= [NSString stringWithFormat:@"Notes (%i)", _fileList.count];
	[self.tableView reloadData];
}

/**
 *	called once this controller's view has been loaded into memory
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title				= @"Notes";
	
	[self addButtons];
	
	[self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
	
	_renderedStrings		= [NSMutableDictionary dictionaryWithCapacity:5];
}

@end
































































