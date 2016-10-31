//
//  CustomPinAnnotation.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/14.
//
//

#import "CustomPinAnnotation.h"
#import "NormalVariable.h"

@implementation CustomPinAnnotation
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 60, 60);
        self.backgroundColor = [UIColor redColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _imageView.layer.borderColor = toPCcolor(@"eeeeee").CGColor;
        _imageView.layer.borderWidth = 0.5;
        
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 50, 20)];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _titleLabel.text = @"label";
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_imageView addSubview:_titleLabel];
        
        self.canShowCallout = NO;
    }
    return self;
}
- (void)setImageCode:(NSInteger)imageCode
{
    _imageCode = imageCode;
    _imageView.image = [UIImage imageNamed:[self getImageName]];
}
- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(60, 60)];
    CGFloat height = MIN(size.height, 60);
    _titleLabel.frame = CGRectMake(0, 60 - height, 60, height);
}
- (NSString *)getImageName
{
    switch (_imageCode) {
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
@end
