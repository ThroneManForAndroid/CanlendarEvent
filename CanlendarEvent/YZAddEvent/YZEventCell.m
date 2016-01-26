//
//  YZEventCell.m
//  AddEventToCalendar
//
//  Created by yuezuo on 16/1/8.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "YZEventCell.h"
#define YZWidth [UIScreen mainScreen].bounds.size.width
#define YZZoomScale (YZWidth/1242)
#define YZHorizMarginOfLeftDateLabel 20*YZZoomScale
#define YZHorizMarginOfRightDateLabel 30*YZZoomScale

#define YZHorizMarginOfSelectImage 150*YZZoomScale
#define YZSelectImageWidth 50*YZZoomScale
@implementation YZEventCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
//    NSDateFormatter * dateFor = [[NSDateFormatter alloc]init];
//    [dateFor setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString * st = [dateFor stringFromDate:[NSDate date]];
//    NSLog(@"==st %@",st);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UILabel *)YZDateLabel {
    NSDateFormatter * dateFor = [[NSDateFormatter alloc]init];
    [dateFor setDateFormat:@"yyyy年MM月dd日"];
    NSString * dateStr = [dateFor stringFromDate:self.YZDate];
    CGRect dateRect = [dateStr boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_YZDateLabel.font,NSFontAttributeName, nil] context:nil];
    _YZDateLabel.frame = CGRectMake(0, 0, dateRect.size.width, dateRect.size.height);
    _YZDateLabel.textColor = [UIColor whiteColor];
    _YZDateLabel.textAlignment = NSTextAlignmentLeft;
    _YZDateLabel.text = dateStr;
    [self.contentView addSubview:_YZDateLabel];
    return _YZDateLabel;
}

- (UILabel *)YZWeekLabel {
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 1;
    NSDateComponents * components = [calendar components:NSCalendarUnitWeekday fromDate:self.YZDate];
    NSString * weekStr;
    switch (components.weekday-1) {
        case 0:
            weekStr = [NSString stringWithFormat:@"星期日"];
            break;
        case 1:
            weekStr = [NSString stringWithFormat:@"星期一"];
            break;
        case 2:
            weekStr = [NSString stringWithFormat:@"星期二"];
            break;
        case 3:
            weekStr = [NSString stringWithFormat:@"星期三"];
            break;
        case 4:
            weekStr = [NSString stringWithFormat:@"星期四"];
            break;
        case 5:
            weekStr = [NSString stringWithFormat:@"星期五"];
            break;
        case 6:
            weekStr = [NSString stringWithFormat:@"星期六"];
            break;
        default:
            break;
    }
    CGRect weekRect = [weekStr boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_YZWeekLabel.font,NSFontAttributeName, nil] context:nil];
    _YZWeekLabel.frame = CGRectMake(_YZDateLabel.bounds.size.width+YZHorizMarginOfLeftDateLabel, 0, weekRect.size.width, weekRect.size.height);
    _YZWeekLabel.textColor = [UIColor whiteColor];
    _YZWeekLabel.textAlignment = NSTextAlignmentLeft;
    _YZWeekLabel.text = weekStr;
    [self.contentView addSubview:_YZWeekLabel];
    return _YZWeekLabel;
}

- (UILabel *)YZTimeLabel {
    NSDateFormatter * dateFor = [[NSDateFormatter alloc]init];
    [dateFor setDateFormat:@"HH:mm"];
    
    NSTimeInterval secondNow = -8*60*60;
    NSDate * date = [[NSDate alloc]initWithTimeInterval:secondNow sinceDate:self.YZDate];
    NSString * dateStr = [dateFor stringFromDate:date];
    CGRect timeRect = [dateStr boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_YZTimeLabel.font,NSFontAttributeName, nil] context:nil];
    _YZTimeLabel.frame = CGRectMake(_YZDateLabel.bounds.size.width+YZHorizMarginOfLeftDateLabel+_YZWeekLabel.bounds.size.width+YZHorizMarginOfRightDateLabel, 0, timeRect.size.width, timeRect.size.height);
    _YZTimeLabel.textColor = [UIColor whiteColor];
    _YZTimeLabel.textAlignment = NSTextAlignmentLeft;
    _YZTimeLabel.text = dateStr;
    [self.contentView addSubview:_YZTimeLabel];
    return _YZTimeLabel;
}

- (UIImageView *)YZSelectImage {
    
    _YZSelectImage.frame = CGRectMake(YZWidth-YZHorizMarginOfSelectImage-YZSelectImageWidth, 5, YZSelectImageWidth, YZSelectImageWidth);
    [self.contentView addSubview:_YZSelectImage];
    return _YZSelectImage;
}
@end
