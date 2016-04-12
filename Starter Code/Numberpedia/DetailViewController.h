@class Item;

typedef void (^DetailViewControllerCompetionBlock)(BOOL success);

@interface DetailViewController : UIViewController

@property (nonatomic, copy)		DetailViewControllerCompetionBlock	completionBlock;
@property (nonatomic, strong)	Item								*itemToEdit;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
