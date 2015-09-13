//
//  StackNavigationController.h
//  CategoryNavigation
//
//  Created by Anastasia Kononova on 9/13/15.
//  Copyright (c) 2015 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StackNavigationControllerDelegate;

@interface StackNavigationController : UIViewController

@property (nonatomic, assign) CGFloat minTopControllerWidth;

@property (nonatomic, strong, readonly) UIViewController *topViewController;
@property (nonatomic, strong, readonly) NSArray *viewControllers;

@property (nonatomic, assign) id<StackNavigationControllerDelegate> delegate;

- (id)initWithRootViewController:(UIViewController *)rootViewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController dismissControllersBeyond:(UIViewController*)parentViewController animated:(BOOL)animated;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;

@end

@protocol StackNavigationControllerDelegate<NSObject>
@optional
- (void)stackNavigationController:(StackNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)stackNavigationController:(StackNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end