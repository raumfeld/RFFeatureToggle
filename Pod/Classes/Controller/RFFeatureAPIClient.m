//
//  RFFeatureAPIClient.m
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureAPIClient.h"
#import "RFFeatureToggleDefaults.h"

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
        NSString *certificateName = [RFFeatureToggleDefaults sharedDefaults].certificateName;
        
        if (certificateName) {
            AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            policy.allowInvalidCertificates = YES;
            policy.validatesDomainName = NO;
            NSString *certificatePath = [[NSBundle mainBundle] pathForResource:certificateName ofType:@"cer"];
            if (certificatePath) {
                NSData *certificate = [NSData dataWithContentsOfFile:certificatePath];
                policy.pinnedCertificates = @[certificate];
            }
            self.securityPolicy = policy;
        }
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self attachHeaderValues];
    }
    return self;
}

- (void)attachHeaderValues
{
    NSDictionary *dict = [RFFeatureToggleDefaults sharedDefaults].requestHeadersDictionary;
    for (NSString *key in dict.allKeys)
    {
        [self.requestSerializer setValue:[dict valueForKey:key] forHTTPHeaderField:key];
    }
}

@end
