//
//  DIODrillPowerMeter.m
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIODrillPowerMeter.h"

#define POWER_SQUARE_WIDTH 68.0f
#define POWER_SQUARE_HEIGHT 68.0f
#define MAX_DRILL_LEVEL 4

@interface DIODrillPowerMeter ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) float drillLevel;
@property (strong, nonatomic) UIView *powerSquare;

@end

@implementation DIODrillPowerMeter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PowerLightsBackground"]]];
        
        [self reset];
    }
    return self;
}

- (void)didPressDrillButton:(UIButton *)sender
{
    [self showDrillPowerLevelWithLevel:self.drillLevel];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                        target:self
                                      selector:@selector(increaseDrillPower:)
                                      userInfo:nil
                                       repeats:YES];
}

- (void)didReleaseDrillButton:(UIButton *)sender
{
    [self.timer invalidate];
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.delegate didDrillWithPowerLevel:self.drillLevel];
    [self reset];
}

- (void)reset
{
    self.drillLevel = 0;
}

#pragma mark timer method

- (void)increaseDrillPower:(NSTimer *)sender
{
    if (self.drillLevel < 4) {
        self.drillLevel += 1;
        [self showDrillPowerLevelWithLevel:self.drillLevel];
    }
}

- (NSInteger)powerSquareSpacingForDrillLevel:(NSInteger)drillLevel
{
    switch(drillLevel) {
        case 0: {
            return 0;
        }
            
        case 1: {
            return -5;
        }
            
        case 2: {
            return -7;
        }
            
        case 3: {
            return -7;
        }
            
        case 4: {
            return -8;
        }
            
        default: {
            return -5;
        }
    }
}

#pragma mark drill power meter
- (void)showDrillPowerLevelWithLevel:(float)drillLevel
{
    UIView *newSquare = [[UIView alloc] initWithFrame:CGRectMake([self powerSquareSpacingForDrillLevel:drillLevel], 15, POWER_SQUARE_WIDTH, POWER_SQUARE_HEIGHT)];
    newSquare.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PowerLight"]];
    newSquare.frame = CGRectOffset(newSquare.frame, self.drillLevel * ([self powerSquareSpacingForDrillLevel:drillLevel] + POWER_SQUARE_WIDTH), 0);
    [self addSubview:newSquare];
}

@end
