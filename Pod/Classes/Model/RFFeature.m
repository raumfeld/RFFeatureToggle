//
//  RFFeature.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeature.h"

@implementation RFFeature

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self)
    {
        self.name = [coder decodeObjectForKey:@"name"];
        self.enabled = [coder decodeBoolForKey:@"enabled"];
        self.features = [coder decodeObjectForKey:@"features"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeBool:self.enabled forKey:@"enabled"];
    [coder encodeObject:self.features forKey:@"features"];
}

#pragma mark - Overrides

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[RFFeature class]])
    {
        RFFeature *feature = (RFFeature *)object;

        if (![self.name isEqualToString:feature.name])
        {
            return NO;
        }
        if (self.enabled != feature.enabled)
        {
            return NO;
        }
        if (self.features.count > 0)
        {
            if (![self.features isEqualToArray:feature.features])
            {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    return (self.name).hash ^ (self.isEnabled ? 0 : 1) ^ (self.features).hash;
}

#pragma mark - Description

- (NSString *)description
{
    NSString *retVal = [NSString stringWithFormat:@"%@: %@", self.name, self.isEnabled ? @"enabled" : @"disabled"];
    return retVal;
}

- (NSString *)recursiveDescription
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"\n"];
    [self addDescriptionToString:description indentLevel:0];
    return description;
}

- (void)addDescriptionToString:(NSMutableString *)string indentLevel:(NSInteger)indentLevel
{
    [string appendFormat:@"%@", [self description]];

    if (self.features.count > 0)
    {
        NSString *padding = [@"" stringByPaddingToLength:indentLevel+1 withString:@"\t" startingAtIndex:0];
        [string appendString:padding];

        for (RFFeature *feature in self.features)
        {
            [string appendFormat:@"\n%@|_", padding];
            [feature addDescriptionToString:string indentLevel:indentLevel+1];
        }
    }
}

@end
