//
//  RFFeatureAPIClient.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**
   A block that defines if API call was successful. Returns YES on successful call, NO & error otherwise.
 */
typedef void (^RFAPIResultBlock)(BOOL succeeded, NSError *error);

/**
   `RFFeatureAPIClient` is a subclass of `AFHTTPSessionManager` that is used to initiate all API calls.
 */
@interface RFFeatureAPIClient : AFHTTPSessionManager

/**
   Initializes and returns a singleton instance of `RFFeatureAPIClient` with empty base URL (so it can be switched dynamically). The certificate & header fields are based on values in `RFFeatureToggleDefaults`.

   @return    The shared `RFFeatureToggleDefaults` instance.
 */
+ (instancetype)sharedClient;

@end
