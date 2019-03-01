//
//  UIImage+ImageCut.m
//  SpecialCamera
//
//  Created by njw on 2019/2/21.
//  Copyright © 2019 njw. All rights reserved.
//

#import "UIImage+ImageCut.h"

@implementation UIImage (ImageCut)

// 步骤 ： 1.取 2.绘 3.存
- (UIImage *)imageCutSize:(CGRect)rect {
    CGImageRef subImageref = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImageref), CGImageGetHeight(subImageref));
    
    UIGraphicsBeginImageContext(smallRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallRect, subImageref);
    UIImage *image = [UIImage imageWithCGImage:subImageref];
    
    UIGraphicsEndImageContext();
    return image;
}


@end
