//
//  InstrumentCategory.h
//  CategoryNavigation
//
//  Created by Anastasia Kononova on 9/13/15.
//  Copyright (c) 2015 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstrumentCategory : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSArray *subcategories;

+ (instancetype)categoryWithName:(NSString *)name subcategories:(NSArray *)subcategories;
- (instancetype)initWithName:(NSString *)name;

- (void)addSubcategory:(InstrumentCategory *)subcategory;
- (void)removeSubcategory:(InstrumentCategory *)subcategory;

@end
