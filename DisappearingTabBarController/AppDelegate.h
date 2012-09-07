//
//  AppDelegate.h
//  DisappearingTabBarController
//
//  Created by Victor Charapaev on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCHidingTabBarController.h"

extern NSString* const ChangeTabBarVisibilityNotification;
extern NSString* const ChangeTabBarNotificationBarStatusKey;

extern NSString* const TabBarVisible;
extern NSString* const TabBarHidden;

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    VCHidingTabBarController* _tabBarController;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
