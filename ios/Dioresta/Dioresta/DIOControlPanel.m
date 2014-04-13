//
//  DIOControlPanel.m
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanel.h"

#import "DIOSocketManager.h"

@interface DIOControlPanel ()

@end

@implementation DIOControlPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHue:0.500 saturation:0.204 brightness:0.212 alpha:1];
                                
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    [self addSubview:background];
        
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
    [self addSubview:self.display];
    [self addSubview:self.errorMessage];
    self.errorMessage.hidden = YES;
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
    //get larger number
    float largerNumber = MAX(powerIndicatorX, sliderX);
    float smallerNumber = MIN(powerIndicatorX, sliderX);
    float accuracyBonus = meterContainerWidth - (largerNumber - smallerNumber);
    
    /* add the bonus to the drill power points and send to server */
    
    //use this number to change value of drillPower
    float drillPowerBonusMultiplier = 15;
    float drillPower = drillPowerLevel * drillPowerBonusMultiplier;
    //use this number to change value accuracy
    float accuracyBonusMultiplier = 1.5;
    float accuracyBonusPoints = accuracyBonus * accuracyBonusMultiplier;
    
    float totalPointsForShot = accuracyBonus + (accuracyBonusPoints * drillPower);
    
    [[DIOSocketManager sharedManager] sendAction:DIOActionDrill andData:@{
                                                                          @"drillPower":[NSString stringWithFormat:@"%f", totalPointsForShot]
                                                                          }];
    
    NSLog(@"%f",totalPointsForShot);
}


#pragma mark lazy load

- (UIView *)errorMessage
{
    if(!_errorMessage) {
        UIView *errorMessageContainer = [[UIView alloc] initWithFrame:self.bounds];
        errorMessageContainer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        UIView *errorBox = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 300, self.frame.size.height / 2 - 150 , 600, 300)];
        errorBox.backgroundColor = [UIColor redColor];
        [errorMessageContainer addSubview:errorBox];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, errorBox.frame.size.width - 40, 80.0)];
        headerLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:50.0];
        headerLabel.text = @"SYSTEM FAILURE!";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.textColor = [UIColor whiteColor];
        [errorBox addSubview:headerLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, headerLabel.frame.size.height + 20, errorBox.frame.size.width - 40, 150.0)];
        detailLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:30.0];
        detailLabel.text = @"YOUR SHIP HAS LOST COMMUNICATION WITH MISSION CONTROL. PLEASE ADVISE A SCIENCE CENTRE TECHNICIAN.";
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.numberOfLines = 0;
        [errorBox addSubview:detailLabel];
        
        _errorMessage = errorMessageContainer;
    }
    
    return _errorMessage;
}
                        
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

- (UIView *)display
{
    if(!_display) {
        self.display = [[UIView alloc] initWithFrame:CGRectMake(60, 50, 909, 98)];
        [self.display setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DisplayBackground"]]];
        
        UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.display.frame.size.width - 40, self.display.frame.size.height - 40)];
        displayLabel.font = [UIFont fontWithName:@"DS-Digital" size:45.0f];
        displayLabel.textColor = [UIColor colorWithHue:0.277 saturation:0.761 brightness:0.953 alpha:1];
        [self.display addSubview:displayLabel];
        displayLabel.text = [NSString stringWithFormat:@"PLAYER #%@", [[DIOSocketManager sharedManager] deviceID]];
        displayLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _display;
}

@end
