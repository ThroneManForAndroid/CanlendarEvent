//
//  YZAddEventView.h
//  AddEventToCalendar
//
//  Created by yuezuo on 16/1/8.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZAddEventView;
@protocol YZAddEventViewDelegate <NSObject>

@optional
- (void)isHaveSelect:(BOOL)isSelect withDateArray:(NSArray *)dateArray;
- (void)isCancelClick:(BOOL)isClick;

@end
@interface YZAddEventView : UIView
@property (nonatomic,weak) id <YZAddEventViewDelegate> delegate;
@property (nonatomic,strong) NSArray * timeArray;
@end
