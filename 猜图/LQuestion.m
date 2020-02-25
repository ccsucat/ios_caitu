//
//  LQuestion.m
//  猜图
//
//  Created by xubinbin on 2020/2/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "LQuestion.h"

@interface LQuestion ()

@end

@implementation LQuestion

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.answer = dict[@"answer"];
        self.icon = dict[@"icon"];
        self.title = dict[@"title"];
        self.option = dict[@"options"];
        
    }
    return self;
}
+ (instancetype)questionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
