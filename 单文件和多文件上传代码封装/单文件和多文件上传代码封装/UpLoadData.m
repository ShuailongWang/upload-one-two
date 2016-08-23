//
//  UpLoadData.m
//  单文件和多文件上传代码封装
//
//  Created by czbk on 16/7/13.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "UpLoadData.h"


#define kboundary @"myData"
@implementation UpLoadData

//单例
static id _instance;
+(instancetype)shardUpLoadData{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UpLoadData alloc]init];
    });
    return _instance;
}






//单个文件上传
-(void)uploadDataFielData:(NSData*)fileData serverName:(NSString*)serverName fileName:(NSString*)fileName{
    //服务器地址
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload.php"];
    
    //可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    
    //MARK: 1,设置请求头
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //MARK: 2,设置请求体
    request.HTTPBody = [self changeDataFielData:fileData serverName:serverName fileName:fileName];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(nil == connectionError){
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"%@",result);
        }
    }];
    
}
//设置请求体
-(NSData*)changeDataFielData:(NSData*)fileData serverName:(NSString*)serverName fileName:(NSString*)fileName{
    //可变二进制数据
    NSMutableData *dataM = [NSMutableData data];
    
    //可变字符串
    NSMutableString *strM = [NSMutableString string];
    
    //添加1,2,3行
    [strM appendFormat:@"--%@\r\n",kboundary];
    [strM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverName,fileName];
    [strM appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    //把可变字符串转变成二进制数据
    NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
    
    //MARK: 1,添加二进制数据
    [dataM appendData:data];
    
    //MARK: 2,添加原始数据
    [dataM appendData:fileData];
    
    //尾巴
    NSString *tailStr = [NSString stringWithFormat:@"\r\n--%@--\r\n\r\n",kboundary];
    //MARK: 3,添加尾部二进制数据
    [dataM appendData:[tailStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //返回
    return dataM.copy;
}

//多文件上传
-(void)updataFileDict:(NSDictionary*)fileDict textDict:(NSDictionary*)textDict serverName:(NSString*)serverNmae{
    //服务器地址
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload-m.php"];
    
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    
    //MARK: 设置请求头
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //MARK: 设置请求体
    request.HTTPBody = [self changeBodyFileDict:fileDict textDict:textDict serverName:serverNmae];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //
        if(nil == connectionError){
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"%@",result);
        }
    }];
}
//
-(NSData*)changeBodyFileDict:(NSDictionary*)fileDict textDict:(NSDictionary*)textDict serverName:(NSString*)serverNmae{
    //
    NSMutableData *dataM = [NSMutableData data];
    
    //123,
    [fileDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n",kboundary];
        [strM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverNmae,key];
        [strM appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
        
        //
        NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
        
        //
        [dataM appendData:data];
        [dataM appendData:obj];
        
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }];
    
    [textDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSMutableString *strM = [NSMutableString string];
        
        //
        [strM appendFormat:@"--%@\r\n",kboundary];
        [strM appendFormat:@"Content-Disposition: form-data; name=%@\r\n",key];
        [strM appendString:key];
        [strM appendString:@"\r\n"];
        
        NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
        [dataM appendData:data];
        
    }];
    
    //
    NSString *tailStr = [NSString stringWithFormat:@"--%@--\r\n\r\n",kboundary];
    [dataM appendData:[tailStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    return dataM.copy;
}

@end
