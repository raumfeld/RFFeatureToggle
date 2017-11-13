//
//  RFFeatureAPIClient.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 13/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**
   A block that defines if API call was successful. Returns YES on successful call, NO & error otherwise.
 */
typedef void (^RFAPIResultBlock)(BOOL succeeded, NSError *_Nullable error);

/**
   `RFFeatureAPIClient` is a subclass of `AFHTTPSessionManager` that is used to initiate all API calls.
 */
@interface RFFeatureAPIClient : AFHTTPSessionManager

/**
   Initializes and returns a singleton instance of `RFFeatureAPIClient` with empty base URL (so it can be switched dynamically).

   @return    The shared `RFFeatureToggleDefaults` instance.
 */
+ (instancetype)sharedClient;

/**
   Attaches values for HTTP header keys.
   @param dict A dictionary of values and keys
 */
- (void)attachHeaderValues:(nullable NSDictionary *)dict;

/**
   Pins a certificate
   @param certificateName A name of the certificate file. The certificate file needs to be included in the bundle.
   The certificate needs to have .cer extension, and needs to be in DER format. To convert a .crt file, use the following command line: openssl x509 -in domain.crt -out domain.cer -outform der
 */
+ (void)pinCertificateWithName:(nullable NSString *)certificateName;

@end

NS_ASSUME_NONNULL_END
