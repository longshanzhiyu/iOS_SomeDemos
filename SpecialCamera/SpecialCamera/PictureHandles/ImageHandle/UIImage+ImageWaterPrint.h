//
//  UIImage+ImageWaterPrint.h
//  SpecialCamera
//
//  Created by njw on 2019/2/21.
//  Copyright © 2019 njw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImageWaterPrint)
- (UIImage *)imageWater:(UIImage *)imageLogo waterString:(NSString *)waterString;
@end

NS_ASSUME_NONNULL_END
