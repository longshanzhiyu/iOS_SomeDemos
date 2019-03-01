//
//  PushViewController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/26.
//  Copyright © 2019 njw. All rights reserved.
//

#import "PushViewController.h"
#import "BackgroundTask.h"

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // push的调试工具推荐使用 NWPusher github上有
//    注意：NMPusher 需要导入推送证书的p12格式
    // iOS10及以后的Push 参考 https://www.jianshu.com/p/4fa1c789df53
    
    
    // 本地通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
}

- (void)appEnterBackground:(NSNotification *)noty {
//    启动后台任务
    [[BackgroundTask sharedInstance] beginBackgroundTask];
}
- (void)appEnterForeground:(NSNotification *)noty {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
