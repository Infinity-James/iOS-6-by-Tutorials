
@interface Player : NSObject <NSCoding>

@property (nonatomic, copy)		NSString	*name;
@property (nonatomic, copy)		NSString	*game;
@property (nonatomic, copy)		NSString	*playerID;
@property (nonatomic, assign)	NSInteger	rating;

@end
