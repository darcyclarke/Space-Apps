//
//  DIOAccelerometerViewController.m
//  Dioresta
//
//  Created by Andrew McCallum14 on 2014-04-11.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import "DIOAccelerometerViewController.h"
#import <CoreMotion/CoreMotion.h>

double currentMaxAccelY;
double currentMaxRotY;

double accelY;
double rotY;

@interface DIOAccelerometerViewController ()

@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UILabel *accY;
@property (weak, nonatomic) IBOutlet UILabel *rotY;
@property (weak, nonatomic) IBOutlet UILabel *maxAccY;
@property (weak, nonatomic) IBOutlet UILabel *maxRotY;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation DIOAccelerometerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentMaxAccelY = 0;
    
    currentMaxRotY = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(logAccelRotData:) userInfo:nil repeats:YES];
}

- (void)logAccelRotData:(NSTimer *)sender
{
    NSLog(@"acc:%f",accelY);
    NSLog(@"rot:%f",rotY);
    
    self.boxView.center = CGPointMake(self.boxView.center.x + ((accelY + rotY) * 10), self.boxView.center.y);
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    accelY = acceleration.y;
    
    self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
    self.maxAccY.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelY];
}

-(void)outputRotationData:(CMRotationRate)rotation
{
    rotY = rotation.y;

    
    self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    if(fabs(rotation.y) > fabs(currentMaxRotY))
    {
        currentMaxRotY = rotation.y;
    }

    self.maxRotY.text = [NSString stringWithFormat:@" %.2f",currentMaxRotY];
}

- (IBAction)resetMaxValues:(id)sender
{
    currentMaxAccelY = 0;
    
    currentMaxRotY = 0;
}

@end
