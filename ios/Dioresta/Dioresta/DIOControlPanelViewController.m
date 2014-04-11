//
//  DIOControlPanelViewController.m
//  Dioresta
//
//  Created by Brian Gilham on 2014-04-11.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanelViewController.h"

@interface DIOControlPanelViewController ()

@property (weak, nonatomic) IBOutlet UIButton *drillButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation DIOControlPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - Actions
- (IBAction)drill:(id)sender
{
    NSLog(@"DRILL!");
}

- (IBAction)left:(id)sender
{
    NSLog(@"LEFT!");
}

- (IBAction)right:(id)sender
{
    NSLog(@"RIGHT!");
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
