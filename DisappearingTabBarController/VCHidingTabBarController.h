//
//  VCTabBarController.h
//  DisappearingTabBarController
//
//  Created by Victor Charapaev on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCHidingTabBarController;

@protocol VCHidingTabBarControllerDelegate <UITabBarControllerDelegate>

-(void)willHideTabBar:(VCHidingTabBarController*)controller;
-(void)didHideTabBar:(VCHidingTabBarController*)controller;

-(void)willShowTabBar:(VCHidingTabBarController*)controller;
-(void)didShowTabBar:(VCHidingTabBarController*)controller;

@end


/*
 @class 
        VCHidingTabBarController
    
 @abstract
        A  UITabBarController replacement with a UITabBar that can be
        moved offscreen, for those times when more screen area is desired
        
 @description
        The class closely resembles a UITabBarController in functionality. 
        All of the available properties and methods operate exactly like
        their UITabBarController counterparts unless noted below. Consult UITabBarController
        documentation for expected behavior.
 
        There are currently some limitations. 
 
            1. The controller must be loaded programatically and can not be instantiated from a nib.
            2. The controller's view frame takes up the whole screen (320 by 480). Your controllers' views are placed into this view,
            and thus will also have a frame size that is the whole screen (320x480). The UITabBar will sit on top, partially
            obscuring your views. This is a potentially serious limitation. A future update will allow for the option
            of having a container view that is sized to sit above the tabBar into which your views will go.
 
            3. "More Controller" is currently not implimented. Instead the
            controller can hold up to 5 different controllers. 
            4. Since there is no "More Controller", rearranging of view controllers is 
            not implimented.
 */


@interface VCHidingTabBarController : UIViewController <UITabBarDelegate>
{
@private
    UITabBar *_tabBar;
    NSArray *_viewContorllers;
    id<UITabBarControllerDelegate> _delegate;
    
    NSArray *_viewControllers;

    
    UIViewController *_realCurrentController;
    NSUInteger _realSelectedIndex;
    
    UIViewController *_selectedViewControllerRef;
    NSUInteger _selectedIndex;
    
    BOOL _visible;
    
    NSTimeInterval _hideDuration;
    CGRect _visibleFrame;
    CGRect _hiddenFrame;
    BOOL _barVisible;
}



/*
 
 The properties and methods here mimic behaviour of the same
 properties found on UITabBarController. See UITabBarController
 documentation.
 
 */
@property (nonatomic, assign) id<UITabBarControllerDelegate> delegate;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, assign) UIViewController *selectedViewController;
@property (nonatomic, readonly) UITabBar *tabBar;
@property (nonatomic, copy) NSArray *viewControllers;

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;


/*
 @abstract
        Set the duration of the show/hide animation
 */
@property (nonatomic) NSTimeInterval hideDuration;

/*
 @abstract
        Hides the tab bar. willHideTabBar and didHideTabBar are 
        called during the hiding process, even if animted is NO
 */
-(void)hideTabBarAnimated:(BOOL)animated;

/*
 @abstract
     Shows the tab bar. willShowTabBar and didShowTabBar are 
     called during the showing process, even if animted is NO
 */
-(void)showTabBarAnimated:(BOOL)animated;


@end
