//
//  ImageToBytesController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/18.
//  Copyright © 2019 njw. All rights reserved.
//

#import "ImageToBytesController.h"

@interface ImageToBytesController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;

@end

@implementation ImageToBytesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"imageToBytes";
    
    [self convertFormatTest];
    [self testImageToGray];
    [self testImageToRecolor];
    [self testImageToRecolor2];
    [self testImageHighLight];
}

- (void)convertFormatTest {
    UIImage *image = self.imageView.image;
    unsigned char *imageData = [self convertUIImagetoData:image];
    unsigned char *newImageData = [self imageGrayWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:newImageData image:image];
    self.imageView2.image = imageNew;
}

- (void)testImageToGray {
    UIImage *image = self.imageView.image;
    unsigned char *imageData = [self convertUIImagetoData:image];
    UIImage *imageNew = [self convertDatatoUIImage:imageData image:image];
    self.imageView1.image = imageNew;
}

- (void)testImageToRecolor {
    UIImage *image = self.imageView.image;
    unsigned char *imageData = [self convertUIImagetoData:image];
    unsigned char *newImageData = [self imageReColorWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:newImageData image:image];
    self.imageView3.image = imageNew;
}

- (void)testImageToRecolor2 {
    UIImage *image = self.imageView.image;
    unsigned char *imageData = [self convertUIImagetoData:image];
    unsigned char *imageData1 = [self imageGrayWithData:imageData width:image.size.width height:image.size.height];
    unsigned char *newImageData = [self imageReColorWithData:imageData1 width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:newImageData image:image];
    self.imageView4.image = imageNew;
}

- (void)testImageHighLight {
    UIImage *image = self.imageView.image;
    unsigned char *imageData = [self convertUIImagetoData:image];
    unsigned char *newImageData = [self imageHighlightWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:newImageData image:image];
    self.imageView5.image = imageNew;
}

// unsigned char * 指针 CoreGraphics
// 1.UIImage -> CGImage  2.创建颜色空间CGColorSpace 3.分配bit级空间 4.CGBitmap 5.渲染
- (unsigned char *)convertUIImagetoData:(UIImage *)image {
    CGImageRef imageref = [image CGImage];
    CGSize image_size = image.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //每个像素点 对应4个Bytes R G B A 像素点个数 = 宽 * 高
    //malloc: 内存分配
    void *data = malloc(image_size.width*image_size.height*4);
    //1:data
    CGContextRef context = CGBitmapContextCreate(data, image_size.width, image_size.height, 8, 4*image_size.width, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    //以rgba的方式装到了data里
    CGContextDrawImage(context, CGRectMake(0, 0, image_size.width, image_size.height), imageref);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return (unsigned char*)data;
}

- (UIImage *)convertDatatoUIImage:(unsigned char*)imageData image:(UIImage *)imageSource {
    
    CGFloat width = imageSource.size.width;
    CGFloat height = imageSource.size.height;
    NSInteger dataLength = width*height*4;
    CGDataProviderRef provide = CGDataProviderCreateWithData(NULL, imageData, dataLength, NULL); //原始数据
    int bitsPerComponent = 8; //每个元素所占位数 bit
    int bitsPerPixel = 32; //每个像素所占位数 bit
    int bytesPerRow = 4*width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageref = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provide, NULL, NO, renderIntent);
    
    UIImage *imageNew = [UIImage imageWithCGImage:imageref];
    CFRelease(imageref);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provide);
    return imageNew;
}

//灰度图片效果
- (unsigned char*)imageGrayWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 1 分配内存空间 == image == width * height * 4
    unsigned char *resultData = malloc(width*height*sizeof(unsigned char)*4);
    memset(resultData, 0, width*height*sizeof(unsigned char)*4);
    
    for (int h=0; h<height; h++) {
        for (int w=0; w<width; w++) {
            unsigned int imageIndex = h*width+w;
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            
            int bitMap = bitMapRed*77/255+bitMapGreen*151/255+bitMapBlue*88/255;
            
//            int bitMap = (bitMapRed + bitMapGreen + bitMapBlue) / 3;
            unsigned char newBitMap = (bitMap > 255) ? 255 : bitMap;
            memset(resultData+imageIndex*4, newBitMap, 1);
            memset(resultData+imageIndex*4+1, newBitMap, 1);
            memset(resultData+imageIndex*4+2, newBitMap, 1);
        }
    }
    return resultData;
}
//彩色底版算法
- (unsigned char*)imageReColorWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 1 分配内存空间 == image == width * height * 4
    unsigned char *resultData = malloc(width*height*sizeof(unsigned char)*4);
    memset(resultData, 0, width*height*sizeof(unsigned char)*4);
    
    for (int h=0; h<height; h++) {
        for (int w=0; w<width; w++) {
            unsigned int imageIndex = h*width+w;
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            
            unsigned char bitMapRedNew = 255-bitMapRed;
            unsigned char bitMapGreenNew = 255-bitMapGreen;
            unsigned char bitMapBlueNew = 255-bitMapBlue;
            memset(resultData+imageIndex*4, bitMapRedNew, 1);
            memset(resultData+imageIndex*4+1, bitMapGreenNew, 1);
            memset(resultData+imageIndex*4+2, bitMapBlueNew, 1);
        }
    }
    return resultData;
    
}
// 图片美白
- (unsigned char *)imageHighlightWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height {
    // 1 分配内存空间 == image == width * height * 4
    unsigned char *resultData = malloc(width*height*sizeof(unsigned char)*4);
    memset(resultData, 0, width*height*sizeof(unsigned char)*4);
    NSArray *colorArrayBase = @[@"55", @"110", @"155", @"185", @"220", @"240", @"250", @"255"];
    NSMutableArray *colorArray = [[NSMutableArray alloc] init];
    int befornum = 0;
    for (int i = 0; i<8; i++) {
        NSString *numStr = [colorArrayBase objectAtIndex:i];
        int num = numStr.intValue;
        float step = 0;
        if (i == 0) {
            step = num/32.0f;
            befornum = num;
        } else {
            step = (num - befornum) / 32.0f;
        }
        for (int j=0; j<32; j++) {
            int newNum = 0;
            if (i==0) {
                newNum = (int)(j*step);
            }
            else {
                newNum = (int)(befornum + j*step);
            }
            NSString *newNumStr = [NSString stringWithFormat:@"%d", newNum];
            [colorArray addObject:newNumStr];
        }
        befornum = num;
    }
    
    for (int h=0; h<height; h++) {
        for (int w=0; w<width; w++) {
            unsigned int imageIndex = h*width+w;
            
            //像素RGBA == 4B
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            
            //colorArray: index 0 - 255 value
            NSString *redStr = [colorArray objectAtIndex:bitMapRed];
            NSString *greenStr = [colorArray objectAtIndex:bitMapGreen];
            NSString *blueStr = [colorArray objectAtIndex:bitMapBlue];
            
            unsigned char bitMapRedNew = redStr.intValue;
            unsigned char bitMapGreenNew = greenStr.intValue;
            unsigned char bitMapBlueNew = blueStr.intValue;
            
            memset(resultData+imageIndex*4, bitMapRedNew, 1);
            memset(resultData+imageIndex*4+1, bitMapGreenNew, 1);
            memset(resultData+imageIndex*4+2, bitMapBlueNew, 1);
        }
    }
    return resultData;
}

@end
