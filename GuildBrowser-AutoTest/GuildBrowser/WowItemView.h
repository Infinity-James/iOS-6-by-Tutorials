#import <UIKit/UIKit.h>
@class Item;

@interface WowItemView : UIView

@property (nonatomic, weak) IBOutlet UILabel *itemName;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnail;
@property (nonatomic, weak) IBOutlet UILabel *itemLevel;

-(void)configureWithItem:(Item *)item;

@end
