/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBDebugLogDelegateDecorator.h"

void XCSetDebugLogger(id <XCDebugLogDelegate>);
id<XCDebugLogDelegate> XCDebugLogger();


@interface FBDebugLogDelegateDecorator ()
@property (nonatomic, strong) id<XCDebugLogDelegate> debugLogger;
@end

@implementation FBDebugLogDelegateDecorator

+ (void)decorateXCTestLogger
{
  FBDebugLogDelegateDecorator *decorator = [FBDebugLogDelegateDecorator new];
  id<XCDebugLogDelegate> debugLogger = XCDebugLogger();
  if ([debugLogger isKindOfClass:FBDebugLogDelegateDecorator.class]) {
    // Already decorated
    return;
  }
  decorator.debugLogger = debugLogger;
  XCSetDebugLogger(decorator);
}

- (void)logDebugMessage:(NSString *)logEntry
{
  NSString *debugLogEntry = logEntry;
  if ([logEntry rangeOfString:@" XCTStubApps["].location != NSNotFound) {
    // Ignoring "13:37:07.638 XCTStubApps[56374:10997466] " from log entry
    NSUInteger ignoreCharCount = [logEntry rangeOfString:@"]"].location + 2;
    debugLogEntry = [logEntry substringWithRange:NSMakeRange(ignoreCharCount, logEntry.length - ignoreCharCount)];
  }
  NSLog(@"%@", debugLogEntry);
  [self.debugLogger logDebugMessage:logEntry];
}

@end
