//
//  controllerViewController.h
//  Controller
//
//  Created by Raised Media on 12-10-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class controllerAppDelegate;

@interface controllerViewController : UIViewController <NSStreamDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deviceID;
- (IBAction)resetIsTouched:(UIButton *)sender;

@end
