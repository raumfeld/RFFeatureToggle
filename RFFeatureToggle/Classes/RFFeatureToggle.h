//
//  RFFeatureToggle.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 21/01/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggleDefaults.h"
#import "RFFeature.h"

NS_ASSUME_NONNULL_BEGIN

/**
   Defines "levels" of logging that will be used as values in a bitmask that filters log messages.
   @since Available in v1.0.2 and later.
 */
typedef NS_ENUM (NSUInteger, RFFeatureToggleLoggingMask)
{
	/** Log all errors */
	RFFeatureToggleLoggingMaskError = 1 << 0,

    /** Log warnings, and all errors */
    RFFeatureToggleLoggingMaskWarn = 1 << 1,

    /** Log informative messagess, warnings and all errors */
    RFFeatureToggleLoggingMaskInfo = 1 << 2,

    /** Log debugging messages, informative messages, warnings and all errors */
    RFFeatureToggleLoggingMaskDebug = 1 << 3,

    /** Log verbose diagnostic information, debugging messages, informative messages, messages, warnings and all errors */
    RFFeatureToggleLoggingMaskVerbose = 1 << 4,
};

/**
   Defines a mask for logging that will be used by to filter log messages.
   @since Available in v1.0.2 and later.
 */
typedef NS_ENUM (NSUInteger, RFFeatureToggleLoggingLevel)
{
	/** Don't log anything */
	RFFeatureToggleLoggingLevelOff = 0,

	/** Log all errors and fatal messages */
	RFFeatureToggleLoggingLevelError = (RFFeatureToggleLoggingMaskError),

	/** Log warnings, errors and fatal messages */
	RFFeatureToggleLoggingLevelWarn = (RFFeatureToggleLoggingLevelError | RFFeatureToggleLoggingMaskWarn),

	/** Log informative, warning and error messages */
	RFFeatureToggleLoggingLevelInfo = (RFFeatureToggleLoggingLevelWarn | RFFeatureToggleLoggingMaskInfo),

	/** Log all debugging, informative, warning and error messages */
	RFFeatureToggleLoggingLevelDebug = (RFFeatureToggleLoggingLevelInfo | RFFeatureToggleLoggingMaskDebug),

	/** Log verbose diagnostic, debugging, informative, warning and error messages */
	RFFeatureToggleLoggingLevelVerbose = (RFFeatureToggleLoggingLevelDebug | RFFeatureToggleLoggingMaskVerbose),

	/** Log everything */
	RFFeatureToggleLoggingLevelAll = NSUIntegerMax
};

@interface RFFeatureToggle : NSObject

@property (class, nonatomic, copy, nonnull) NSUserDefaults *(^userDefaults)();

/**
   Returns an enabled value for feature with name. For features that have subfeatures, accepts a dot separated synthax like "feature.subfeature.subsubfeature".

   @param featureName A name of the feature as defined on server or a dot separated string of subfeature.
   @returns           YES if feature exists in current cache and is enabled, NO otherwise.
 */
+ (BOOL)isEnabled:(NSString *)featureName;

/**
   Initiates an API call to refresh features and persists the newly fetched features. Can be called on `applicationDidBecomeActive:` or when needed.
   @note Is automatically called based on `refreshTimeInterval` value specified in `RFFeatureToggleDefaults` if the app has been continuously running in foreground.
 */
+ (void)refreshFeatures;

/**
   An array of `RFFeature` instances loaded from `NSUserDefaults`.

   @return    An array of `RFFeature` instances.
 */
+ (NSArray *)allFeatures;

/**
   Returns the logging mask set for RFFeatureToggle in the current application.
   @return Current RFFeatureToggleLoggingLevel

   @since Available in v1.0.2 and later.
 */
+ (RFFeatureToggleLoggingLevel) loggingLevel;

/**
   Sets the logging mask set for RFFeatureToggle in the current application.
   @param level Any value from `RFFeatureToggleLoggingLevel`
   @since Available in v1.0.2 and later.
 */
+ (void) setLoggingLevel:(RFFeatureToggleLoggingLevel)level;

@end

NS_ASSUME_NONNULL_END
