//
//  RFFeature+Mapping.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeature+Mapping.h"

@implementation RFFeature (Mapping)

+ (instancetype)featureWithName:(NSString *)name enabled:(BOOL)enabled
{
    RFFeature *object = [[RFFeature alloc] init];
    object.name = name;
    object.enabled = enabled;
    return object;
}

+ (NSArray *)objectsFromJSON:(id)object
{
    return [object isKindOfClass:[NSDictionary class]] ? [self parseFromDictionary:object] : nil;
}

+ (NSArray *)parseFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:dictionary.count];

    for (NSString *name in dictionary.allKeys)
    {
        NSDictionary *dict = dictionary[name];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            if (dict[@"enabled"])
            {
                RFFeature *feature = [RFFeature featureWithName:name enabled:[dict[@"enabled"] boolValue]];
                [objects addObject:feature];
            }
            else
            {
                RFFeature *feature = [[RFFeature alloc] init];
                feature.name = name;
                feature.features = [self parseFromDictionary:dict];
                [objects addObject:feature];
            }
        }
    }
    return [NSArray arrayWithArray:objects];
}

@end
