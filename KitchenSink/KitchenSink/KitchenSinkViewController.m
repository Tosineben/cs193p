//
//  KitchenSinkViewController.m
//  KitchenSink
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "KitchenSinkViewController.h"
#import "AskerViewController.h"

@interface KitchenSinkViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *kitchenSink;
@property (weak, nonatomic) NSTimer *drainTimer; // system has strong pointer when scheduled
@property (weak, nonatomic) UIActionSheet *sinkControlActionSheet;
@end

@implementation KitchenSinkViewController

#define SINK_CONTROL @"Sink Controls"
#define SINK_CONTROL_STOP_DRAIN @"Stopper Drain"
#define SINK_CONTROL_UNSTOP_DRAIN @"Unstopper Drain"
#define SINK_CONTROL_CANCEL @"Cancel"
#define SINK_CONTROL_EMPTY @"Empty Sink"

- (IBAction)controlSink:(UIBarButtonItem *)sender
{
    if (self.sinkControlActionSheet)
    {
        return;
    }
    
    NSString *drainButton = self.drainTimer ? SINK_CONTROL_STOP_DRAIN : SINK_CONTROL_UNSTOP_DRAIN;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:SINK_CONTROL delegate:self cancelButtonTitle:SINK_CONTROL_CANCEL destructiveButtonTitle:SINK_CONTROL_EMPTY otherButtonTitles:drainButton, nil];
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
    self.sinkControlActionSheet = actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self.kitchenSink.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    else
    {
        NSString *choice =  [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([choice isEqualToString:SINK_CONTROL_STOP_DRAIN])
        {
            [self stopDrainTimer];
        }
        else if ([choice isEqualToString:SINK_CONTROL_UNSTOP_DRAIN])
        {
            [self startDrainTimer];
        }
    }
}

#define DISH_CLEANING_INTERVAL 2.0

- (void)cleanDish
{
    if (self.kitchenSink.window)
    {
        [self addFood:nil];
        [self performSelector:@selector(cleanDish) withObject:nil afterDelay:DISH_CLEANING_INTERVAL];
    }
}

// start late
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startDrainTimer];
    [self cleanDish];
}

// stop early
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopDrainTimer];
}

#define DRAIN_DURATION 3.0
#define DRAIN_DELAY 1.0

- (void)startDrainTimer
{
    self.drainTimer = [NSTimer scheduledTimerWithTimeInterval:DRAIN_DURATION/3 target:self selector:@selector(drain:) userInfo:nil repeats:YES];
}

- (void)stopDrainTimer
{
    [self.drainTimer invalidate]; // because it's weak, this will set it to nil
}

- (void)drain:(NSTimer *)timer
{
    [self drain];
}

- (void)drain
{
    for (UIView *view in self.kitchenSink.subviews)
    {
        // make sure view isn't already draining
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform))
        {
            [UIView animateWithDuration:DRAIN_DURATION/3
                                  delay:DRAIN_DELAY
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                 view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), 2*M_PI/3);
             }
                             completion:^(BOOL finished) {
                 if (finished) [UIView animateWithDuration:DRAIN_DURATION/3
                                       delay:0
                                     options:UIViewAnimationOptionCurveLinear
                                  animations:^{
                                      view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), -2*M_PI/3);
                                  }
                  completion:^(BOOL finished) {
                      if (finished) [UIView animateWithDuration:DRAIN_DURATION/3
                                            delay:0
                                          options:UIViewAnimationOptionCurveLinear
                                       animations:^{
                                           view.transform = CGAffineTransformScale(transform, 0.1, 0.1);
                                       }
                       completion:^(BOOL finished) {
                           if (finished)
                           {
                               [view removeFromSuperview];
                           }
                       }];
                  }];
             }];
        }
    }
}

// tap anywhere on kitchen sink
- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.kitchenSink];
    
    for (UIView *view in self.kitchenSink.subviews)
    {
        // view.bounds is subviews coordinate system, we want
        // kitchen sink coordinate system, so use view.frame
        if (CGRectContainsPoint(view.frame, tapLocation))
        {
            // tap occured on this view
            
            [UIView animateWithDuration:DRAIN_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setRandomLocationForView:view];
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.99, 0.99);
            } completion:^(BOOL finished) {
                view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

- (void)addFood:(NSString *)food
{
    UILabel *foodLabel = [[UILabel alloc] init];
    
    static NSDictionary *foods = nil;
    if (!foods)
    {
        foods = @{
            @"Jello" : [UIColor blueColor], @"Broccoli" : [UIColor greenColor],
            @"Beet" : [UIColor redColor], @"Eggplant" : [UIColor purpleColor],
            @"Carrot" : [UIColor orangeColor], 
        };
    }
    
    if (![food length])
    {
        food = [[foods allKeys] objectAtIndex:arc4random()%[foods count]];
        foodLabel.textColor = [foods objectForKey:food];
    }
    
    foodLabel.text = food;
    foodLabel.font = [UIFont systemFontOfSize:46];
    foodLabel.backgroundColor = [UIColor clearColor];
    [self setRandomLocationForView:foodLabel];
    [self.kitchenSink addSubview:foodLabel];
}

- (void)setRandomLocationForView:(UIView *)view
{
    [view sizeToFit];
    CGRect sinkBounds = CGRectInset(self.kitchenSink.bounds, view.frame.size.width/2, view.frame.size.height/2);
    CGFloat x = arc4random() % (int)sinkBounds.size.width + view.frame.size.width/2;
    CGFloat y = arc4random() % (int)sinkBounds.size.height + view.frame.size.height/2;
    view.center = CGPointMake(x, y);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ask"])
    {
        AskerViewController *asker = segue.destinationViewController;
        asker.question = @"What food do you want in the sink?";
    }
}

- (IBAction)cancelAsking:(UIStoryboardSegue *)segue
{
    // do nothing, just an unwind segue
}

- (IBAction)doneAsking:(UIStoryboardSegue *)segue
{
    AskerViewController *asker = segue.sourceViewController;
    
    [self addFood:asker.answer];
}

@end
