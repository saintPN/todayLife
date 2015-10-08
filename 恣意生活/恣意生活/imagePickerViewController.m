//
//  imagePickerViewController.m
//  恣意生活
//
//  Created by saintPN on 15/7/12.
//  Copyright (c) 2015年 saintPN. All rights reserved.
//

#import "imagePickerViewController.h"


@interface imagePickerViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (strong, nonatomic) UIPopoverPresentationController *ppc;


@end


@implementation imagePickerViewController

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"image.png"]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        self.myImageView.image = image;
    } else {
        self.myImageView.image = [UIImage imageNamed:@"心情"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮动作

- (IBAction)takingPhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //检测设备有否相机，没有就使用相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender {
    //配置弹出提示信息窗口
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"定格精彩瞬间,记录今日心情!"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - 代理方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.myImageView.image = image;
    
    //保存图片到沙盒
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"image.png"]];
    [UIImageJPEGRepresentation(image,1.0) writeToFile: filePath atomically:YES];
    NSLog(@"%@",filePath);
    //保存图片到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



























@end
