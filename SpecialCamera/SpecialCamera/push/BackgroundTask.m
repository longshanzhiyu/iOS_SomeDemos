//
//  BackgroundTask.m
//  SpecialCamera
//
//  Created by njw on 2019/3/1.
//  Copyright © 2019 njw. All rights reserved.
//

#import "BackgroundTask.h"
#import <UIKit/UIKit.h>

@implementation BackgroundTask

+ (instancetype)sharedInstance {
    static BackgroundTask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BackgroundTask new];
    });
    return instance;
}

// 启动后台任务
- (void)beginBackgroundTask {
    UIApplication *app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:taskId];
        
        taskId = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            int remainingTime = app.backgroundTimeRemaining;
            if (remainingTime <= 5) {
                break;
            }
            
            NSLog(@"remaining background time: %d", remainingTime);
            
            [NSThread sleepForTimeInterval:1.0];
        }
        [app endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    });
    
}

@end
