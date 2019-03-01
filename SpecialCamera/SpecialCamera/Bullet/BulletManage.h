//
//  BulletManage.h
//  SpecialCamera
//
//  Created by njw on 2019/2/18.
//  Copyright © 2019 njw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BulletView;
@interface BulletManage : NSObject

@property (nonatomic, copy) void(^generateViewBlock)(BulletView *view);

//开始弹幕
- (void)start;

//弹幕停止
- (void)stop;
@end

NS_ASSUME_NONNULL_END
