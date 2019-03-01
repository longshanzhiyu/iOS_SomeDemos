//
//  BackgroundTask.h
//  SpecialCamera
//
//  Created by njw on 2019/3/1.
//  Copyright © 2019 njw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundTask : NSObject

+ (instancetype)sharedInstance;

- (void)beginBackgroundTask;
@end

NS_ASSUME_NONNULL_END
