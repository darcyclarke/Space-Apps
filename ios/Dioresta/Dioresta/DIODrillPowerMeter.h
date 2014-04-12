//
//  DIODrillPowerMeter.h
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DIODrillPowerMeterDelegate <NSObject>
@required
- (void)didDrillWithPowerLevel:(float)drillPowerLevel;

@end

@interface DIODrillPowerMeter : UIView

@property (assign, nonatomic) id<DIODrillPowerMeterDelegate> delegate;

- (void)didPressDrillButton:(UIButton *)sender;
- (void)didReleaseDrillButton:(UIButton *)sender;

@end
