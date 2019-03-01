//
//  Jpg_PngController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/20.
//  Copyright © 2019 njw. All rights reserved.
//

#import "Jpg_PngController.h"
//gif分解
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface Jpg_PngController ()
@property (weak, nonatomic) IBOutlet UIImageView *gifimageview;

@end

@implementation Jpg_PngController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self jpgToPng];
    [self deCompositionGif];
}

// 注：png 无损+透明  jpg 有损+质量因子
- (void)jpgToPng {
    UIImage *image = [UIImage imageNamed:@"timg"];
    NSData *data = UIImagePNGRepresentation(image);
    UIImage *imagePng = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(imagePng, nil, nil, nil);
}

//1.我们要拿到我们gif数据
//2.将gif分解一帧帧
//3.将单帧数据转换为UIImage
//4.单帧图片保存
- (void)deCompositionGif {
    //1.获取gif数据
    NSString *gifPathSource = [[NSBundle mainBundle] pathForResource:@"cat" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:gifPathSource];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //2.将gif分解为一帧帧
    size_t count = CGImageSourceGetCount(source);
//    NSLog(@"%zu", count);
    NSMutableArray *temArray = [[NSMutableArray alloc] init];
    for (size_t i=0; i<count; i++) {
        CGImageRef imageref = CGImageSourceCreateImageAtIndex(source, i, NULL);
        //3.将单帧数据转换为UIImage
        UIImage *image = [UIImage imageWithCGImage:imageref scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [temArray addObject:image];
        CGImageRelease(imageref);
    }
    CFRelease(source);
    //4.单帧图片保存
    for (UIImage *image in temArray) {
        NSData *data = UIImagePNGRepresentation(image);
//        NSLog(@"%@", image);
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self showGifWithImages:temArray];
}

//显示gif图片
- (void)showGifWithImages:(NSMutableArray *)images {
    [self.gifimageview setAnimationImages:images];
    [self.gifimageview setAnimationDuration:2];
    [self.gifimageview setAnimationRepeatCount:10];
    [self.gifimageview startAnimating];
}

@end
