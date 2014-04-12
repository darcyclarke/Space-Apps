//
//  DIODrillMeter.h
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  METER_CONTAINER_WIDTH 200.0f

@interface DIODrillAccuracyMeter : UIView

@property (strong, nonatomic) UIView *meterContainer;
@property (strong, nonatomic) UIView *sliderIndicator;
@property (strong, nonatomic) UIView *powerIndicator;

- (void)moveSliderIndicatorWithSliderValue:(float)sliderValue;

@end
