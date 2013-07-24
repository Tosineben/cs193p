//
//  SetCardView.m
//  Matchismo
//
//  Created by Alden Quimby on 7/23/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark Draw

#define CORNER_RADIUS 12.0

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:CORNER_RADIUS];
    
    // only draw inside this rect
    [roundedRect addClip];
    
    // fill "whole" (inside rect) background with white
    if (self.faceUp)
    {
        [[UIColor colorWithWhite:0.9 alpha:1.0] setFill];
    }
    else
    {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);
    
    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define SYMBOL_OFFSET_PCT 0.2
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawSymbols
{
    // use the cards color
    [[self uiColor] setStroke];
    
    CGPoint centerPt = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET_PCT;
    
    if (self.number == 1)
    {
        // draw one symbol in center of card
        [self drawSymbolAtPoint:centerPt];
    }
    else if (self.number == 2)
    {
        // draw two symbols, equally off center left and right
        [self drawSymbolAtPoint:CGPointMake(centerPt.x - dx / 2, centerPt.y)];
        [self drawSymbolAtPoint:CGPointMake(centerPt.x + dx / 2, centerPt.y)];
    }
    else if (self.number == 3)
    {
        // draw three symbols, centered
        [self drawSymbolAtPoint:CGPointMake(centerPt.x - dx, centerPt.y)];
        [self drawSymbolAtPoint:centerPt];
        [self drawSymbolAtPoint:CGPointMake(centerPt.x + dx, centerPt.y)];
    }
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    if ([self.symbol isEqualToString:@"diamond"])
    {
        [self drawDiamondAtPoint:point];
    }
    else if ([self.symbol isEqualToString:@"oval"])
    {
        [self drawOvalAtPoint:point];
    }
    else if ([self.symbol isEqualToString:@"squiggle"])
    {
        [self drawSquiggleAtPoint:point];
    }
}

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.4

- (void)drawDiamondAtPoint:(CGPoint)point
{
    // change in x/y from center
    CGFloat dx = self.bounds.size.width / 2 * DIAMOND_WIDTH;
    CGFloat dy = self.bounds.size.height / 2 * DIAMOND_HEIGHT;
    
    // set up bezier path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    
    // draw diamond shape
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path closePath];
    
    // add shading
    [self shadePath:path];
    
    // draw it
    [path stroke];
}

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.4

- (void)drawOvalAtPoint:(CGPoint)point
{
    // change in x/y from center
    CGFloat dx = self.bounds.size.width / 2 * DIAMOND_WIDTH;
    CGFloat dy = self.bounds.size.height / 2 * DIAMOND_HEIGHT;

    CGRect ovalRect = CGRectMake(point.x - dx, point.y - dy, dx * 2, dy * 2);
    
    // set up bezier path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:ovalRect
                                                    cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    
    // add shading
    [self shadePath:path];
    
    // draw it
    [path stroke];
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8

- (void)drawSquiggleAtPoint:(CGPoint)point
{
    // change in x/y from center
    CGFloat dx = self.bounds.size.width / 2 * SQUIGGLE_WIDTH;
    CGFloat dy = self.bounds.size.height / 2 * SQUIGGLE_HEIGHT;
    
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    
    // set up bezier path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    
    // draw squiggle
    [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
                 controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
            controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
            controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
    
    // add shading
    [self shadePath:path];
    
    // draw it
    [path stroke];
}

- (void)shadePath:(UIBezierPath *)path
{
    if ([self.shading isEqualToString:@"solid"])
    {
        [self shadePathSolid:path];
    }
    else if ([self.shading isEqualToString:@"striped"])
    {
        [self shadePathStriped:path];
    }
    else if ([self.shading isEqualToString:@"open"])
    {
        [self shadePathOpen:path];
    }
}

- (void)shadePathSolid:(UIBezierPath *)path
{
    [[self uiColor] setFill];
    [path fill];
}

#define STRIPES_OFFSET_PCT 0.06
#define STRIPES_ANGLE 5

- (void)shadePathStriped:(UIBezierPath *)path
{
    // save current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // make sure we don't draw outside the path
    [path addClip];
    
    // set up bezier path
    UIBezierPath *stripes = [[UIBezierPath alloc] init];
    stripes.lineWidth = self.bounds.size.width / 2 * SYMBOL_LINE_WIDTH;
    
    // trace out the stripes
    CGFloat dy = self.bounds.size.height * STRIPES_OFFSET_PCT;
    CGPoint start = CGPointMake(self.bounds.origin.x, self.bounds.origin.y + dy * STRIPES_ANGLE);
    CGPoint end = CGPointMake(start.x + self.bounds.size.width, start.y);
    for (int i = 0; i < 1 / STRIPES_OFFSET_PCT; i ++)
    {
        [stripes moveToPoint:start];
        [stripes addLineToPoint:end];
        
        start.y += dy;
        end.y += dy;
    }
    
    // draw the stripes
    [stripes stroke];
    
    // reset context
    CGContextRestoreGState(context);
}

- (void)shadePathOpen:(UIBezierPath *)path
{
    [[UIColor clearColor] setFill];
}

- (UIColor *)uiColor
{
    if ([self.color isEqualToString:@"red"])
    {
        return [UIColor redColor];
    }
    
    if ([self.color isEqualToString:@"green"])
    {
        return [UIColor greenColor];
    }
    
    if ([self.color isEqualToString:@"purple"])
    {
        return [UIColor purpleColor];
    }
    
    return nil;
}

#pragma mark setters

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

#pragma mark Initialization

- (void)setup
{
    // initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
