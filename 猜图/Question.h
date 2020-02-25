//
//  Question.h
//  猜图
//
//  Created by xubinbin on 2020/2/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Question : NSObject

@property (nonatomic, copy) NSString *answer;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) UIImage *image;

-(instancetype) initWithDict:(NSDictionary *) dict;

+(instancetype) questionWithDict:(NSDictionary *) dict;

+(NSArray *) questions;
@end

NS_ASSUME_NONNULL_END
