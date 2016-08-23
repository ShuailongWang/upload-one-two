//
//  UpLoadData.h
//  单文件和多文件上传代码封装
//
//  Created by czbk on 16/7/13.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpLoadData : NSObject

+(instancetype)shardUpLoadData;

//单个文件上传
-(void)uploadDataFielData:(NSData*)fileData serverName:(NSString*)serverName fileName:(NSString*)fileName;


//
-(void)updataFileDict:(NSDictionary*)fileDict textDict:(NSDictionary*)textDict serverName:(NSString*)serverNmae;
@end
