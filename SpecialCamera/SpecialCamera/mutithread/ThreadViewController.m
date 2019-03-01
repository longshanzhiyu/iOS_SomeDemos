//
//  ThreadViewController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/25.
//  Copyright © 2019 njw. All rights reserved.
//

#import "ThreadViewController.h"
#import "CustomOperation.h"

@interface ThreadViewController ()
@property (nonatomic, strong) NSOperationQueue *operQueue;
@end

@implementation ThreadViewController

- (NSOperationQueue *)operQueue {
    if (!_operQueue) {
        _operQueue = [[NSOperationQueue alloc] init];
    }
    return _operQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testGroup1];
//    [self testGroup2];
//    [self testGroup3];
    [self testOperation];
}

- (void)testOperation {
    
    [self.operQueue setMaxConcurrentOperationCount:4];
    
    CustomOperation *customOperA = [[CustomOperation alloc] initWithName:@"OperA"];
    CustomOperation *customOperB = [[CustomOperation alloc] initWithName:@"OperB"];
    CustomOperation *customOperC = [[CustomOperation alloc] initWithName:@"OperC"];
    CustomOperation *customOperD = [[CustomOperation alloc] initWithName:@"OperD"];
    
    //注意：1.添加依赖后类似串行 2.依赖要放在addOperation:前才能起作用
    [customOperD addDependency:customOperA];
    [customOperA addDependency:customOperC];
    [customOperC addDependency:customOperB];
    
    
    [self.operQueue addOperation:customOperA];
    [self.operQueue addOperation:customOperB];
    [self.operQueue addOperation:customOperC];
    [self.operQueue addOperation:customOperD];

    NSLog(@"end");
}

- (void)testGroup1 {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"执行gcd");
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 3");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"All tasks over");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程刷新UI");
        });
    });
}

// 注意：dispatch_group_async和dispatch_group_enter的区别
- (void)testGroup2 {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        [self sendRequest1:^{
            NSLog(@"request1 done");
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [self sendRequest2:^{
            NSLog(@"request2 done");
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"All tasks over");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程刷新UI");
        });
    });
}

- (void)testGroup3 {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self sendRequest1:^{
        NSLog(@"request1 done");
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self sendRequest2:^{
        NSLog(@"request2 done");
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"All tasks over");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程刷新UI");
        });
    });
}

//模拟网络请求
- (void)sendRequest1:(void(^)(void))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}

- (void)sendRequest2:(void(^)(void))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}

- (IBAction)excuteOnce:(id)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"only excute once");
    });
}
@end
