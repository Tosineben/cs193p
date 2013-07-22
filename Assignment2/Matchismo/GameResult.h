//
//  GameResult.h
//  Matchismo
//
//  Created by Alden Quimby on 7/17/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

@end
