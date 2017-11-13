//
//  RFFeatureAPIClient.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureAPIClient.h"
#import "RFFeatureToggleDefaults.h"
#import "RFFeatureToggleLogging.h"

@interface RFFeatureAPIClient ()

@end

@implementation RFFeatureAPIClient

+ (instancetype)sharedClient
{
    static RFFeatureAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[RFFeatureAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });

    return sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSDictionary *dict = [RFFeatureToggleDefaults sharedDefaults].requestHeadersDictionary;
        [self attachHeaderValues:dict];
    }
    return self;
}

- (void)attachHeaderValues:(NSDictionary *)dict
{
    for (NSString *key in dict.allKeys)
    {
        [self.requestSerializer setValue:[dict valueForKey:key] forHTTPHeaderField:key];
    }
}

+ (void)pinCertificateWithName:(NSString *)certificateName
{
    AFSecurityPolicy *policy = nil;
    
    NSString *certificatePath = [[NSBundle mainBundle] pathForResource:certificateName ofType:@"cer"];
    if (certificateName && certificatePath)
    {
        NSData *certificate = [NSData dataWithContentsOfFile:certificatePath];
        
        policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        if ([policy.pinnedCertificates isKindOfClass:[NSArray class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
            policy.pinnedCertificates = @[certificate];

#pragma clang diagnostic pop
        } else {
            policy.pinnedCertificates = [NSSet setWithObject:certificate];
        }
    }
    else if (certificateName && !certificatePath)
    {
        RFLogError(@"Error: Certificate with name %@ not found.",certificateName);
    }
    
    [RFFeatureAPIClient sharedClient].securityPolicy = policy ?: [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
}

@end
