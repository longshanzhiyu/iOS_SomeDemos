//
//  BulletViewController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/19.
//  Copyright © 2019 njw. All rights reserved.
//

#import "BulletViewController.h"
#import "BulletManage.h"
#import "BulletView.h"

@interface BulletViewController ()
@property (nonatomic, strong) BulletManage *manager;
@end

@implementation BulletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[BulletManage alloc] init];
    
    __weak typeof(self) myself = self;
    self.manager.generateViewBlock = ^(BulletView *view){
        [myself addBulletView:view];
    };
}
- (IBAction)clicked:(id)sender {
    [self.manager start];
}
- (IBAction)stop:(id)sender {
    [self.manager stop];
}

- (void)addBulletView:(BulletView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300+view.trajectory*50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}

@end
