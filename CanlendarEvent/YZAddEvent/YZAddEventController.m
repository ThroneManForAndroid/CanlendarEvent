

//
//  YZAddEventController.m
//  AddEventToCalendar
//
//  Created by yuezuo on 16/1/8.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "YZAddEventController.h"
#import "YZAddEventView.h"
#import <EventKit/EventKit.h>
#define YZVersion ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface YZAddEventController ()<YZAddEventViewDelegate>

@end

@implementation YZAddEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化添加事件视图
    YZAddEventView * event = [[YZAddEventView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 设置代理
    event.delegate = self;
    event.timeArray = self.YZDateArray;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:event];

}

// 实现代理方法
- (void)isHaveSelect:(BOOL)isSelect withDateArray:(NSArray *)dateArray {
    
    
    if (isSelect) { // 当点击保存事件，且其中含有需要保存的事件
        
        // 保存事件
        [self saveEventToCalendar:dateArray];
        
    } else { // 点击保存事件，但是没有选中任何事件
        if (YZVersion) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"请选择感兴趣的活动" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            [alertView addAction:action];
            [self presentViewController:alertView animated:YES completion:nil];
        } else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alertView show];
        }
    }
    
}

- (void)isCancelClick:(BOOL)isClick { // 点击关闭按钮

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)saveEventToCalendar:(NSArray *)timeArray {
    // 创建事件
    EKEventStore * eventStore = [[EKEventStore alloc]init];
    __weak YZAddEventController * weekSelf = self;
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) { // 有错误
                    
                    if (YZVersion) { // 判断系统版本
                        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];

                        [alertView addAction:action];
                        [weekSelf presentViewController:alertView animated:YES completion:nil];
                    } else {
                        
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
                        [alertView show];
                    }
                    
                } else if (!granted) { // 未授权
                    
                    if (YZVersion) {
                        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"不能访问日历" message:@"用户未授权，请到设置中授权" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

                        [alertView addAction:action];
                        [weekSelf presentViewController:alertView animated:YES completion:nil];
                    } else {
                        
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户未授权，请到设置中授权" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
                        [alertView show];
                    }
                } else { // 保存事件
                    

                    
                    for (NSInteger i=0; i<timeArray.count; i++) {
                        // 创建事件
                        EKEvent * event = [EKEvent eventWithEventStore:eventStore];
                        event.title = self.YZTitle;
                        event.location = self.YZLocation;
                        event.notes = self.YZNotes;
                        
                        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"yyyy年M月d日"];
                        event.startDate = timeArray[i];
                        event.endDate = timeArray[i];
                        
                        event.allDay = YES;
                        
                        
                        //添加提醒
                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                        
                        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                        
                        NSError * error;
                        [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                    }
                    
                    if (YZVersion) {
                        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];

                        [alertView addAction:action];
                        [weekSelf presentViewController:alertView animated:YES completion:nil];
                    } else {
                        
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
                        [alertView show];
                    }
                    
                }
                
                
            });
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
