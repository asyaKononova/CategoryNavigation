//
//  UIViewController+StackNavigationController.m
//  CategoryNavigation
//
//  Created by Anastasia Kononova on 9/13/15.
//  Copyright (c) 2015 Asya Kononova. All rights reserved.
//

#import "UIViewController+StackNavigationController.h"
#import <objc/runtime.h>

static char SLIDE_KEY;

@implementation UIViewController (StackNavigationController)

- (StackNavigationController *)stackNavigationController
{
    return (StackNavigationController *)objc_getAssociatedObject(self, &SLIDE_KEY);
}

- (void) setStackNavigationController:(StackNavigationController *)stackNavigationController
{
    if (nil == stackNavigationController)
        objc_removeAssociatedObjects(self);
    else
        objc_setAssociatedObject(self, &SLIDE_KEY, stackNavigationController, OBJC_ASSOCIATION_ASSIGN);
}

@end
