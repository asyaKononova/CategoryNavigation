//
//  AppDelegate.m
//  CategoryNavigation
//
//  Created by Anastasia Kononova on 9/13/15.
//  Copyright (c) 2015 Asya Kononova. All rights reserved.
//

#import "AppDelegate.h"
#import "CategoryViewController.h"
#import "StackNavigationController.h"
#import "InstrumentCategory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    StackNavigationController *nc = [[StackNavigationController alloc] initWithRootViewController:[[CategoryViewController alloc] initWithCaregories:[self instrumentTree]]];
    nc.minTopControllerWidth = 170;
    self.window.rootViewController = nc;//[[UINavigationController alloc] initWithRootViewController:nc];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSArray *)instrumentTree
{
    return @[[InstrumentCategory categoryWithName:@"Currencies"
                                    subcategories:
              [self subcategoryWithName:@"AAPL"
                          subcategories:
               [self subcategoryWithName:@"ADDYY"
                           subcategories:
                [self subcategoryWithName:@"AUD/CAD"
                            subcategories:nil]]]],
             [InstrumentCategory categoryWithName:@"Indices"
                                    subcategories:
              [self subcategoryWithName:@"IBM"
                          subcategories:
               [self subcategoryWithName:@"NVDA"
                           subcategories:
                [self subcategoryWithName:@"FSCO"
                            subcategories:
                 [self subcategoryWithName:@"GSCO"
                             subcategories:
                  [self subcategoryWithName:@"CPPP"
                              subcategories:nil]]]]]],
             [InstrumentCategory categoryWithName:@"Energy"
                                    subcategories:
              [self subcategoryWithName:@"MSFT"
                          subcategories:
               [self subcategoryWithName:@"MMM"
                           subcategories:
                [self subcategoryWithName:@"VOD"
                            subcategories:nil]]]],
             [InstrumentCategory categoryWithName:@"Commodities"
                                    subcategories:
              [self subcategoryWithName:@"PFE"
                          subcategories:
               [self subcategoryWithName:@"PLN/CZK"
                           subcategories:
                [self subcategoryWithName:@"CPB"
                            subcategories:
                 [self subcategoryWithName:@"VDCB"
                             subcategories:
                  [self subcategoryWithName:@"CBOD"
                              subcategories:nil]]]]]],
             [InstrumentCategory categoryWithName:@"Metals"
                                    subcategories:
              [self subcategoryWithName:@"USD/JPY"
                          subcategories:
               [self subcategoryWithName:@"USD/CAD"
                           subcategories:
                [self subcategoryWithName:@"USD/HUF"
                            subcategories:
                 [self subcategoryWithName:@"USD/HUF"
                             subcategories:
                  [self subcategoryWithName:@"USD/HUF"
                              subcategories:nil]]]]]],
             [InstrumentCategory categoryWithName:@"Shares"
                                    subcategories:
              [self subcategoryWithName:@"ZAR/JPY"
                          subcategories:
               [self subcategoryWithName:@"AUD/NZD"
                           subcategories:
                [self subcategoryWithName:@"CZK/HUD"
                            subcategories:
                 [self subcategoryWithName:@"USD/HUF"
                             subcategories:
                  [self subcategoryWithName:@"USD/HUF"
                              subcategories:nil]]]]]]];
}

- (NSArray *)subcategoryWithName:(NSString *)name subcategories:(NSArray *)subcategories
{
    NSMutableArray *subcategory = [NSMutableArray array];
    for (int i = 0; i < 20; ++i) {
        NSString *subcategoryName = [NSString stringWithFormat:@"%@ %d", name, i + 1];
        [subcategory addObject:[InstrumentCategory categoryWithName:subcategoryName subcategories:subcategory]];
    }
    return subcategory;
}

@end
