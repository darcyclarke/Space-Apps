//
//  DIOControlPanelViewController.m
//  Dioresta
//
//  Created by Brian Gilham on 2014-04-11.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOControlPanelViewController.h"

#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@interface DIOControlPanelViewController () <GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UIButton *drillButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) GCDAsyncSocket *socket;

@end

@implementation DIOControlPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error;
    if(![self.socket connectToHost:@"" onPort:80 error:&error]) {
        NSLog(@"ERROR: Failed to connect to server. %@", [error localizedDescription]);
    }
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

#pragma mark - Sockets
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"DID ACCEPT NEW SOCKET");
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"DID CONNECT TO HOST");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"DID READ DATA");
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"DID READ PARTIAL DATA OF LENGTH");
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"DID WRITE DATA WITH TAG");
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"DID WRITE PARTIAL DATA OF LENGTH");
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"DID CLOSE READ STREAM");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"DID DISCONNECT");
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"DID SECURE");
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
