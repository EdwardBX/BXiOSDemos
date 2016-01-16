//
//  ViewController.h
//  BXURLSession
//
//  Created by bx_1512 on 16/1/13.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CompletionHandlerType)();

@interface ViewController : UIViewController <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

//@property NSURLSession *backgroundSession;
@property NSURLSession *defaultSession;
//@property NSURLSession *ephemeralSession;
@property NSMutableDictionary *completionHandlerDictionary;

- (void)addCompletionHandler: (CompletionHandlerType)handler forSession: (NSString *)identifier;
- (void)callCompletionHandlerForSession: (NSString *)identifier;

@end

