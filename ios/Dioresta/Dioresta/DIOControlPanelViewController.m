//
//  DIOControlPanelViewController.m
//  Dioresta
//
//  Created by Brian Gilham on 2014-04-11.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanelViewController.h"
#import "DIOControlPanel.h"

#import "DIOSocketManager.h"

@interface DIOControlPanelViewController ()

@property (weak, nonatomic) IBOutlet UIButton *drillButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) DIOControlPanel *controlPanel;
@property (strong, nonatomic) IBOutlet UIView *errorContainer;

@end

@implementation DIOControlPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnectWithError) name:@"DIODidDisconnectWithError" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnect) name:@"DIODidConnect" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commonCollected:) name:@"DIOCommonCollected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scarceCollected:) name:@"DIOScarceCollected" object:nil];
    
    [self setupTimer];
    
    self.controlPanel = [[DIOControlPanel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds))];
    [self.view addSubview:self.controlPanel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)didDisconnectWithError
{
    self.errorContainer.hidden = NO;
    self.controlPanel.errorMessage.hidden = NO;
}

- (void)didConnect
{
    self.errorContainer.hidden = YES;
    self.controlPanel.errorMessage.hidden = YES;
}

- (IBAction)didTapError:(id)sender {
    
}

- (void)commonCollected:(NSNotification *)note
{
    self.controlPanel.displayLabel.text = [NSString stringWithFormat:@"PLAYER #%@: +%@ %@ COLLECTED!", [[DIOSocketManager sharedManager] deviceID], note.userInfo[@"amount"], note.userInfo[@"name"]];
}

- (void)scarceCollected:(NSNotification *)note
{
    self.controlPanel.displayLabel.text = [NSString stringWithFormat:@"PLAYER #%@: +%@ %@ COLLECTED!", [[DIOSocketManager sharedManager] deviceID], note.userInfo[@"amount"], note.userInfo[@"name"]];
}

@end
