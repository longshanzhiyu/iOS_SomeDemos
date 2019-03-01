//
//  BulletManage.m
//  SpecialCamera
//
//  Created by njw on 2019/2/18.
//  Copyright © 2019 njw. All rights reserved.
//

#import "BulletManage.h"
#import "BulletView.h"

@interface BulletManage ()
//弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *dataSource;
//弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic, strong) NSMutableArray *bulletviews;

@property BOOL bStopAnimation;
@end

@implementation BulletManage

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bStopAnimation = YES;
    }
    return self;
}

- (void)start {
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
}

- (void)stop {
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    [self.bulletviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletviews removeAllObjects];
}

//初始化弹道，随记分配弹幕轨迹
- (void)initBulletComment {
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0), @(1), @(2)]];
    for (int i=0; i < 3; i++) {
        if (self.bulletComments.count > 0) {
            //通过随机数获取到弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory {
    if (self.bStopAnimation) {
        return;
    }
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletviews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (self.bStopAnimation) {
            return ;
        }
        switch (status) {
            case Start: {
                //弹幕开始进入屏幕， 将view加入弹幕管理的变量中bulletviews
                [weakSelf.bulletviews addObject:weakView];
            }
                break;
                
            case Enter: {
                // 弹幕开始进入屏幕， 判断时候还有其他内容，如果有则在该弹幕轨迹中创建一个
                NSString *comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                }
            }
                break;
                
            case End: {
                // 弹幕飞出屏幕后从bulletViews中删除，释放资源
                if ([weakSelf.bulletviews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletviews removeObject:weakView];
                }
                
                if (weakSelf.bulletviews.count == 0) {
                    //说明屏幕上已经没有弹幕了，开始循环滚动
                    self.bStopAnimation = YES;
                    [weakSelf start];
                }
            }
                break;
                
            default:
                break;
        }
       //移出屏幕后移除弹幕并释放资源
//        [weakView stopAnimation];
//        [weakSelf.bulletviews removeObject:weakView];
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextComment {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
//        [self.bulletComments removeObject:comment];
    }
    return comment;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1～～～～～～", @"弹幕2～～～", @"弹幕3～～～～～～~~~", @"弹幕4～～", @"弹幕5～～～～～～~~~", @"弹幕6～~~~", @"弹幕7～～～~~~", @"弹幕8～～～～～～~~", @"弹幕9～～～～～～~~~~~~"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletviews {
    if (!_bulletviews) {
        _bulletviews = [NSMutableArray array];
    }
    return _bulletviews;
}

@end
