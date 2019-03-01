//
//  UIImage+ImageWaterPrint.m
//  SpecialCamera
//
//  Created by njw on 2019/2/21.
//  Copyright © 2019 njw. All rights reserved.
//

#import "UIImage+ImageWaterPrint.h"

@implementation UIImage (ImageWaterPrint)
- (UIImage *)imageWater:(UIImage *)imageLogo waterString:(NSString *)waterString {
    UIGraphicsBeginImageContext(self.size);
    // 原始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.height, self.size.height)];
    CGFloat waterX = 633;
    CGFloat waterY = 461;
    CGFloat waterW = 16;
    CGFloat waterH = 16;
    // logo 渲染
    [imageLogo drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    // 渲染文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor redColor]};
    [waterString drawInRect:CGRectMake(0, 0, 300, 60) withAttributes:dic];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //获取UIImage
    
    return imageNew;
}
@end
