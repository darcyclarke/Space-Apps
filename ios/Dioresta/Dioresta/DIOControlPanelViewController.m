//
//  DIOControlPanelViewController.m
//  Dioresta
//
//  Created by Brian Gilham on 2014-04-11.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanelViewController.h"

#import <socket.IO/SocketIO.h>

static NSString *const DIOHost = @"";
static NSString *const DIONamespace = @"";

@interface DIOControlPanelViewController () <SocketIODelegate>

@property (weak, nonatomic) IBOutlet UIButton *drillButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;


@property (strong, nonatomic) SocketIO *socket;

@end

@implementation DIOControlPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    [self.socket connectToHost:@""
                        onPort:3000
                    withParams:@{}
                 withNamespace:@""];
    
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
    [self.socket sendJSON:@{
                            @"shipId":@"1",
                            @"direction":@"down"
                            }];
}

- (IBAction)left:(id)sender
{
    NSLog(@"LEFT!");
    [self.socket sendJSON:@{
                            @"shipId":@"1",
                            @"direction":@"left"
                            }];
}

- (IBAction)right:(id)sender
{
    NSLog(@"RIGHT!");
    [self.socket sendJSON:@{
                            @"shipId":@"1",
                            @"direction":@"right"
                            }];
}

#pragma mark - Sockets
- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"DID RECEIVE EVENT");
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet
{
    NSLog(@"DID RECEIVE JSON");
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"DID RECEIVE MESSAGE");
}

- (void)socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet
{
    NSLog(@"DID SEND MESSAGE");
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"ON ERROR");
}

- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"DID CONNECT");
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"DID DISCONNECT");
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
