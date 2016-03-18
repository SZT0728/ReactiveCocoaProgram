//
//  ImageModel.m
//  ReativeCocoa
//
//  Created by SZT on 16/3/16.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (ImageModel *)imageModelWithDict:(NSDictionary *)dict
{
    ImageModel *imageModel = [[ImageModel alloc]init];
    [imageModel setValuesForKeysWithDictionary:dict];
    return imageModel;
}

@end
