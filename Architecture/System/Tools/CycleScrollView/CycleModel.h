//
//  CycleModel.h
//  TCRotatorImageViewDemo
//
//  Created by 华令冬 on 2019/6/3.
//  Copyright © 2019 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CycleModel : NSObject

@property (nonatomic,strong) NSString *title;
//可以传字符串或者图片
@property (nonatomic,strong) id imageUrl;
//点击地址
@property (nonatomic,strong) NSString *openUrl;

@end
