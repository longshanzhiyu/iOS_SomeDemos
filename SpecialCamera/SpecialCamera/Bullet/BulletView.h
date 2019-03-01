//
//  BulletView.h
//  SpecialCamera
//
//  Created by njw on 2019/2/18.
//  Copyright © 2019 njw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MoveStatus) {
    Start,
    Enter,
    End
};

@interface BulletView : UIView
@property (nonatomic, assign) int trajectory; //弹道
@property (nonatomic, copy) void(^moveStatusBlock)(MoveStatus status); //    弹幕状态回调

//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;

//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
