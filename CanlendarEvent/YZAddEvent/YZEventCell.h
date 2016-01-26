//
//  YZEventCell.h
//  AddEventToCalendar
//
//  Created by yuezuo on 16/1/8.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *YZDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *YZWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *YZTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *YZSelectImage;

// 接受参数类型
@property (nonatomic,strong) NSDate * YZDate;
@end
