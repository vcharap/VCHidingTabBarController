//
//  VCTabBarController.m
//  DisappearingTabBarController
//
//  Created by Victor Charapaev on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VCHidingTabBarController.h"
#import "UIView+FindIndexOfSubview.h"


#define VISIBLE_CONTROLLER_VIEW_TAG 100
#define VISIBLE_SUBVIEW_INDEX 0

@interface VCHidingTabBarController ()

// Helper function, returns an array of UITabBarItems for the given controllers
// If a controller does not have a UITabBarItem, one is created with nil properties
//
-(NSArray*)tabBarItemsForControllers:(NSArray*)controllers;

// Function transitions to the requested controllers, removing any previous controller,
// and setting realCurrentController to newController
//
// If addView == YES, the new view is loaded and added to the container view
// If setIndex == YES, realSelectedIndex is updated to the index of newController
// If setTabBar == YES, the item at realSelectedIndex is selected
// If isVisible == YES, appear/disappear callbacks are called as needed
//
-(void)transitionViewController:(UIViewController*)newController addView:(BOOL)addView setIndex:(BOOL)setIndex setTabBar:(BOOL)setTabBar visible:(BOOL)isVisible;

-(BOOL)viewPresentInHierarchy:(UIViewController*)controller;

-(void)informController:(UIViewController*)controller ofViewWillAppear:(BOOL)animated;
-(void)informController:(UIViewController*)controller ofViewDidAppear:(BOOL)animated;
-(void)informController:(UIViewController*)controller ofViewWillDisappear:(BOOL)animated;
-(void)informController:(UIViewController *)controller ofViewDidDisappear:(BOOL)animated;

-(void)informDelegateOfAnimationWithSelector:(SEL)selector;


@property (nonatomic, retain) UIViewController* realCurrentController;
@property (nonatomic) NSUInteger realSelectedIndex;


@property BOOL barVisible;

@end

@implementation VCHidingTabBarController
@synthesize viewControllers = _viewControllers, delegate = _delegate, tabBar = _tabBar, selectedViewController = _selectedViewControllerRef;
@synthesize selectedIndex = _selectedIndex;
@synthesize realCurrentController = _realCurrentController, realSelectedIndex = _realSelectedIndex;
@synthesize barVisible = _barVisible, hideDuration = _hideDuration;

#pragma mark Properties

-(id)init
{
    if(self = [super init]){
        _visibleFrame = CGRectMake(0, 431, 320, 49);
        _hiddenFrame = CGRectMake(0, 480, 320, 49);
        
        _tabBar = [[UITabBar alloc] init];
        _tabBar.frame = _visibleFrame;
        _tabBar.delegate = self;
        _hideDuration = 0.5;
        _barVisible = YES;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [_tabBar release];
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    // Assume nil arg means an attempt to relese currently held view controllers
    if(!viewControllers){
        [_viewControllers release];
        _viewControllers = nil;
    }
    else{
        [self setViewControllers:viewControllers animated:NO];
    }
    
}

-(NSUInteger)selectedIndex
{
    return  self.realSelectedIndex;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(!self.viewControllers || 
       selectedIndex > 4 || 
       selectedIndex == self.realSelectedIndex || 
       selectedIndex >= [self.viewControllers count]) return;
    
    self.selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
}

-(UIViewController*)selectedViewController
{
    return self.realCurrentController;
}

-(void)setSelectedViewController:(UIViewController *)selectedViewController
{
    NSInteger idx = [self.viewControllers indexOfObject:selectedViewController];
    
    if(!selectedViewController || 
       !self.viewControllers || 
       self.realCurrentController == selectedViewController || 
       idx == NSNotFound) return;
    
    [self transitionViewController:selectedViewController addView:[self viewPresentInHierarchy:self.realCurrentController] setIndex:YES setTabBar:YES visible:_visible];
}

#pragma mark View Housekeeping

-(void)loadView
{
    CGRect frame = CGRectMake(0, 0, 320, 480);
    UIView *view = [[[UIView alloc] initWithFrame:frame] autorelease];
    
    [view addSubview:_tabBar];
    view.backgroundColor = [UIColor redColor];
    self.view = view;
}

- (void)viewDidLoad
{
    if(self.viewControllers && !self.tabBar.items){
        [self.tabBar setItems:[self tabBarItemsForControllers:self.viewControllers] animated:NO];
    }
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if(![self viewPresentInHierarchy:self.realCurrentController]){
        [self transitionViewController:self.realCurrentController addView:YES setIndex:YES setTabBar:YES visible:NO];
    }
    
    [self informController:self.realCurrentController ofViewWillAppear:animated];
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _visible = YES;
    [self informController:self.realCurrentController ofViewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self informController:self.realCurrentController ofViewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _visible = NO;
    [self informController:self.realCurrentController ofViewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    for(UIViewController* controller in self.viewControllers){
        controller.view = nil;
        //[controller viewDidUnload];
    }
    
}


#pragma mark Public Methods

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    if(viewControllers && self.viewControllers != viewControllers){
        [_viewControllers release];
        _viewControllers = [viewControllers copy];
        
        [self.tabBar setItems:[self tabBarItemsForControllers:_viewControllers] animated:animated];
        
        BOOL addView = NO;
        NSUInteger selectedIdx = self.realSelectedIndex;
        UIViewController* newController = nil;
        
        NSUInteger idx = [_viewControllers indexOfObject:self.realCurrentController];
        if(idx != NSNotFound){
            newController = self.realCurrentController;
        }
        else{
            if(selectedIdx >= [_viewControllers count]){
                selectedIdx = 0;
            }
            
            if([self viewPresentInHierarchy:self.realCurrentController]){
                addView = YES;
            }
            
            newController = [self.viewControllers objectAtIndex:selectedIdx];
        }
        
        [self transitionViewController:newController addView:addView setIndex:YES setTabBar:YES visible:_visible];
    }
}

-(void)setTabBarToFrame:(CGRect)frame willBeVisible:(BOOL)visible withBeforeBacllbaks:(SEL)beforeCallback afterCallback:(SEL)afterCallback animated:(BOOL)animated
{
    [self informDelegateOfAnimationWithSelector:beforeCallback];
    if(animated){
        
        [UIView animateWithDuration:self.hideDuration animations:^{
            self.tabBar.frame = frame;
        } completion:^(BOOL finished) {
            if(finished){
                [self informDelegateOfAnimationWithSelector:afterCallback];
                self.barVisible = visible;
            }
        }];
    }
    else{
        self.tabBar.frame = frame;
        self.barVisible = visible;
        [self informDelegateOfAnimationWithSelector:afterCallback];
    }
}

-(void)hideTabBarAnimated:(BOOL)animated
{
    if(self.barVisible){
        
        [self setTabBarToFrame:_hiddenFrame 
                 willBeVisible:NO 
           withBeforeBacllbaks:@selector(willHideTabBar:) 
                 afterCallback:@selector(didHideTabBar:) 
                      animated:animated];
    }
}

-(void)showTabBarAnimated:(BOOL)animated
{
    if(!self.barVisible){
        
        [self setTabBarToFrame:_visibleFrame 
                 willBeVisible:YES 
           withBeforeBacllbaks:@selector(willShowTabBar:) 
                 afterCallback:@selector(didShowTabBar:) 
                      animated:animated];
    }
}

#pragma mark Private Methods

-(void)transitionViewController:(UIViewController*)newController addView:(BOOL)addView setIndex:(BOOL)setIndex setTabBar:(BOOL)setTabBar visible:(BOOL)isVisible
{
    if(newController != self.realCurrentController){
        
        //remove current controller's view from heirarchy
        //
        if(self.realCurrentController){
            NSInteger index = [self.view indexOfSubview:self.realCurrentController.view];
            if(index != NSNotFound){
                if(isVisible){
                    [self informController:self.realCurrentController ofViewWillDisappear:YES];
                }
                
                [self.realCurrentController.view removeFromSuperview];
                
                if(isVisible){
                    [self informController:self.realCurrentController ofViewDidDisappear:YES];
                }
                
            }
        }
        
        self.realCurrentController = newController;
    }
        
    
    if(setIndex){
        self.realSelectedIndex = [_viewControllers indexOfObject:newController];
    }
    
    if(setTabBar){
        [self.tabBar setSelectedItem:self.realCurrentController.tabBarItem];
    }
    
    if(addView){
        if(!self.realCurrentController.isViewLoaded){
            [self.realCurrentController loadView];
            [self.realCurrentController viewDidLoad];
        }
        
        [self.view insertSubview:self.realCurrentController.view atIndex:VISIBLE_SUBVIEW_INDEX];
        
        if(isVisible){
            [self informController:self.realCurrentController ofViewWillAppear:NO];
            [self informController:self.realCurrentController ofViewDidAppear:NO];
        }
    }


}

-(BOOL)viewPresentInHierarchy:(UIViewController *)controller
{    
    return ([controller isViewLoaded] && controller.view.superview) ? YES : NO;
}

-(UITabBarItem*)tabBarItemForController:(UIViewController*)controller
{
    UITabBarItem *item = controller.tabBarItem;

    if(!item){
        item = [[[UITabBarItem alloc] initWithTitle:controller.title image:nil tag:0] autorelease];
    }
    return item;
}
-(NSArray*)tabBarItemsForControllers:(NSArray*)controllers
{
    NSMutableArray *tabBarItems = nil;
    if(controllers){
       tabBarItems = [[[NSMutableArray alloc] initWithCapacity:[self.viewControllers count]] autorelease];
        
        for(UIViewController *controller in self.viewControllers){
            [tabBarItems addObject:[self tabBarItemForController:controller]];
        }
    }
    
    return [NSArray arrayWithArray:tabBarItems];
}


-(void)informController:(UIViewController*)controller ofViewWillAppear:(BOOL)animated
{
    if([controller respondsToSelector:@selector(viewWillAppear:)]){
        [controller viewWillAppear:animated];
    }
}
-(void)informController:(UIViewController*)controller ofViewDidAppear:(BOOL)animated
{
    if([controller respondsToSelector:@selector(viewDidAppear:)]){
        [controller viewDidAppear:animated];
    }
}
-(void)informController:(UIViewController*)controller ofViewWillDisappear:(BOOL)animated
{
    if([controller respondsToSelector:@selector(viewWillDisappear:)]){
        [controller viewWillDisappear:animated];
    }
}
-(void)informController:(UIViewController *)controller ofViewDidDisappear:(BOOL)animated
{
    if([controller respondsToSelector:@selector(viewDidDisappear:)]){
        [controller viewDidDisappear:animated];
    }
}

-(void)informDelegateOfAnimationWithSelector:(SEL)selector
{
    if([_delegate respondsToSelector:selector]){
        [_delegate performSelector:selector withObject:self];
    }
}
             
#pragma mark Tab Bar Delegate
// called when a new view is selected by the user (but not programatically)
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //selecting a TabBarItem always presents root controller of the controller associated with that TabBarItem
    
    // Find associated view controller by index of UITabBarItem
    //
    NSUInteger idx = [self.tabBar.items indexOfObject:item];
    if(idx != NSNotFound){
        UIViewController* newController = [self.viewControllers objectAtIndex:idx];
        [self transitionViewController:newController addView:[self viewPresentInHierarchy:self.realCurrentController] setIndex:YES setTabBar:NO visible:_visible];
        
        if([newController respondsToSelector:@selector(popToRootViewControllerAnimated:)]){
            [(UINavigationController*)newController popToRootViewControllerAnimated:_visible];
        }
    }
    
}

/* called when user shows or dismisses customize sheet. you can use the 'willEnd' to set up what appears underneath. 
 changed is YES if there was some change to which items are visible or which order they appear. If selectedItem is no longer visible, 
 it will be set to nil.
 */

// called before customize sheet is shown. items is current item list
- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items
{

}

// called after customize sheet is shown. items is current item list
- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items
{

}

// called before customize sheet is hidden. items is new item list
- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{

}

// called after customize sheet is hidden. items is new item list
- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{
    
}

@end
