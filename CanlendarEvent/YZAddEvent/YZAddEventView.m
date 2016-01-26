//
//  YZAddEventView.m
//  AddEventToCalendar
//
//  Created by yuezuo on 16/1/8.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "YZAddEventView.h"
#import "YZEventCell.h"
#define YZWidth [UIScreen mainScreen].bounds.size.width
#define YZHeight [UIScreen mainScreen].bounds.size.height

#define YZZoomScale (YZWidth/1242)
#define YZHorizMarginOfLine 50*YZZoomScale
#define YZVerticalMarginOfLine 315*YZZoomScale
#define YZHorizMarginOfDate 55*YZZoomScale
#define YZVerticalMarginOfDate (315+155+2)*YZZoomScale
#define YZVerticalMarginOfSelectImage (315+145+2)*YZZoomScale

#define YZHorizMarginOfChoose 60*YZZoomScale
#define YZHightOfChoose 134*YZZoomScale
#define YZVerticalMarginOfChoose 355*YZZoomScale

#define YZHorizMarginOfCancel 600*YZZoomScale
#define YZVerticalMarginOfCancel 95*YZZoomScale

#define YZHorizMarginOfLeftDateLabel 20*YZZoomScale
#define YZHorizMarginOfRightDateLabel 30*YZZoomScale

#define YZHorizMarginOfSelectImage 150*YZZoomScale
#define YZSelectImageWidth 50*YZZoomScale

#define YZTableViewMargin 60

@interface YZAddEventView ()<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * titlabel;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UIButton * chooseButton;
@property (nonatomic,strong) UIButton * cancelButton;
@property (nonatomic,strong) UITableView * tableViewDate;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UILabel * weekLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIImageView * selectImage;
@property (nonatomic,strong) NSMutableArray * selectArray;
@property (nonatomic,strong) NSMutableArray * selectTime;
@end
@implementation YZAddEventView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

#pragma mark - layingLoad
- (NSMutableArray *)selectTime {
    if (!_selectTime) {
        _selectTime = [NSMutableArray array];
    }
    return _selectTime;
}
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)createUI {
    
    
    // 模糊效果
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
    blurView.frame = [UIScreen mainScreen].bounds;
    [self addSubview:blurView];
    
    
    // 添加控件
    // 添加标题
    _titlabel = [[UILabel alloc] init];
    NSString * string = @"请选活动时间";
    _titlabel.text = string;
    _titlabel.textColor = [UIColor whiteColor];
    _titlabel.font = [UIFont boldSystemFontOfSize:18];
    CGRect labelRect = [string boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_titlabel.font,NSFontAttributeName, nil] context:nil];
    _titlabel.frame = CGRectMake(YZWidth/2.0-labelRect.size.width/2.0, 200*YZZoomScale, labelRect.size.width, 20);
    [self addSubview:_titlabel];
    
    // 添加分割线
    _lineView = [[UIView alloc]init];
    _lineView.frame = CGRectMake(YZHorizMarginOfLine, YZVerticalMarginOfLine, YZWidth-YZHorizMarginOfLine*2, 2);
    _lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_lineView];
    
    // 添加选择按钮
    _chooseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _chooseButton.frame = CGRectMake(YZHorizMarginOfChoose, YZHeight-YZHightOfChoose-YZVerticalMarginOfChoose, YZWidth-YZHorizMarginOfChoose*2, YZHightOfChoose);
    [_chooseButton setBackgroundImage:[UIImage imageNamed:@"图标4"] forState:UIControlStateNormal];
    [_chooseButton setTitle:@"添加到系统日历" forState:UIControlStateNormal];
    [_chooseButton addTarget:self action:@selector(addToCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_chooseButton];
    
    // 添加取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(YZHorizMarginOfCancel, YZHeight-YZVerticalMarginOfCancel-(YZWidth-YZHorizMarginOfCancel*2), YZWidth-YZHorizMarginOfCancel*2, YZWidth-YZHorizMarginOfCancel*2);
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"图标3"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    // 添加时间
    _tableViewDate = [[UITableView alloc]initWithFrame:CGRectMake(YZHorizMarginOfDate, YZVerticalMarginOfDate, YZWidth-YZHorizMarginOfDate*2, YZHeight-YZVerticalMarginOfDate-YZVerticalMarginOfChoose-_chooseButton.bounds.size.height-YZTableViewMargin) style:UITableViewStylePlain];
    _tableViewDate.backgroundColor = [UIColor clearColor];
    _tableViewDate.delegate = self;
    _tableViewDate.dataSource = self;
    _tableViewDate.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableViewDate registerNib:[UINib nibWithNibName:@"YZEventCell" bundle:nil] forCellReuseIdentifier:@"YZCell"];
    [self addSubview:_tableViewDate];
    
}


#pragma mark - 点击保存到日历
- (void)addToCalendar {
    if (_selectArray.count == 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(isHaveSelect:withDateArray:)]) {
            [self.delegate isHaveSelect:NO withDateArray:_selectTime];
        }
        
    } else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(isHaveSelect:withDateArray:)]) {
            [self.delegate isHaveSelect:YES withDateArray:_selectTime];
        }
    }
    
}
- (void)cancelButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(isCancelClick:)]) {
        [self.delegate isCancelClick:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _timeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YZTableViewMargin;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZEventCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YZCell" forIndexPath:indexPath];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval  secondToNow = 8*60*60;
    // 取出数组里面的时间
    for (int i=0; i<_timeArray.count; i++) {
        NSDate * date = [dateFormatter dateFromString:_timeArray[i]];
        NSDate * dateNow = [[NSDate alloc]initWithTimeInterval:secondToNow sinceDate:date];
        cell.YZDate = dateNow;
        [cell YZDateLabel];
        [cell YZWeekLabel];
        [cell YZTimeLabel];
    }
    

    
    // 判断当数组中保存的下标是否与当前下标相等  如果相等就显示选中图片
    if ([self.selectArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        
        cell.YZSelectImage.image = [UIImage imageNamed:@"图标"];
    } else {
        cell.YZSelectImage.image = [UIImage imageNamed:@"图标2，"];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZEventCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.YZSelectImage.image isEqual:[UIImage imageNamed:@"图标2，"]]) {
        cell.YZSelectImage.image = [UIImage imageNamed:@"图标"];
        
        // 将选中cell下表添加到数组中
        [self.selectArray addObject:[NSNumber numberWithInteger:indexPath.row]];
        [self.selectTime addObject:cell.YZDate];
    } else {
        cell.YZSelectImage.image = [UIImage imageNamed:@"图标2，"];
        
        // 将选中cell下标从数组中删除
        [self.selectArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
        [self.selectTime removeObject:cell.YZDate];
    }
}

@end
