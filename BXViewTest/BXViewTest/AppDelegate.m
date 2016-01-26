//
//  AppDelegate.m
//  BXViewTest
//
//  Created by bx_1512 on 16/1/26.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate () {
    UIWindow        *_secondWindow;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupScreenConnectionNotificationHandlers];
    [self checkForExistingScreenAndInitializeIfPresent];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ----external display
- (void)checkForExistingScreenAndInitializeIfPresent {
    if ([[UIScreen screens] count] > 1) {
        // 主 screen 是 objectAtIndex:0
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        CGRect screenBounds = secondScreen.bounds;
        
        _secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        _secondWindow.screen = secondScreen;
        
        // 给 window 加一个白色背景
        UIView *whiteField = [[UIView alloc] initWithFrame:screenBounds];
        whiteField.backgroundColor = [UIColor whiteColor];
        
        [_secondWindow addSubview:whiteField];
        // 居中放置一个 Label
        NSString *noContentString = [NSString stringWithFormat:@"<no content>"];
        CGSize stringSize = [noContentString sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}];
        
        CGRect labelSize = CGRectMake((screenBounds.size.width - stringSize.width) / 2.0,
                                             (screenBounds.size.height - stringSize.height) / 2.0,
                                             stringSize.width, stringSize.height);
        
        UILabel *noContentLabel = [[UILabel alloc] initWithFrame:labelSize];
        noContentLabel.text = noContentString;
        noContentLabel.font = [UIFont systemFontOfSize:18];
        [whiteField addSubview:noContentLabel];
        
        _secondWindow.hidden = NO;
    }
}

- (void)setupScreenConnectionNotificationHandlers {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(handleScreenConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
}

- (void)handleScreenConnectNotification:(NSNotification*)aNotification {
    UIScreen *newScreen = [aNotification object];
    CGRect screenBounds = newScreen.bounds;
    
    if (!_secondWindow) {
        _secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        _secondWindow.screen = newScreen;
        ViewController *vc = [[ViewController alloc]init];
        [vc displaySelectionInSecondaryWindow:_secondWindow];
    }
}

- (void)handleScreenDisconnectNotification:(NSNotification*)aNotification {
    if (_secondWindow) {
        // 隐藏 window
        _secondWindow.hidden = YES;
        _secondWindow = nil;
        
        ViewController *vc = [[ViewController alloc]init];
        [vc displaySelectionOnMainScreen];
    }
    
}

@end
