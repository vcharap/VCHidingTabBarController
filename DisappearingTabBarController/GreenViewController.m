//
//  GreenViewController.m
//  DisappearingTabBarController
//
//  Created by Victor Charapaev on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GreenViewController.h"
#import "AppDelegate.h"


@interface GreenViewController ()

@end

@implementation GreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)pushNext:(id)sender
{
    UIViewController* next = [[[UIViewController alloc] init] autorelease];
    next.view.backgroundColor = [UIColor purpleColor];
    next.title = @"Purple";
    [self.navigationController pushViewController:next animated:YES];
}

-(void)changeToVisibility:(NSString*)visibility
{
    NSNotification* notification = [NSNotification notificationWithName:ChangeTabBarVisibilityNotification object:nil userInfo:[NSDictionary dictionaryWithObject:visibility forKey:ChangeTabBarNotificationBarStatusKey]];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(IBAction)showBar:(id)sender
{
    [self changeToVisibility:TabBarVisible];
}

-(IBAction)hideBar:(id)sender
{
    [self changeToVisibility:TabBarHidden];
}
@end
