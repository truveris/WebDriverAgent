/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBCustomCommands.h"

#import <XCTest/XCUIDevice.h>

#import "FBXCTSession.h"
#import "FBResponsePayload.h"
#import "FBRoute.h"
#import "FBRouteRequest.h"
#include <notify.h>

@implementation FBCustomCommands

+ (NSArray *)routes
{
  return
  @[
    [[FBRoute POST:@"/deactivateApp"] respond: ^ id<FBResponsePayload> (FBRouteRequest *request) {
      [[XCUIDevice sharedDevice] pressButton:XCUIDeviceButtonHome];
      return FBResponseDictionaryWithOK();
    }],
    [[FBRoute POST:@"/hide_keyboard"] respond: ^ id<FBResponsePayload> (FBRouteRequest *request) {
        FBXCTSession *session = (FBXCTSession *)request.session;
        [[session.application.windows elementAtIndex:0] tap];
        return FBResponseDictionaryWithOK();
    }],
    [[FBRoute POST:@"/touch_id_fail"] respond: ^ id<FBResponsePayload> (FBRouteRequest *request) {
        if (notify_post("com.apple.BiometricKit_Sim.fingerTouch.nomatch")) {
            return FBResponseDictionaryWithOK();
        } else {
            return FBResponseDictionaryWithStatus(FBCommandStatusUnsupported, nil);
        }
    }],
    [[FBRoute POST:@"/touch_id_success"] respond: ^ id<FBResponsePayload> (FBRouteRequest *request) {
        if (notify_post("com.apple.BiometricKit_Sim.fingerTouch.match")) {
            return FBResponseDictionaryWithOK();
        } else {
            return FBResponseDictionaryWithStatus(FBCommandStatusUnsupported, nil);
        }
    }],
    [[FBRoute POST:@"/timeouts/implicit_wait"] respond: ^ id<FBResponsePayload> (FBRouteRequest *request) {
      // This method is intentionally not supported.
      return FBResponseDictionaryWithOK();
    }],
  ];
}

@end
