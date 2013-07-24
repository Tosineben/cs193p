//
//  SetCardView.h
//  Matchismo
//
//  Created by Alden Quimby on 7/23/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

// TODO can i delete this?
@property (nonatomic)bool faceUp;

@end
