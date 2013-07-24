//
//  GameSettings.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

#define GAME_SETTINGS_KEY @"Game_Settings_Key"
#define MATCH_BONUS_KEY @"Match_Bonus_Key"
#define MISMATCH_PENALTY_KEY @"Mismatch_Penalty_Key"
#define FLIP_COST_KEY @"Flip_Cost_Key"
#define NUMBER_CARDS_KEY @"Number_Cards_Key"

- (int)matchBonus
{
    return [self getIntForKey:MATCH_BONUS_KEY withDefault:4];
}

- (void)setMatchBonus:(int)matchBonus
{
    if (self.matchBonus != matchBonus)
    {        
        [self setInt:matchBonus forKey:MATCH_BONUS_KEY];
    }
}

- (int)mismatchPenalty
{
    return [self getIntForKey:MISMATCH_PENALTY_KEY withDefault:2];
}

- (void)setMismatchPenalty:(int)mismatchPenalty
{
    if (self.mismatchPenalty != mismatchPenalty)
    {
        [self setInt:mismatchPenalty forKey:MISMATCH_PENALTY_KEY];
    }
}

- (int)flipCost
{
    return [self getIntForKey:FLIP_COST_KEY withDefault:1];
}

- (void)setFlipCost:(int)flipCost
{
    if (self.flipCost != flipCost)
    {
        [self setInt:flipCost forKey:FLIP_COST_KEY];
    }
}

- (int)numberPlayingCards
{
    return [self getIntForKey:NUMBER_CARDS_KEY withDefault:22];
}

- (void)setNumberPlayingCards:(int)numberPlayingCards
{
    if (self.numberPlayingCards != numberPlayingCards)
    {
        [self setInt:numberPlayingCards forKey:NUMBER_CARDS_KEY];
    }
}

- (int)getIntForKey:(NSString *)key withDefault:(int)defaultValue
{
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:GAME_SETTINGS_KEY] mutableCopy];
    
    if (!settings || ![[settings allKeys] containsObject:key])
    {
        return defaultValue;
    }
    
    return [settings[key] intValue];
}

- (void)setInt:(int)value forKey:(NSString *)key
{
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:GAME_SETTINGS_KEY] mutableCopy];
    
    if (!settings)
    {
        settings = [[NSMutableDictionary alloc] init];
    }
    
    settings[key] = @(value);
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:GAME_SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
