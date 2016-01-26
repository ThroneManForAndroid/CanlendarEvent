//
//  ViewController.m
//  CanlendarEvent
//
//  Created by yuezuo on 16/1/11.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "ViewController.h"
#import "YZAddEventController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = [UIImage imageNamed:@"007"];
    [self.view addSubview:imgView];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor grayColor];
    [self.view addSubview:button];
}
- (void)buttonClick:(id)sender {
    YZAddEventController * addEvent = [[YZAddEventController alloc]init];
    [self presentViewController:addEvent animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
