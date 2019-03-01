//
//  ViewController.m
//  SpecialCamera
//
//  Created by njw on 2019/2/18.
//  Copyright © 2019 njw. All rights reserved.
//

#import "ViewController.h"
#import "ImageToBytes/ImageToBytesController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageToBytes/ImageToBytesController.h"
#import "Bullet/BulletViewController.h"
#import "MusicPlayer/MusicPlayerController.h"
#import "PictureHandles/JpgToPng/Jpg_PngController.h"
#import "PictureHandles/ImageHandle/ImageViewController.h"
#import "mutithread/ThreadViewController.h"
#import "push/PushViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ImageToBytesController *transfor;
@end

@implementation ViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (ImageToBytesController *)transfor {
    if (nil == _transfor) {
        _transfor = [[ImageToBytesController alloc] init];
    }
    return _transfor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataArray addObject:@"Image转像素"];
    [self.dataArray addObject:@"相机的使用"];
    [self.dataArray addObject:@"弹幕"];
    [self.dataArray addObject:@"AVFoundation音乐播放器"];
    [self.dataArray addObject:@"jpg和png的相互转化"];
    [self.dataArray addObject:@"imageview的处理"];
    [self.dataArray addObject:@"多线程"];
    [self.dataArray addObject:@"推送"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            ImageToBytesController *imagetoB = [[ImageToBytesController alloc] initWithNibName:@"ImageToBytesController" bundle:nil];
            [self.navigationController pushViewController:imagetoB animated:YES];
        }
            break;
        
        case 1: {
            [self configImageController];
        }
            break;
        
        case 2: {
            BulletViewController *bulletVc = [[BulletViewController alloc] initWithNibName:@"BulletViewController" bundle:nil];
            [self.navigationController pushViewController:bulletVc animated:YES];
        }
            break;
            
        case 3: {
            MusicPlayerController *music = [[MusicPlayerController alloc] initWithNibName:@"MusicPlayerController" bundle:nil];
            [self.navigationController pushViewController:music animated:YES];
        }
            break;
            
        case 4: {
            Jpg_PngController *jpg_png = [[Jpg_PngController alloc] initWithNibName:@"Jpg_PngController" bundle:nil];
            [self.navigationController pushViewController:jpg_png animated:YES];
        }
            break;
            
        case 5: {
            ImageViewController *imagevc = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
            [self.navigationController pushViewController:imagevc animated:YES];
        }
            break;
            
        case 6: {
            ThreadViewController *threadvc = [[ThreadViewController alloc] initWithNibName:@"ThreadViewController" bundle:nil];
            [self.navigationController pushViewController:threadvc animated:YES];
        }
            break;
            
        case 7: {
            PushViewController *pushVc = [[PushViewController alloc] initWithNibName:@"PushViewController" bundle:nil];
            [self.navigationController pushViewController:pushVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)configImageController {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *mediaType = (__bridge NSString*)kUTTypeImage;
    controller.mediaTypes = [[NSArray alloc] initWithObjects:mediaType, nil];
    controller.delegate = self;
    [self.navigationController presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(__bridge NSString*)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        unsigned char *imageData = [self.transfor convertUIImagetoData:image];
        unsigned char *imageDataNew = [self.transfor imageReColorWithData:imageData width:image.size.width height:image.size.height];
        UIImage *imageNew = [self.transfor convertDatatoUIImage:imageDataNew image:image];
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }
}

@end
