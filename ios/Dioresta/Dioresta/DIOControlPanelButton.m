//
//  DIOControlPanelButton.m
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanelButton.h"

@implementation DIOControlPanelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *drillButtonImage = [UIImage imageNamed:@"NewDrillButtonUp"];
        
        [self setImage:drillButtonImage forState:UIControlStateNormal];
        
        UIImage *drillButtonImageDown = [UIImage imageNamed:@"NewDrillButtonDown"];
        
        [self setImage:drillButtonImageDown forState:UIControlStateHighlighted];
        [self setImage:drillButtonImageDown forState:UIControlStateSelected];
    }
    return self;
}


@end
