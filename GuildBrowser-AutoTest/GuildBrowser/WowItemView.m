#import "WowItemView.h"
#import "UIImageView+AFNetworking.h"
#import "Item.h"

@implementation WowItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        self.thumbnail.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailscreen_frame.png"]];
        
    }
    return self;
}

-(void)configureWithItem:(Item *)item
{
    _itemName.text = item.name;
    _itemLevel.text = item.itemLevel;
    [_thumbnail setImageWithURL:[NSURL URLWithString:[item iconUrl]]];
    
    
}

@end
