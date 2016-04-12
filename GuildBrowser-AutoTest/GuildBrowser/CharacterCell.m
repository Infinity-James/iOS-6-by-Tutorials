#import "CharacterCell.h"
#import "Character.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation CharacterCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
	
    if (self)
	{
    }
	
    return self;
}


-(void)configureCellWithCharacter:(Character *)selectedCharacter
{
    self.character = selectedCharacter;
	
	self.accessibilityLabel				= _character.name;
	self.isAccessibilityElement			= YES;
    
    _name.text = _character.name;
    _levelRace.text = [NSString stringWithFormat:@"%@ %@",_character.level,_character.race];
    _className.text = _character.classType;
    _realm.text = _character.realm;
    _achievementPoints.text = [_character.achievementPoints stringValue];
    _guildRank.text = [_character.guildRank stringValue];
    [_thumbNail setImageWithURL:[NSURL URLWithString:[_character thumbnailUrl]]];
}

@end
