//
//  ImageModel.h
//  ReativeCocoa
//
//  Created by SZT on 16/3/16.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property(nonatomic,strong)NSNumber *h;

@property(nonatomic,strong)NSString *img;

@property(nonatomic,strong)NSString *price;

@property(nonatomic,strong)NSNumber *w;

+ (ImageModel *)imageModelWithDict:(NSDictionary *)dict;


@end
