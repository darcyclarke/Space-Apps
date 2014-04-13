//
//  DIODrillMeter.m
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIODrillAccuracyMeter.h"
#import "DIOControlPanelDefines.h"

#define SLIDER_INDICATOR_WIDTH 10.0f
#define POWER_INDICATOR_WIDTH 10.0f

@interface DIODrillAccuracyMeter ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL powerIndicatorShouldGoForward;
@property (assign, nonatomic) float accuracyMeterSpeed;

@end

@implementation DIODrillAccuracyMeter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.meterContainer];
        self.accuracyMeterSpeed = 5;
        
        UIImageView *dialBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DialBackground"]];
        dialBackground.frame = self.meterContainer.bounds;
        [self.meterContainer addSubview:dialBackground];
        
        [self.meterContainer addSubview:self.sliderIndicator];
        [self.meterContainer addSubview:self.powerIndicator];
        
        UIImageView *accuracyFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AccuracyFrame"]];
        accuracyFrame.frame = self.bounds;
        [self addSubview:accuracyFrame];
        
        [self startAnimatingPowerIndicator];
    }
    return self;
}

#pragma move slider indicator
- (void)moveSliderIndicatorWithSliderValue:(float)sliderValue
{
    float meterContainerWidth = CGRectGetWidth(self.meterContainer.frame);
    
    self.sliderIndicator.center = CGPointMake(meterContainerWidth * sliderValue, CGRectGetHeight(self.meterContainer.frame)/2);
}

#pragma mark power indicator

- (void)startAnimatingPowerIndicator
{
    self.powerIndicatorShouldGoForward = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(movePowerIndicator:) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)movePowerIndicator:(NSTimer *)sender
{
    if (self.powerIndicator.center.x < CGRectGetWidth(self.meterContainer.frame) && self.powerIndicatorShouldGoForward) {
        self.powerIndicator.center = CGPointMake(self.powerIndicator.center.x + self.accuracyMeterSpeed, self.powerIndicator.center.y);
    } else if (self.powerIndicator.center.x > 0) {
        self.powerIndicatorShouldGoForward = NO;
        self.powerIndicator.center = CGPointMake(self.powerIndicator.center.x - self.accuracyMeterSpeed, self.powerIndicator.center.y);
    } else {
        self.powerIndicatorShouldGoForward = YES;
        self.powerIndicator.center = CGPointMake(self.powerIndicator.center.x + self.accuracyMeterSpeed, self.powerIndicator.center.y);
    }
}

#pragma mark lazy load
- (UIView *)meterContainer
{
    if (!_meterContainer) {
        CGFloat sliderButtonWidth = SLIDER_BUTTON_WIDTH;
        CGRect meterContainerRect = CGRectMake(sliderButtonWidth /2,
                                               0,
                                               CGRectGetWidth(self.frame) - sliderButtonWidth, CGRectGetHeight(self.frame));
        self.meterContainer = [[UIView alloc] initWithFrame:meterContainerRect];
        self.meterContainer.backgroundColor = [UIColor whiteColor];
    }
    
    return _meterContainer;
}

- (UIView *)sliderIndicator
{
    if (!_sliderIndicator) {
        CGRect sliderIndicatorFrame = CGRectMake(0, 0, SLIDER_INDICATOR_WIDTH, CGRectGetHeight(self.meterContainer.frame));
        self.sliderIndicator = [[UIView alloc] initWithFrame:sliderIndicatorFrame];
        self.sliderIndicator.backgroundColor = [UIColor colorWithHue:0.081 saturation:0.738 brightness:0.957 alpha:1];
    }
    
    return _sliderIndicator;
}

- (UIView *)powerIndicator
{
    if (!_powerIndicator) {
        CGRect powerIndicatorFrame = CGRectMake(0, 0, POWER_INDICATOR_WIDTH, CGRectGetHeight(self.meterContainer.frame));
        self.powerIndicator = [[UIView alloc] initWithFrame:powerIndicatorFrame];
        self.powerIndicator.backgroundColor = [UIColor blackColor];
        self.powerIndicator.alpha = 0.5f;
    }
    
    return _powerIndicator;
}

@end
