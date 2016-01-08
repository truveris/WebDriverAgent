/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBScreenshotCommands.h"


#import "XCAXClient_iOS.h"

@implementation FBScreenshotCommands

#pragma mark - <FBCommandHandler>

+ (NSArray *)routes
{
  return
  @[
    [[FBRoute GET:@"/screenshot"].withoutSession respond:^ id<FBResponsePayload> (FBRouteRequest *request) {
      NSString *screenshot = [[[XCAXClient_iOS sharedClient] screenshotData] base64EncodedStringWithOptions:0];
      return [FBResponsePayload okWith:screenshot];
    }]
  ];
}

@end
