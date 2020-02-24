//
//  ViewController.m
//  猜图
//
//  Created by xubinbin on 2020/2/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *iconView;
//遮罩按钮
@property (nonatomic, weak) UIButton *cover;
@end
@implementation ViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)bigImage {
    //1. 增加蒙版（跟视图一样大小）
    //在设置子视图大小时，通常使用父视图的bounds属性，可以保证x, y一定是0
    UIButton *cover = [[UIButton alloc] initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor whiteColor];
    cover.alpha = 0.5;
    [self.view addSubview:cover];
    
    [cover addTarget:self action:@selector(smallImage) forControlEvents:UIControlEventTouchUpInside];
    self.cover = cover;
    //2. 将图片移动到视图的顶层
    [self.view bringSubviewToFront:self.iconView];
    //3. 动画放大图片
    //1>计算目标位置
    CGFloat viewW = self.view.bounds.size.width;
    CGFloat imageW = viewW;
    CGFloat imageH = imageW;
    CGFloat imageY = (self.view.bounds.size.height - imageH) * 0.5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    self.iconView.frame = CGRectMake(0, imageY, imageW, imageH);
    [UIView commitAnimations];
}
-(void)smallImage
{
    //UIView animateWithDuration:0.5 animations:<#^(void)animations#>
    
    //1. 动画变小
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //设置首尾式动画结束的方法
    //delegate: 代理，让视图控制器监听事件
    [UIView setAnimationDelegate:self];
    //动画完成让代理去调用方法
    [UIView setAnimationDidStopSelector:@selector(removeCover)];
    self.iconView.frame = CGRectMake(102, 239, 210, 210);
    self.cover.alpha = 0.0;
    [UIView commitAnimations];
    //2. 隐藏遮罩
    //[self.cover removeFromSuperview];
}
-(void)removeCover
{
    [self.cover removeFromSuperview];
}

@end
