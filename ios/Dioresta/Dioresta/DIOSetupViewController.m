//
//  DIOSetupViewController.m
//  Dioresta
//
//  Created by Brian Gilham on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOSetupViewController.h"

@interface DIOSetupViewController ()

@end

@implementation DIOSetupViewController

#pragma mark - View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - Navigation
- (IBAction)selectedButton:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    NSString *deviceID = selectedButton.titleLabel.text;
    
    [self performSegueWithIdentifier:@"DIOControlPanel" sender:deviceID];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *deviceID = (NSString *)sender;
    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:@"DIODeviceID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
