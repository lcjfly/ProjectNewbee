/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import "RCTRootView.h"

#import "ReactNativeAutoUpdater.h"

#define JS_CODE_METADATA_URL @"http://192.168.1.201:3000/update.json"

@interface AppDelegate() <ReactNativeAutoUpdaterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  /*
  // OPTION 1 local jsbundle
  NSURL* jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"ProjectNewbee"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
   */
  
  // OPTION 2 remote dynamic update
  // defaultJSCodeLocation is needed at least for the first startup
  // http://localhost:8081/index.ios.bundle?platform=ios&dev=true
  NSURL* defaultJSCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  
  ReactNativeAutoUpdater* updater = [ReactNativeAutoUpdater sharedInstance];
  [updater setDelegate:self];
  
  // We set the location of the metadata file that has information about the JS Code that is shipped with the app.
  // This metadata is used to compare the shipped code against the updates.
  
  NSURL* defaultMetadataFileLocation = [[NSBundle mainBundle] URLForResource:@"metadata" withExtension:@"json"];
  [updater initializeWithUpdateMetadataUrl:[NSURL URLWithString:JS_CODE_METADATA_URL]
                     defaultJSCodeLocation:defaultJSCodeLocation
               defaultMetadataFileLocation:defaultMetadataFileLocation ];
  [updater setHostnameForRelativeDownloadURLs:@"http://192.168.1.201:4000"];
  [updater checkUpdate];
  
  NSURL* latestJSCodeLocation = [updater latestJSCodeLocation];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  self.window.rootViewController = rootViewController;
  RCTBridge* bridge = [[RCTBridge alloc] initWithBundleURL:latestJSCodeLocation moduleProvider:nil launchOptions:nil];
  RCTRootView* rootView = [[RCTRootView alloc] initWithBridge:bridge moduleName:@"ProjectNewbee" initialProperties:nil];
  self.window.rootViewController.view = rootView;
  [self.window makeKeyAndVisible];
  return YES;
  
}

@end
