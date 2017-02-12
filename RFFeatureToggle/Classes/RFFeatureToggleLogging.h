//
//  RFFeatureToggleLogging.h
//  RFFeatureToggle
//
//  Created by Dunja Lalic on 23/02/16.
//  Copyright (c) 2016 Lautsprecher Teufel GmbH. All rights reserved.
//

#import "RFFeatureToggle.h"

#if RF_LOGGING_DISABLED

#define RFLogError(frmt, ...) ((void)0)
#define RFLogWarn(frmt, ...) ((void)0)
#define RFLogInfo(frmt, ...) ((void)0)
#define RFLogDebug(frmt, ...) ((void)0)
#define RFLogVerbose(frmt, ...) ((void)0)

#else

#ifndef RF_LOGGING_CONTEXT
#define RF_LOGGING_CONTEXT 0
#endif

#if __has_include("CocoaLumberjack.h") || __has_include("CocoaLumberjack/CocoaLumberjack.h")
#define RF_LOG_LEVEL_DEF (DDLogLevel)[RFFeatureToggle loggingLevel]
#define CAST (DDLogFlag)
#import <CocoaLumberjack/CocoaLumberjack.h>
#else
#define RF_LOG_LEVEL_DEF [RFFeatureToggle loggingLevel]
#define LOG_ASYNC_ENABLED YES
#define CAST
#define LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) \
do                                                        \
{                                                         \
if ((lvl & flg) == flg)                               \
{                                                     \
NSLog(frmt, ##__VA_ARGS__);                       \
}                                                     \
} while (0)
#endif

#define RFLogError(frmt, ...) LOG_MAYBE(NO, RF_LOG_LEVEL_DEF, CAST RFFeatureToggleLoggingMaskError, RF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define RFLogWarn(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, RF_LOG_LEVEL_DEF, CAST RFFeatureToggleLoggingMaskWarn, RF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define RFLogInfo(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, RF_LOG_LEVEL_DEF, CAST RFFeatureToggleLoggingMaskInfo, RF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define RFLogDebug(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, RF_LOG_LEVEL_DEF, CAST RFFeatureToggleLoggingMaskDebug, RF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define RFLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, RF_LOG_LEVEL_DEF, CAST RFFeatureToggleLoggingMaskVerbose, RF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#endif
