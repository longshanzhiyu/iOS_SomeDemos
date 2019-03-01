//
//  UIImage+ImageRotate.m
//  SpecialCamera
//
//  Created by njw on 2019/2/21.
//  Copyright © 2019 njw. All rights reserved.
//

#import "UIImage+ImageRotate.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

// 1 image -> context 2 context 3 context -> UIImage
@implementation UIImage (ImageRotate)
- (UIImage *)imageRotateIndegree:(float)degree {
    //1.image -> context
    size_t width = (size_t)(self.size.width*self.scale);
    size_t height = (size_t)(self.size.height*self.scale);
    
    size_t bytesPerRow = width*4; //表明每行 图片数据字节
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedFirst; //alpha
    //配置上下文参数
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault|alphaInfo);
    if (!bmContext) {
        return nil;
    }
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), self.CGImage);
    
    // 2 旋转
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(bmContext);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {data, height, width, bytesPerRow};
    Pixel_8888 bgColor = {0,0,0,0};
    vImageRotate_ARGB8888(&src, &dest, NULL, degree, bgColor, kvImageBackgroundColorFill);
    
    //3 content -> UIImage
    CGImageRef rotateImageref = CGBitmapContextCreateImage(bmContext);
    UIImage *rotateImage = [UIImage imageWithCGImage:rotateImageref scale:self.scale orientation:self.imageOrientation];
    return rotateImage;
}
@end
