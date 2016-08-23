//
//  ViewController.m
//  单文件和多文件上传代码封装
//
//  Created by czbk on 16/7/13.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import "UpLoadData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //
    NSLog(@"点击了屏幕");
    NSString *path = [[NSBundle mainBundle]pathForResource:@"22.jpg" ofType:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //单个文件上传
    [[UpLoadData shardUpLoadData] uploadDataFielData:data serverName:@"userfile" fileName:@"2222.jpg"];
    
    
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"11.png" ofType:nil];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    
    //多文件上传
    NSDictionary *fileDict = @{@"1.png":data1,@"2.jpg":data};
    NSDictionary *textDict = @{@"status":@"内容随便写"};
    
    [[UpLoadData shardUpLoadData] updataFileDict:fileDict textDict:textDict serverName:@"userfile[]"];
}

@end
