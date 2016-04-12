#import <Foundation/Foundation.h>

extern NSString * const WowClassTypeWarrior;
extern NSString * const WowClassTypePaladin;
extern NSString * const WowClassTypeHunter;
extern NSString * const WowClassTypeRogue;
extern NSString * const WowClassTypePriest;
extern NSString * const WowClassTypeDeathKnight;
extern NSString * const WowClassTypeShaman;
extern NSString * const WowClassTypeMage;
extern NSString * const WowClassTypeWarlock;
extern NSString * const WowClassTypeMonk;
extern NSString * const WowClassTypeDruid;

extern NSString * const WowRaceNameHuman;
extern NSString * const WowRaceNameOrc;
extern NSString * const WowRaceNameDwarf;
extern NSString * const WowRaceNameNightElf;
extern NSString * const WowRaceNameUndead;
extern NSString * const WowRaceNameTauren;
extern NSString * const WowRaceNameGnome;
extern NSString * const WowRaceNameTroll;
extern NSString * const WowRaceNameGoblin;
extern NSString * const WowRaceNameBloodElf;
extern NSString * const WowRaceNameDraenei;
extern NSString * const WowRaceNameWorgen;

extern NSString * const WowItemQualityGrey;
extern NSString * const WowItemQualityWhite;
extern NSString * const WowItemQualityGreen;
extern NSString * const WowItemQualityBlue;
extern NSString * const WowItemQualityPurple;
extern NSString * const WowItemQualityOrange;

// urls
extern NSString * const WowBattlenetUrlStaticImages;
extern NSString * const WowBattlenetUrlMediaIconImages;

// class types
typedef enum {
    Warrior = 1,
    Paladin = 2,
    Hunter = 3,
    Rogue = 4,
    Priest = 5,
    DeathKnight = 6,
    Shaman = 7,
    Mage = 8,
    Warlock = 9,
    Monk = 10,
    Druid = 11,
} CharacterClassType;

// race types
typedef enum {
    Human = 1,
    Orc = 2,
    Dwarf = 3,
    NightElf = 4,
    Undead = 5,
    Tauren = 6,
    Gnome = 7,
    Troll = 8,
    Goblin = 9,
    BloodElf = 10,
    Draenei = 11,
    Worgen = 22
} CharacterRaceType;

// Slots for items
typedef enum {
    Head = 1,
    Neck,
    Shoulder,
    Back,
    Chest,
    Shirt,
    Tabard,
    Wrists,
    Hands,
    Waist,
    Legs,
    Feet,
    Finger1,
    Finger2,
    Trinket1,
    Trinket2,
    mainHand,
    offHand,
    ranged
} ItemSlot;

typedef enum {
    Grey = 1,
    White,
    Green,
    Blue,
    Purple,
    Legend
} ItemQuality;

@interface WoWUtils : NSObject

+(NSString *)classFromCharacterType:(CharacterClassType)type;
+(NSString *)raceFromRaceType:(CharacterRaceType)type;
+(NSString *)qualityFromQualityType:(ItemQuality)quality;

@end
