//
//  AppDelegate.m
//  DisappearingTabBarController
//
//  Created by Victor Charapaev on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GreenViewController.h"

NSString* const ChangeTabBarVisibilityNotification = @"ChangeTabBarVisibilityNotification";
NSString* const ChangeTabBarNotificationBarStatusKey = @"ChangeTabBarNotificationBarStatusKey";

NSString* const TabBarVisible = @"TabBarVisible";
NSString* const TabBarHidden = @"TabBarHidden";

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tabBarController release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Create dummy controllers to test functionality of VCHidingTabBarController
    
    UIViewController* cont1 = [[[UIViewController alloc] init] autorelease];
    cont1.view.backgroundColor = [UIColor redColor];
    cont1.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Red" image:nil tag:0] autorelease];
    
    UIViewController* cont2 = [[[UIViewController alloc] init] autorelease];
    cont2.view.backgroundColor = [UIColor blueColor];
    cont2.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Blue" image:nil tag:0] autorelease]; 
    
    GreenViewController* cont3 = [[[GreenViewController alloc] init] autorelease];
    cont3.view.backgroundColor = [UIColor greenColor];
    cont3.title = @"Green";
    
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:cont3] autorelease];
    nav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Navi" image:nil tag:0] autorelease];
    
    _tabBarController = [[VCHidingTabBarController alloc] init];
    _tabBarController.viewControllers = [NSArray arrayWithObjects:nav, cont1, cont2, nil];
    _tabBarController.resize = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarNotification:) name:ChangeTabBarVisibilityNotification object:nil];
    
    [self.window addSubview:_tabBarController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)tabBarNotification:(NSNotification*)notification
{
    NSString* barStatus = [[notification userInfo] objectForKey:ChangeTabBarNotificationBarStatusKey];
    if([barStatus isEqualToString:TabBarVisible]){
        [_tabBarController showTabBarAnimated:YES];
    }
    else if([barStatus isEqualToString:TabBarHidden]){
        [_tabBarController hideTabBarAnimated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
