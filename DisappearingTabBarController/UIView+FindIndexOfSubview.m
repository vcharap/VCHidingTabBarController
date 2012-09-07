//
//  UIView+FindIndexOfSubview.m
//  DisappearingTabBarController
//
//  Created by Victor Charapaev on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+FindIndexOfSubview.h"

@implementation UIView (FindIndexOfSubview)
-(NSInteger)indexOfSubview:(UIView *)subview
{
    NSInteger idx = NSNotFound;
    if(subview){
        idx = [[self subviews] indexOfObject:subview];
    }
    return idx;
}
@end
