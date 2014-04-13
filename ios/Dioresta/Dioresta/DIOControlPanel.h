//
//  DIOControlPanel.h
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
//controls
#import "DIOControlPanelButton.h"
#import "DIODJSlider.h"
#import "DIODrillAccuracyMeter.h"
#import "DIODrillPowerMeter.h"

@interface DIOControlPanel : UIView <DIODrillPowerMeterDelegate>

@property (strong, nonatomic) DIOControlPanelButton *drillButton;
@property (strong, nonatomic) DIODJSlider *slider;
@property (strong, nonatomic) DIODrillAccuracyMeter *drillAccuracyMeter;
@property (strong, nonatomic) DIODrillPowerMeter *drillPowerMeter;
@property (strong, nonatomic) UIView *errorMessage;
@property (strong, nonatomic) UIView *display;
@property (strong, nonatomic) UILabel *displayLabel;

@end
