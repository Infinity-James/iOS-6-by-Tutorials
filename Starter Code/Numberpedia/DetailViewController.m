
#import "DetailViewController.h"
#import "Item.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet	UINavigationBar	*navigationBar;
@property (nonatomic, weak) IBOutlet	UITextField		*textField;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.navigationBar.topItem.title	= self.itemToEdit.name;
	self.textField.text					= self.itemToEdit.value.description;

	[self.textField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender
{
	if (self.completionBlock)
		self.completionBlock(NO);
}

- (IBAction)done:(id)sender
{
	NSNumberFormatter *formatter		= [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *newValue					= [formatter numberFromString:self.textField.text];

	self.itemToEdit.value				= newValue ? newValue : @0;

	if (self.completionBlock)
		self.completionBlock(YES);
}

@end
