//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Alden Quimby on 7/22/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetGameViewController.h"
#import "GameResult.h"

@interface SetGameViewController ()

@property (strong, nonatomic) GameResult *gameResult;

@end

@implementation SetGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"Set Game";
    return _gameResult;
}

@end
