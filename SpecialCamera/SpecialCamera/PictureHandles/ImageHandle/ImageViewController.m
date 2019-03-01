//
//  ImageViewController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/21.
//  Copyright © 2019 njw. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImage+ImageRotate.h"
#import "UIImage+ImageCut.h"
#import "UIImage+ImageCircle.h"
#import "UIView+imageScreenShot.h"
#import "UIImage+ImageWaterPrint.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *originImage;
@property (weak, nonatomic) IBOutlet UIImageView *rotatedImage;
@property (weak, nonatomic) IBOutlet UIImageView *cutedImage;
@property (weak, nonatomic) IBOutlet UIImageView *circledImage;
@property (weak, nonatomic) IBOutlet UIImageView *screenShot;
@property (weak, nonatomic) IBOutlet UIImageView *waterPrint;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self imageTestRotate];
    [self imageTestCut];
    [self imageTestCircle];
    [self imageTestScreenShot];
    [self imageTestWater];
}

// 水印
- (void)imageTestWater {
    UIImage *image = [UIImage imageNamed:@"timg"];
//    UIImage *logo = [UIImage imageNamed:@"1"];
    
    UIImage *imageNew = [image imageWater:self.circledImage.image waterString:@"www.imooc.com"];
    self.waterPrint.image = imageNew;
}

// 屏幕快照
- (void)imageTestScreenShot {
    UIImage *image = [UIImage imageNamed:@"timg"];
    self.originImage.image = image;
    UIImage *imageNew = [self.view imageScreenShot];
    self.screenShot.image = imageNew;
}

// 圆形图片的剪切
- (void)imageTestCircle {
    UIImage *image = [UIImage imageNamed:@"timg"];
    self.originImage.image = image;
    UIImage *imageNew = [image imageClipCircle];
    self.circledImage.image = imageNew;
}

// 图片的剪切
- (void)imageTestCut {
    UIImage *image = [UIImage imageNamed:@"timg"];
    self.originImage.image = image;
    UIImage *imageNew = [image imageCutSize:CGRectMake(100, 100, 320, 320)];
    self.cutedImage.image = imageNew;
}

//图片旋转
- (void)imageTestRotate {
    UIImage *image = [UIImage imageNamed:@"timg"];
    self.originImage.image = image;
    UIImage *imageNew = [image imageRotateIndegree:45*0.01745]; //3.14/180
    self.rotatedImage.image = imageNew;
}

@end
