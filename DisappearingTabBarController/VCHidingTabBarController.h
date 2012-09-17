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
 
            3. "More Controller" is currently not implimented. Instead the
            controller can hold up to 5 different controllers. 
            4. Since there is no "More Controller", rearranging of view controllers is 
            not implimented.
 */


@interface VCHidingTabBarController : UIViewController <UITabBarDelegate>
{
@private
    UIView* _containerView;
    UITabBar *_tabBar;
    id<UITabBarControllerDelegate> _delegate;
    
    NSArray *_viewControllers;
    
    UIViewController *_realCurrentController;
    NSUInteger _realSelectedIndex;
    
    UIViewController *_selectedViewControllerRef;
    NSUInteger _selectedIndex;
    
    BOOL _visible;
    BOOL _resize;
    
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
        Determines if the view of a contained view controller is resized
        when the tab bar is moved off screen. 
        If set to NO, the "content area" will be the whol screen, meaning the contained view will take up the full screen, and be
        partly obscured by a tab bar in visible state.
        
        If set to YES, the contained view will we resized to fit within the "content area", changing in size
        as the tab bar is hidden/shown.
*/
@property (nonatomic) BOOL resize;
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
