//
//  controllerAppDelegate.h
//  Controller
//
//  Created by Raised Media on 12-10-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class controllerViewController;

@interface controllerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) controllerViewController *viewController;
@property (strong, nonatomic) NSString *deviceID;

@end
