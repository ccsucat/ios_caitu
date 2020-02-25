//
//  Question.m
//  猜图
//
//  Created by xubinbin on 2020/2/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "Question.h"

@interface Question()
{
    UIImage *_image;
}
@end
@implementation Question

-(UIImage *) image
{
    if (!_image)
    {
        _image = [UIImage imageNamed:self.icon];
    }
    return _image;
}

-(instancetype) initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype) questionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
+ (NSArray *)questions
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];
    NSMutableArray *arrayM =[NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[Question questionWithDict:dict]];
    }
    return arrayM;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p>{answer: %@, title: %@, icon: %@, options: %@}", [self class], self, self.answer,  self.title, self.icon, self.options];
}
@end
