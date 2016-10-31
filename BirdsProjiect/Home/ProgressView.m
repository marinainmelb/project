//
//  ProgressView.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/15.
//
//

#import "ProgressView.h"
#import "NormalVariable.h"

@implementation ProgressView
{
    UIProgressView *_progressViw;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)setProgress:(CGFloat)progress
{
    self.hidden = NO;
    _progressViw.progress = progress;
    
}
- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        _progressViw.progress = 0;
    }
}
- (void)createUI
{
    self.frame = CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    _progressViw = [[UIProgressView alloc] initWithFrame:CGRectMake(20, kkDeviceHeight/2 - 10, kkDeviceWidth - 40, 20)];
    _progressViw.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    [self addSubview:_progressViw];
}

@end
