//
//  ViewController.m
//  多文件上传
//
//  Created by czbk on 16/7/13.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

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

#define kboundary @"itcast"
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //
    NSLog(@"点击了屏幕");
    
    //图片的路径
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"mm01.jpg" ofType:nil];
    //转换成二进制
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"mm02.jpg" ofType:nil];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    
    
    //文件字典
    NSDictionary *FileDict = @{@"meinv01.jpg":data1,@"meinv02.jpg":data2};
    
    //文字信息
    NSDictionary *textDict = @{@"status":@"自己写多文件上传真爽"};
    
    //上传服务器的方法
    [self updataWithFileData:FileDict textDict:textDict serverFilename:@"userfile[]"];
    
}

-(void)updataWithFileData:(NSDictionary*)fileDict textDict:(NSDictionary*)textDict serverFilename:(NSString*)serverFileName{
    //服务器地址
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload-m.php"];
    
    //请求
    NSMutableURLRequest *requesM = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    requesM.HTTPMethod = @"POST";
    
    //设置请求头
    [requesM setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //设置请求体
    requesM.HTTPBody = [self changeHttpBodyWithFileData:fileDict textDict:textDict serverFilename:serverFileName];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requesM queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //
        if(nil == connectionError){
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",result);
        }
        
    }];
}

-(NSData*)changeHttpBodyWithFileData:(NSDictionary*)fileDict textDict:(NSDictionary*)textDict serverFilename:(NSString*)serverFileName{
    //可变data
    NSMutableData *dataM = [NSMutableData data];
    
    //遍历文件数据
    [fileDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //可变字符串
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n",kboundary];
        [strM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverFileName,key];
        [strM appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
        
        //把字符串变成二进制数据
        NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
        [dataM appendData:data];
        
        //拼接原始数据
        [dataM appendData:obj];
        
        //
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    //遍历备注文字信息
    [textDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //
        NSMutableData *dataM = [NSMutableData data];
        //
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n",kboundary];
        [strM appendFormat:@"Content-Disposition: form-data; name=%@\r\n",key];
        [strM appendString:key];
        [strM appendString:@"\r\n"];
        
        NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
        
        //
        [dataM appendData:data];
    }];
    
    
    //请求尾巴
    NSString *tailStr = [NSString stringWithFormat:@"--%@--\r\n\r\n",kboundary];
    [dataM appendData:[tailStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataM.copy;
}


@end
