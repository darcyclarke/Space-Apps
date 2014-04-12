//
//  DIODJSlider.m
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIODJSlider.h"

@implementation DIODJSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupThumbImage];
    }
    return self;
}

- (void)setupThumbImage
{
    UIImage *thumbImage = [UIImage imageNamed:@"sliderThumbImage"];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}


@end
