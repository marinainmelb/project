//
//  BirdsDetailView.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/14.
//
//

#import "BirdsDetailView.h"
#import "NormalVariable.h"
#import "UIView+MJExtension.h"
#import "UIButton+BackgroundColor.h"

@interface BirdsDetailView() <UIGestureRecognizerDelegate>

@end

@implementation BirdsDetailView
{
    UIImageView *_bgImageView;
    UIImageView *_headerImage;
    UILabel *_titleLabel;
    UILabel *_desLabel;
    UILabel *_locationLabel;
    UILabel *_timeLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    self.frame = CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight);
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kkDeviceHeight - 185) / 2, kkDeviceWidth, 185)];
    _bgImageView.image = [UIImage imageNamed:@"0_Brush Cuckoo.png"];
    _bgImageView.userInteractionEnabled = YES;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = _bgImageView.bounds;
    [_bgImageView addSubview:effectView];
    [self addSubview:_bgImageView];
    
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 60, 60)];
    _headerImage.image = _bgImageView.image;
    [_bgImageView addSubview:_headerImage];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImage.mj_x + _headerImage.mj_w + 10, 20, kkDeviceWidth - 100, 20)];
//    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.text = @"Grey Shrikethrush";
//    _titleLabel.mj_h = [self getHeight:CGSizeMake(_titleLabel.mj_w, 20) fontSize:15 text:_titleLabel.text];
    
    [_bgImageView addSubview:_titleLabel];
    
    _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.mj_x, _titleLabel.mj_y + _titleLabel.mj_h, _titleLabel.mj_w, 100)];
    
    _desLabel.font = [UIFont systemFontOfSize:15];
    _desLabel.textColor = [UIColor whiteColor];
    _desLabel.numberOfLines = 0;
    [_bgImageView addSubview:_desLabel];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImage.mj_x, _headerImage.mj_y + _headerImage.mj_h + 10, kkDeviceWidth - 30, 15)];
    _locationLabel.font = [UIFont systemFontOfSize:15];
    _locationLabel.textColor = [UIColor whiteColor];
//    _locationLabel.numberOfLines = 0;
//    _locationLabel.backgroundColor = [UIColor whiteColor];
    [_bgImageView addSubview:_locationLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImage.mj_x, _locationLabel.mj_y + _locationLabel.mj_h, kkDeviceWidth - 30, 15)];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [UIColor whiteColor];
    [_bgImageView addSubview:_timeLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:MainColor forState:UIControlStateNormal];
    [button setTitle:@"Ok" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(_headerImage.mj_x, _timeLabel.mj_y + _timeLabel.mj_h + 10, kkDeviceWidth - 30, 40);
    [_bgImageView addSubview:button];
    
}
- (void)okButtonClick
{
    self.hidden = YES;
}
- (CGFloat)getHeight:(CGSize)size
                fontSize:(CGFloat)fontSize
                text:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    return  [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height + 0.1;
}
- (void)setDict:(NSDictionary *)dict
{
    _bgImageView.image = [UIImage imageNamed:[self getImageNameWithImageCode:[dict[@"top_estimation_code"] integerValue]]];
     ;
    _headerImage.image = _bgImageView.image;
    _titleLabel.text = dict[@"top_estimation_bird"];
    _desLabel.text = dict[@"expert_comment"];
    _locationLabel.text = [NSString stringWithFormat:@"Location: %@", dict[@"location"]];
    _timeLabel.text = [NSString stringWithFormat:@"Time: %@ %@", dict[@"date"], dict[@"time"]];
    
    _desLabel.mj_h = [self getHeight:CGSizeMake(_desLabel.mj_w, 40) fontSize:13 text:_desLabel.text];
     _titleLabel.mj_h = [self getHeight:CGSizeMake(_titleLabel.mj_w, 20) fontSize:15 text:_titleLabel.text];

}
- (NSString *)getImageNameWithImageCode:(NSInteger)imageCode
{
    switch (imageCode) {
        case 0:
            return @"0_Brush Cuckoo";
            break;
        case 1:
            return @"1_Australian Golden Whistler";
            break;
        case 2:
            return @"2_Eastern Whipbird";
            break;
        case 3:
            return @"3_Grey Shrikethrush";
            break;
        case 4:
            return @"4_Pied Currawong";
            break;
        case 5:
            return @"5_Southern Boobook";
            break;
        case 6:
            return @"6_Spangled Drongo";
            break;
        case 7:
            return @"7_Willie Wagtail";
            break;
        default:
            break;
    }
    return nil;
}
- (void)tapBgView
{
    self.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(![touch.view isKindOfClass:[BirdsDetailView class]]){
        return NO;
    }
    return YES;
}
@end
