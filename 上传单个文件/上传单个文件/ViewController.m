//
//  ViewController.m
//  上传单个文件
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
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击屏幕");
    
    //图片的路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"mm.jpg" ofType:nil];
    
    //把图片转换成二进制
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //调用文件上传服务器的方法
    [self uploadWithFiledata:data serverName:@"userfile" fileName:@"women.jpg"];
}

/**
 *  文件上传服务器
 *
 *  @param Filedata   要上传的二进制文件
 *  @param serverName 上传的文件在服务器上对应的字段
 *  @param fileName   上传的文件保存到服务器上的名称
 */
#define kboundary @"MyData"

-(void)uploadWithFiledata:(NSData*)Filedata serverName:(NSString*)serverName fileName:(NSString*)fileName{
    //服务器地址
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload.php"];
    
    //创建可变请求
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    requestM.HTTPMethod = @"POST";
    
    //MARK: 1,设置请求头
    [requestM setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //MARK: 2,设置请求体
    requestM.HTTPBody = [self changeHttpBodyWithFiledata:Filedata serverName:serverName fileName:fileName];
    
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requestM queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //
        if(nil == connectionError){
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"%@",result);
        }
    }];
    
    
}

//设置请求体
-(NSData*)changeHttpBodyWithFiledata:(NSData*)Filedata serverName:(NSString*)serverName fileName:(NSString*)fileName{
    //创建可变的二进制
    NSMutableData *dataM = [NSMutableData data];
    
    //创建可变的字符串
    NSMutableString *strM = [NSMutableString string];
    
    //请求体1,2,3行
    [strM appendFormat:@"--%@\r\n",kboundary];
    [strM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverName  ,fileName];
    [strM appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    //把字符串转换成二进制
    NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
    
    //MARK: 1添加,二进制数据
    [dataM appendData:data];
    
    //MARK: 2添加,请求体的数据
    [dataM appendData:Filedata];
    
    //请求的尾巴
    NSString *tailStr = [NSString stringWithFormat:@"\r\n--%@--\r\n\r\n",kboundary];
    //把字符串转换成二进制
    NSData *tailData = [tailStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //MARK: 3添加,请求尾巴的二进制数据
    [dataM appendData:tailData];
    
    
    return dataM.copy;
}



















@end
