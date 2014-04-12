//
//  DIOControlPanel.m
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanel.h"

@interface DIOControlPanel ()

@end

@implementation DIOControlPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    [self addSubview:self.drillButton];
    [self addSubview:self.slider];
    [self addSubview:self.drillAccuracyMeter];
    [self addSubview:self.drillPowerMeter];
}

#pragma mark slider
- (void)sliderChanged:(UISlider *)sender
{
    UISlider *slider = (UISlider *)sender;
    float val = slider.value;
    [self.drillAccuracyMeter moveSliderIndicatorWithSliderValue:val];
}

#pragma mark DIODrillPowerMeterDelegate
- (void)didDrillWithPowerLevel:(float)drillPowerLevel
{
    
    /* set up bonus based on accuracy */
    float powerIndicatorX = self.drillAccuracyMeter.powerIndicator.frame.origin.x;
    float sliderX = self.drillAccuracyMeter.sliderIndicator.frame.origin.x;
    //this is the max 'bonus' they can get here, which the width of the white meterContainer in the accuracy meter
    float meterContainerWidth = CGRectGetWidth(self.drillAccuracyMeter.meterContainer.frame);
    //we then add the length between the powerIndicator and slider, and then subtract it from the meterContainerWidth
    float accuracyBonus = meterContainerWidth - (powerIndicatorX - sliderX);
    
    /* add the bonus to the drill power points and send to server */
    
    //use this number to change value of drillPower
    float drillPowerBonusMultiplier = 10;
    float drillPower = drillPowerLevel * drillPowerBonusMultiplier;
    //use this number to change value accuracy
    float accuracyBonusMultiplier = 1;
    float accuracyBonusPoints = accuracyBonus * accuracyBonusMultiplier;
    
    float totalPointsForShot = accuracyBonus + (accuracyBonusPoints * drillPower);
#warning TODO send to server
    NSLog(@"%f",totalPointsForShot);
}


#pragma mark lazy load
                        
- (DIOControlPanelButton*)drillButton
{
    if (!_drillButton) {
        self.drillButton = [[DIOControlPanelButton alloc] initWithFrame:CGRectMake(674, 418, 300, 300)];
        [self.drillButton addTarget:self.drillPowerMeter action:@selector(didPressDrillButton:) forControlEvents:UIControlEventTouchDown];
        [self.drillButton addTarget:self.drillPowerMeter action:@selector(didReleaseDrillButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    }
    
    return _drillButton;
}

- (DIODJSlider*)slider
{
    if (!_slider) {
        self.slider = [[DIODJSlider alloc] initWithFrame:CGRectMake(50, 418, 574, 300)];
        [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _slider;
}

- (DIODrillAccuracyMeter *)drillAccuracyMeter
{
    if (!_drillAccuracyMeter) {
        self.drillAccuracyMeter = [[DIODrillAccuracyMeter alloc] initWithFrame:CGRectMake(50, 168, 574, 200)];
    }
    
    return _drillAccuracyMeter;
}

- (DIODrillPowerMeter *)drillPowerMeter
{
    if (!_drillPowerMeter) {
        self.drillPowerMeter = [[DIODrillPowerMeter alloc] initWithFrame:CGRectMake(674, 218, 300, 100)];
        self.drillPowerMeter.delegate = self;
    }
    
    return _drillPowerMeter;
}

@end
