//
//  UIImage+ImageCircle.m
//  SpecialCamera
//
//  Created by njw on 2019/2/21.
//  Copyright © 2019 njw. All rights reserved.
//

#import "UIImage+ImageCircle.h"

@interface view : UIView
@property (nonatomic, retain) UIImage *image;
@end

@implementation view

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, rect.size.width / 2.0, rect.size.height / 2.0));
    CGContextClip(ctx);
    CGContextFillPath(ctx);
    [_image drawAtPoint:CGPointMake(0, 0)];
    
    CGContextRestoreGState(ctx);
}

@end

@implementation UIImage (ImageCircle)
- (UIImage *)imageClipCircle {
    CGFloat ImageSizeMin = MIN(self.size.width, self.size.height);
    CGSize imageSize = CGSizeMake(ImageSizeMin, ImageSizeMin);
    
    view *mview = [[view alloc] init];
    mview.image = self;
    
    UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    mview.frame = CGRectMake(0, 0, ImageSizeMin, ImageSizeMin);
    
    mview.backgroundColor = [UIColor whiteColor];
    [mview.layer renderInContext:context];
    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return imageNew;
    
}
@end
