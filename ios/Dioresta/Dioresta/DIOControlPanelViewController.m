//
//  DIOControlPanelViewController.m
//  Dioresta
//
//  Created by Brian Gilham on 2014-04-11.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanelViewController.h"

#import "DIOSocketManager.h"

@interface DIOControlPanelViewController ()

@property (weak, nonatomic) IBOutlet UIButton *drillButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation DIOControlPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTimer];
}

#pragma mark - View Setup
- (void)setupTimer
{
    self.timerLabel.text = @"hello";
    self.timerLabel.font = [UIFont fontWithName:@"DS-Digital" size:45.0f];
}

#pragma mark - Actions
- (IBAction)drill:(id)sender
{
    NSLog(@"DRILL!");
    [[DIOSocketManager sharedManager] sendAction:DIOActionDrill andData:@{
                                                                          @"drillPower":@"10"
                                                                          }];
}

- (IBAction)left:(id)sender
{
    NSLog(@"LEFT!");
    [[DIOSocketManager sharedManager] sendAction:DIOActionLeft andData:nil];
}

- (IBAction)right:(id)sender
{
    NSLog(@"RIGHT!");
    [[DIOSocketManager sharedManager] sendAction:DIOActionRight andData:nil];
}

@end
