//
//  ImageToBytesController.h
//  SpecialCamera
//
//  Created by njw on 2019/2/18.
//  Copyright © 2019 njw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageToBytesController : UIViewController
- (unsigned char *)convertUIImagetoData:(UIImage *)image;
- (UIImage *)convertDatatoUIImage:(unsigned char*)imageData image:(UIImage *)imageSource;
- (unsigned char*)imageReColorWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
