//
//  CustomOperation.m
//  SpecialCamera
//
//  Created by njw on 2019/2/25.
//  Copyright © 2019 njw. All rights reserved.
//

#import "CustomOperation.h"

@interface CustomOperation ()

@property (nonatomic,copy) NSString *operName;
@property BOOL over;
@end

@implementation CustomOperation

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.operName = name;
    }
    return self;
}

- (void)main {
//    for (int i=0; i<3; i++) {
//        NSLog(@"%@ %d", self.operName, i);
//        [NSThread sleepForTimeInterval:1];
//    }
    
    //在添加依赖的情况下 上面和下面会有区别
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        if (self.cancelled) {
            return ;
        }
        NSLog(@"%@", self.operName);
        self.over = YES;
    });
    
    while (!self.over && !self.cancelled) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

@end
