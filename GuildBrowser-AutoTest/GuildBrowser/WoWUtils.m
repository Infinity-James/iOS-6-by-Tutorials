#import "WoWUtils.h"

@implementation WoWUtils

NSString * const WowClassTypeWarrior        = @"Warrior";
NSString * const WowClassTypePaladin        = @"Paladin";
NSString * const WowClassTypeHunter         = @"Hunter";
NSString * const WowClassTypeRogue          = @"Rogue";
NSString * const WowClassTypePriest         = @"Priest";
NSString * const WowClassTypeDeathKnight    = @"Death Knight";
NSString * const WowClassTypeShaman         = @"Shaman";
NSString * const WowClassTypeMage           = @"Mage";
NSString * const WowClassTypeWarlock        = @"Warlock";
NSString * const WowClassTypeMonk           = @"Monk";
NSString * const WowClassTypeDruid          = @"Druid";


NSString * const WowRaceNameHuman           = @"Human";
NSString * const WowRaceNameOrc             = @"Orc";
NSString * const WowRaceNameDwarf           = @"Dwarf";
NSString * const WowRaceNameNightElf        = @"Night Elf";
NSString * const WowRaceNameUndead          = @"Undead";
NSString * const WowRaceNameTauren          = @"Tauren";
NSString * const WowRaceNameGnome           = @"Gnome";
NSString * const WowRaceNameTroll           = @"Troll";
NSString * const WowRaceNameGoblin          = @"Goblin";
NSString * const WowRaceNameBloodElf        = @"Blood Elf";
NSString * const WowRaceNameDraenei         = @"Draenei";
NSString * const WowRaceNameWorgen          = @"Worgen";

NSString * const WowItemQualityGrey         = @"Grey";
NSString * const WowItemQualityWhite        = @"White";
NSString * const WowItemQualityGreen        = @"Green";
NSString * const WowItemQualityBlue        = @"Blue";
NSString * const WowItemQualityPurple       = @"Purple";
NSString * const WowItemQualityOrange       = @"Orange";

NSString * const WowBattlenetUrlStaticImages = @"http://us.battle.net/static-render/us/";
NSString * const WowBattlenetUrlMediaIcon56 = @"http://us.media.blizzard.com/wow/icons/56/";

+(NSString *)classFromCharacterType:(CharacterClassType)type
{
    NSString *classTypeName;
    switch (type) {
        case Warrior:
            classTypeName = WowClassTypeWarrior;
            break;
        case Paladin:
            classTypeName = WowClassTypePaladin;
            break;
        case Hunter:
            classTypeName = WowClassTypeHunter;
            break;
        case Rogue:
            classTypeName = WowClassTypeRogue;
            break;
        case Priest:
            classTypeName = WowClassTypePriest;
            break;
        case DeathKnight:
            classTypeName = WowClassTypeDeathKnight;
            break;
        case Shaman:
            classTypeName = WowClassTypeShaman;
            break;
        case Mage:
            classTypeName = WowClassTypeMage;
            break;
        case Warlock:
            classTypeName = WowClassTypeWarlock;
            break;
        case Monk:
            classTypeName = WowClassTypeMonk;
            break;
        case Druid:
            classTypeName = WowClassTypeDruid;
            break;
        default:
            classTypeName = @"";
            break;
    }
    
    return classTypeName;
}

+(NSString *)raceFromRaceType:(CharacterRaceType)type
{
    NSString *raceName;
    
    switch (type) {
        case Human:
            raceName = WowRaceNameHuman;
            break;
        case Orc:
            raceName = WowRaceNameOrc;
            break;
        case Dwarf:
            raceName = WowRaceNameDwarf;
            break;
        case NightElf:
            raceName = WowRaceNameNightElf;
            break;
        case Undead:
            raceName = WowRaceNameUndead;
            break;
        case Tauren:
            raceName = WowRaceNameTauren;
            break;
        case Gnome:
            raceName = WowRaceNameGnome;
            break;
        case Troll:
            raceName = WowRaceNameTroll;
            break;
        case Goblin:
            raceName = WowRaceNameGoblin;
            break;
        case BloodElf:
            raceName = WowRaceNameBloodElf;
            break;
        case Draenei:
            raceName = WowRaceNameDraenei;
            break;
        case Worgen:
            raceName = WowRaceNameWorgen;
            break;
        default:
            raceName = @"";
            break;
    }
    return raceName;
}

+(NSString *)qualityFromQualityType:(ItemQuality)quality
{
    NSString *qualityName;
    
    switch (quality) {
        case Grey:
            qualityName = WowItemQualityGrey;
            break;
        case White:
            qualityName = WowItemQualityWhite;
            break;
        case Green:
            qualityName = WowItemQualityGreen;
            break;
        case Blue:
            qualityName = WowItemQualityBlue;
            break;
        case Purple:
            qualityName = WowItemQualityPurple;
            break;
        case Legend:
            qualityName = WowItemQualityOrange;
            break;
        default:
            qualityName = @"";
            break;
    }
    return qualityName;
}

@end
