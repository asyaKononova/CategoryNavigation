//
//  InstrumentCategory.m
//  CategoryNavigation
//
//  Created by Anastasia Kononova on 9/13/15.
//  Copyright (c) 2015 Asya Kononova. All rights reserved.
//

#import "InstrumentCategory.h"

@implementation InstrumentCategory {
    NSMutableArray *_categories;
}

+ (instancetype)categoryWithName:(NSString *)name subcategories:(NSArray *)subcategories
{
    InstrumentCategory *category = [[InstrumentCategory alloc] initWithName:name];
    for (InstrumentCategory *obj in subcategories) {
        [category addSubcategory:obj];
    }
    
    return category;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name.copy;
        _categories = [NSMutableArray array];
    }
    return self;
}

- (void)addSubcategory:(InstrumentCategory *)subcategory
{
    [_categories addObject:subcategory];
}

- (void)removeSubcategory:(InstrumentCategory *)subcategory
{
    [_categories removeObject:subcategory];
}

- (NSArray *)subcategories
{
    return [_categories copy];
}

@end
