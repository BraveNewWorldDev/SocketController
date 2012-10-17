//
//  controllerViewController.m
//  Controller
//
//  Created by Raised Media on 12-10-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "controllerViewController.h"

CMMotionManager *motionManager;
NSInputStream *inputStream;
NSOutputStream *outputStream;

@interface controllerViewController ()

@end

@implementation controllerViewController
@synthesize deviceID;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 0.04; //24 FPS
    [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] 
        withHandler:^(CMDeviceMotion *motion, NSError *error) 
        {
            CMAttitude *currentAttitude = motionManager.deviceMotion.attitude;
            
            NSString *response  = [[NSString alloc] initWithFormat:@"{\"action\": \"motion\",\"data\":{\"yaw\": %.4f, \"roll\": %.4f, \"pitch\": %.4f, \"id\":\"%s\"}}", 
                currentAttitude.yaw, currentAttitude.roll, currentAttitude.pitch, [self.deviceID.text UTF8String]];
            NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
            [outputStream write:[data bytes] maxLength:[data length]];
        }
    ];
    NSString *deviceIDText = [[NSString alloc] initWithFormat:@"%c%c%c%c%c%c", [controllerViewController genChar],
                              [controllerViewController genChar], [controllerViewController genChar],
                              [controllerViewController genChar], [controllerViewController genChar],
                              [controllerViewController genChar]];
    [self.deviceID setText:deviceIDText];
    [self initNetworkCommunication];
}

- (void)viewDidUnload
{
    [self setDeviceID:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [motionManager stopDeviceMotionUpdates];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown &&
            interfaceOrientation != UIInterfaceOrientationPortrait);
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"10.0.1.62", 8124, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (IBAction)resetIsTouched:(UIButton *)sender {
    CMAttitude *currentAttitude = motionManager.deviceMotion.attitude;
    
    NSString *response  = [[NSString alloc] initWithFormat:@"{\"action\": \"reset\",\"data\":{\"yaw\": %.4f, \"roll\": %.4f, \"pitch\": %.4f, \"id\":\"%s\"}}", 
        currentAttitude.yaw, currentAttitude.roll, currentAttitude.pitch, [self.deviceID.text UTF8String]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

+ (char)genChar
{
    return (char)((arc4random() % 26) + 65);
}
@end
