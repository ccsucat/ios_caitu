//
//  ViewController.m
//  猜图
//
//  Created by xubinbin on 2020/2/24.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"
#define kButtonW 43.0
#define kButtonH 43.0
#define kButtonMargin 10.0
#define kTotalCol 7

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *iconView;
//遮罩按钮
@property (nonatomic, strong) UIButton *cover;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSArray *questions;

@property (nonatomic, assign) int index;

@property (weak, nonatomic) IBOutlet UILabel *noLable;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIView *answerView;

@property (weak, nonatomic) IBOutlet UIView *optionView;

@property (weak, nonatomic) IBOutlet UIButton *scoreButton;

@end
@implementation ViewController

-(IBAction)nextQuestion
{
    self.index++;
    if (self.index >= self.questions.count) {
        NSLog(@"通关了");
        return;
    }
    Question *question = self.questions[self.index];
    
    [self setupBasicInfo:question];
    
    [self createAnswerButtons:question];
    
    [self createOptionButtons:question];
    
}

-(IBAction)tips
{
    int currentScore = [self.scoreButton.currentTitle intValue];
    if (currentScore < 1000) {
        return;
    }
    for (UIButton *btn in self.answerView.subviews) {
        [self answerClick:btn];
    }
    
    Question *question =self.questions[self.index];
    
    NSString *firstWord = [question.answer substringToIndex:1];
    
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:firstWord]) {
            [self optionClick:btn];
            [self changeScore:-1000];
            break;
        }
    }
}


-(void) setupBasicInfo:(Question *) question
{
    self.noLable.text = [NSString stringWithFormat:@"%d/%d", self.index + 1, self.questions.count];
     
     self.titleLable.text = question.title;
     [self.iconView setImage:question.image forState:UIControlStateNormal];
     
     self.nextButton.enabled = (self.index != self.questions.count - 1);
}

-(void)createAnswerButtons:(Question *) question
{
    int len = question.answer.length;
    CGFloat answerViewW = self.answerView.bounds.size.width;
    CGFloat startX = (answerViewW -  len * kButtonW - (len - 1) * kButtonMargin) * 0.5;
    
    for (UIButton *btn in self.answerView.subviews) {
        [btn removeFromSuperview];
    }
    for (int i = 0; i < len; i++) {
        CGFloat X = startX + i * (kButtonW + kButtonMargin);
        UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(X, 0, kButtonW, kButtonH)];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerView addSubview: answerBtn];
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void) createOptionButtons:(Question *) question
{
    CGFloat optionViewW = self.optionView.bounds.size.width;
    CGFloat optionX = (optionViewW - kTotalCol * kButtonW - (kTotalCol - 1) * kButtonMargin) * 0.5;
    
    if (self.optionView.subviews.count != question.options.count)
    {
        for (UIButton *btn in self.optionView.subviews) {
            [btn removeFromSuperview];
        }
        for (int i = 0; i < question.options.count; i++) {
            int row = i / kTotalCol;
            int col = i % kTotalCol;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(optionX + col * (kButtonW + kButtonMargin), row * (kButtonH + kButtonMargin), kButtonW, kButtonH)];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
            [self.optionView addSubview:btn];
            
            [btn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    int i = 0;
    for (UIButton *btn in self.optionView.subviews) {
        [btn setTitle:question.options[i++] forState:UIControlStateNormal];
        btn.hidden = NO;
    }
}

-(void)answerClick:(UIButton *) button
{
    if (button.currentTitle.length == 0)
        return;
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:button.currentTitle] && btn.isHidden) {
            [button setTitle:nil forState:UIControlStateNormal];
            btn.Hidden = NO;
            break;
        }
    }
}
-(void) changeScore:(int) score
{
    int currentScore = [self.scoreButton.currentTitle intValue];
    currentScore += score;
    [self.scoreButton setTitle:[NSString stringWithFormat:@"%d", currentScore] forState:UIControlStateNormal];
}
-(void)optionClick:(UIButton *) button
{
    bool isFind = false;
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length == 0) {
            [btn setTitle:button.currentTitle forState:UIControlStateNormal];
            isFind = true;
            break;
        }
    }
    if (!isFind)
        return;
    button.hidden = YES;
    NSMutableString *strM = [NSMutableString string];
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length == 0)
            return;
        [strM appendString:btn.currentTitle];
    }
    Question *question = self.questions[self.index];
    if ([question.answer isEqualToString:strM]) {
        NSLog(@"答对了");
        for (UIButton *btn in self.answerView.subviews) {
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        [self changeScore:1000];
        [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:0.5];
        
    } else {
        NSLog(@"答错了");
        for (UIButton *btn in self.answerView.subviews) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

-(NSArray *) question {
    if (!_questions) {
        _questions = [Question questions];
    }
    return _questions;
}

-(UIButton *)cover
{
    if (!_cover) {
        _cover = [[UIButton alloc] initWithFrame:self.view.bounds];
        _cover.backgroundColor = [UIColor whiteColor];
        _cover.alpha = 0.0;
        [self.view addSubview:_cover];
        [_cover addTarget:self action:@selector(bigImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self question];
    self.index = -1;
    [self nextQuestion];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    return UIStatusBarStyleLightContent;
}
- (IBAction)bigImage {
    
    //1. 增加蒙版（跟视图一样大小）
    //2. 将图片移动到视图的顶层
    
    if (self.cover.alpha == 0.0) {
        [self.view bringSubviewToFront:self.iconView];
        //3. 动画放大图片
        //1>计算目标位置
        CGFloat viewW = self.view.bounds.size.width;
        CGFloat imageW = viewW;
        CGFloat imageH = imageW;
        CGFloat imageY = (self.view.bounds.size.height - imageH) * 0.5;
        [UIView animateWithDuration:0.5 animations:^{
            self.iconView.frame = CGRectMake(0, imageY, imageW, imageH);
            self.cover.alpha = 0.5;
        }];
    } else {
        //1. 动画变小
        [UIView animateWithDuration:0.5 animations:^{
            self.iconView.frame = CGRectMake(102, 239, 210, 210);
            self.cover.alpha = 0.0;
        }];
    }
}

@end
