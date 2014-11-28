//
//  AppDelegate.h
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;

@end