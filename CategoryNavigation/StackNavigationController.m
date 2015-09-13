//
//  StackNavigationController.m
//  CategoryNavigation
//
//  Created by Anastasia Kononova on 9/13/15.
//  Copyright (c) 2015 Asya Kononova. All rights reserved.
//

#import "StackNavigationController.h"
#import "UIViewController+StackNavigationController.h"

static CGFloat const kBorderGap = 40.f;
static CGFloat const kAnimationDuration = 0.5f;
static CGFloat const kDefaultWidth = 150.f;

@implementation StackNavigationController {
    UIViewController *_rootViewController;
    NSMutableArray *_controllersStack;
    
    NSUInteger touchControllerIndex;
    CGPoint initialTouchLocation;
    CGFloat touchControllerWidth;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        _rootViewController = rootViewController;
        _rootViewController.stackNavigationController = self;
        
        _controllersStack = [NSMutableArray array];
        [_controllersStack addObject:_rootViewController];
        
        _minTopControllerWidth = kDefaultWidth;
    }
    return self;
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeHandler:)];
    [self.view addGestureRecognizer:recognizer];
    
    _rootViewController.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_rootViewController];
    [self.view addSubview:_rootViewController.view];
    [self didMoveToParentViewController:_rootViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [self popToRootViewControllerAnimated:NO];
}

#pragma mark - Properties

- (UIViewController *)topViewController
{
    return (UIViewController *)_controllersStack.lastObject;
}

- (NSArray *)viewControllers
{
    return [_controllersStack copy];
}

#pragma mark - Public

- (void)pushViewController:(UIViewController *)viewController dismissControllersBeyond:(UIViewController *)parentViewController animated:(BOOL)animated
{
    if (parentViewController != nil) {
        [self popToViewController:parentViewController animated:NO];
    }
    
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *topViewController = self.topViewController;
    viewController.view.frame = [self initialControllerFrameForWidth:[[self recalculatedControllersWidth].lastObject floatValue]];
    viewController.stackNavigationController = self;
    [_controllersStack addObject:viewController];
    
    [topViewController willMoveToParentViewController:nil];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [self addShadowToController:viewController];
    
    [self navigationWillShowViewController:self.topViewController animated:animated];
    
    void (^completionBlock)(BOOL finish) = ^(BOOL finish) {
        [self didMoveToParentViewController:viewController];
        [topViewController didMoveToParentViewController:nil];
        [self navigationDidShowViewController:self.topViewController animated:animated];
    };
    
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^() {
            [self recalculateControllersFrame];
        } completion:completionBlock];
    } else {
        completionBlock(YES);
    }
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self popToViewController:_rootViewController animated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *controllers  = [NSMutableArray array];
    
    while (![self.topViewController isEqual:viewController]) {
        [controllers addObject:[self popViewControllerAnimated:animated]];
    }
    return controllers;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *topViewController = self.topViewController;
    [_controllersStack removeLastObject];
    [topViewController willMoveToParentViewController:nil];
    [self.topViewController willMoveToParentViewController:self];
    [self navigationWillShowViewController:self.topViewController animated:animated];
    
    void (^completionBlock)(BOOL finish) = ^(BOOL finish) {
        [topViewController.view removeFromSuperview];
        [topViewController removeFromParentViewController];
        [self.topViewController didMoveToParentViewController:self];
        [self navigationDidShowViewController:self.topViewController animated:animated];
    };
    
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^() {
            CGRect rect = topViewController.view.frame;
            rect.origin.x += rect.size.width;
            topViewController.view.frame = rect;
        } completion:completionBlock];
    } else {
        completionBlock(YES);
    }
    
    return topViewController;
}

#pragma mark - Actions

- (void)onSwipeHandler:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            initialTouchLocation = [recognizer locationInView:self.view];
            touchControllerIndex = [self findControllerIndexOnTouch:initialTouchLocation];
            touchControllerWidth = [[_controllersStack objectAtIndex:touchControllerIndex] view].frame.size.width;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat delta = [recognizer locationInView:self.view].x - initialTouchLocation.x;
            initialTouchLocation = [recognizer locationInView:self.view];
            
            if (touchControllerIndex == 0) break;
            
            if (delta < 0) {
                UIViewController *touchController = [_controllersStack objectAtIndex:touchControllerIndex];
                CGRect rect = touchController.view.frame;
                rect.origin.x += delta;
                rect.size.width -= delta;
                touchController.view.frame = rect;
            } else {
                for (NSUInteger i = touchControllerIndex; i < _controllersStack.count; ++i) {
                    UIViewController *controller = [_controllersStack objectAtIndex:i];
                    CGRect rect = controller.view.frame;
                    CGFloat newX = MIN(self.view.frame.size.width - kBorderGap * (_controllersStack.count - i), rect.origin.x + delta);
                    rect.origin.x = newX;
                    controller.view.frame = rect;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            UIViewController *touchController = [_controllersStack objectAtIndex:touchControllerIndex];
            if (touchController.view.frame.origin.x  > self.view.frame.size.width - touchControllerWidth + 20) {
                [self popToViewController:[_controllersStack objectAtIndex:touchControllerIndex - 1] animated:YES];
            }
            [UIView animateWithDuration:kAnimationDuration animations:^() {
                [self recalculateControllersFrame];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Internals

- (CGRect)initialControllerFrameForWidth:(CGFloat)width
{
    CGRect rect = self.topViewController.view.frame;
    rect.origin.x += rect.size.width;
    rect.size.width = width;
    
    return rect;
}

- (CGFloat)widthForControllerWithMinWidth:(CGFloat)min maxWidth:(CGFloat)maxWidth count:(NSInteger)count
{
    CGFloat minWidth = min;
    CGFloat controllerWidth = (maxWidth - minWidth)/(count - 1);
    
    if (controllerWidth > minWidth) {
        minWidth = controllerWidth;
    }
    
    return minWidth;
}

- (void)addShadowToController:(UIViewController *)controller
{
    controller.view.layer.masksToBounds = NO;
    controller.view.layer.shadowColor = [UIColor blackColor].CGColor;
    controller.view.layer.shadowOpacity = 0.8;
    controller.view.layer.shadowRadius = 4;
    controller.view.layer.shadowOffset = CGSizeMake(1, 9);
}

- (void)recalculateControllersFrame
{
    NSArray *controllersWidth = [self recalculatedControllersWidth];
    
    for (UIViewController *controller in _controllersStack) {
        NSInteger index = [_controllersStack indexOfObject:controller];
        CGRect rect = controller.view.frame;
        rect.size.width = [[controllersWidth objectAtIndex:index] floatValue];
        rect.origin.x = self.view.frame.size.width - rect.size.width;
        controller.view.frame = rect;
    }
}

- (NSArray *)recalculatedControllersWidth
{
    NSMutableArray *controllersWidth = [NSMutableArray array];
    
    CGFloat minWidth = _minTopControllerWidth;
    CGFloat maxWidth = self.view.frame.size.width;
    CGFloat offset = 0;
    
    for (int i = 0; i < _controllersStack.count - 1; ++i) {
        CGFloat width = [self widthForControllerWithMinWidth:minWidth maxWidth:maxWidth count:_controllersStack.count - i];
        [controllersWidth addObject:@(width + offset)];
        maxWidth -= width;
        offset += width;
        minWidth = maxWidth/2;
    }
    
    [controllersWidth addObject:@(self.view.frame.size.width)];
    
    return [controllersWidth reverseObjectEnumerator].allObjects;
}

- (NSUInteger)findControllerIndexOnTouch:(CGPoint)touch
{
    for (NSInteger i = _controllersStack.count - 1; i >= 0; --i) {
        UIViewController *controller = [_controllersStack objectAtIndex:i];
        if (controller.view.frame.origin.x < touch.x) {
            return i;
        }
    }
    
    return 0;
}

#pragma mark - Delegate Methods Wrapper

- (void)navigationWillShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([_delegate respondsToSelector:@selector(stackNavigationController:willShowViewController:animated:)]) {
        [_delegate stackNavigationController:self willShowViewController:viewController animated:animated];
    }
}

- (void)navigationDidShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([_delegate respondsToSelector:@selector(stackNavigationController:didShowViewController:animated:)]) {
        [_delegate stackNavigationController:self didShowViewController:viewController animated:animated];
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.topViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.topViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.topViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
