//
//  GameResult.m
//  Matchismo
//
//  Created by Alden Quimby on 7/17/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()

@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;

@end

@implementation GameResult

#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define ALL_RESULTS_KEY @"GameResult_All"

+ (NSArray *)allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id pList in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues])
    {
        GameResult *result = [[GameResult alloc] initFromPropertyList:pList];
        [allGameResults addObject:result];
    }
    
    return allGameResults;
}

// convience initializer
- (id)initFromPropertyList:(id)pList
{
    self = [self init];
    
    if (self)
    {
        if ([pList isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDict = pList;
            _start = resultDict[START_KEY];
            _end = resultDict[END_KEY];
            _score = [resultDict[SCORE_KEY] intValue];
            if (!_start || !_end)
            {
                self = nil;
            }
        }
    }
    
    return self;
}

- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{ START_KEY: self.start, END_KEY: self.end, SCORE_KEY: @(self.score) };
}

// designated initializer
- (id)init
{
    self = [super init];
    
    if (self)
    {
        _start = [NSDate date];
        _end = _start;
    }
    
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

@end
