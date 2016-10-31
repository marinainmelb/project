//
//  MyBirdCell.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/14.
//
//

#import "MyBirdCell.h"

@interface MyBirdCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *autorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation MyBirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)reloadCellWithDictionary:(NSDictionary *)dic
{
    _headImageView.image = [UIImage imageNamed:[self getImageNameWithImageCode:[dic[@"top_estimation_code"] integerValue]]];
    _titleLable.text = dic[@"top_estimation_bird"];
    _autorLabel.text = dic[@"expert_comment"];
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@", dic[@"date"], dic[@"time"]];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
