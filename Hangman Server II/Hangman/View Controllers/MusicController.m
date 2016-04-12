//
//  MusicController.m
//  Hangman
//
//  Created by James Valaitis on 31/01/2013.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"
#import "MusicCell.h"
#import "MusicController.h"
#import "MusicInfo.h"
#import "UIImageView+AFNetworking.h"

@interface MusicController () <SKStoreProductViewControllerDelegate>

@end

@implementation MusicController
{
	NSMutableArray				*_musicInfo;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.refreshControl			= [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
	[self reload];
	[self.refreshControl beginRefreshing];
}

- (void)reload
{
	_musicInfo					= @[].mutableCopy;
	[self.tableView reloadData];
	[self requestMusic];
}

- (void)requestMusic
{
	NSURL *url							= [NSURL URLWithString:@"http://itunes.apple.com/"];
	AFHTTPClient *client				= [[AFHTTPClient alloc] initWithBaseURL:url];
	NSDictionary *parameters			= @{@"term"			: @"castlevania",
											@"media"		: @"music",
											@"entity"		: @"musicTrack",
											@"attribute"	: @"songTerm"};
	
	[client getPath:@"/search"
		 parameters:parameters
			success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		NSError *error;
		NSDictionary *searchResults		= [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
		
		if (!searchResults)
			NSLog(@"Failure parsing response: %@", error.localizedDescription);
		else
		{
			NSArray *results			= searchResults[@"results"];
			
			for (NSDictionary *result in results)
			{
				NSInteger trackID		= [result[@"trackId"] integerValue];
				NSString *trackName		= result[@"trackName"];
				NSString *artistName	= result[@"artistName"];
				CGFloat price			= [result[@"trackPrice"] floatValue];
				NSString *artworkURL	= result[@"artworkUrl60"];
				
				MusicInfo *musicInfo	= [[MusicInfo alloc] initWithTrackID:trackID trackName:trackName artistName:artistName price:price artworkURL:artworkURL];
				[_musicInfo addObject:musicInfo];
			}
			
			[self.tableView reloadData];
		}
		
		[self.refreshControl endRefreshing];
	}
			failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		NSLog(@"Error searching for songs: %@", error.localizedDescription);
		[self.refreshControl endRefreshing];
	}];
}

#pragma mark - SKStoreProductViewControllerDelegate Methods

/**
 *	called hwen the user dismissed the store screen
 *
 *	@param	viewController				store view controller whose interface was dismissed by the user
 */
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
	NSLog(@"Finished shopping through music controller");
	[self dismissViewControllerAnimated:YES completion:nil];
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
	static NSString *CellIdentifier		= @"Cell";
	MusicCell *cell						= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	MusicInfo *info						= _musicInfo[indexPath.row];
	
	cell.titleLabel.text				= info.trackName;
	cell.descriptionLabel.text			= info.artistName;
	cell.priceLabel.text				= [NSString stringWithFormat:@"$%0.2f", info.price];
	[cell.iconImageView setImageWithURL:[NSURL URLWithString:info.artworkURL] placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
	
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
	return _musicInfo.count;
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
	MusicInfo *info						= _musicInfo[indexPath.row];
	MBProgressHUD *hud					= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText						= @"Loading";
	
	SKStoreProductViewController *viewController	= [[SKStoreProductViewController alloc] init];
	viewController.delegate				= self;
	NSDictionary *parameter				= @{SKStoreProductParameterITunesItemIdentifier: @(info.trackID)};
	
	[viewController loadProductWithParameters:parameter completionBlock:^(BOOL result, NSError *error)
	{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		
		if (result)
			[self presentViewController:viewController animated:YES completion:nil];
		else
			NSLog(@"Failed to load product in music controller");
	}];
}



@end
