//
//  ViewController.m
//  SWBrowser
//
//  Created by 石文文 on 16/3/15.
//  Copyright © 2016年 shiwenwen. All rights reserved.
//

#import "ViewController.h"
#import "BrowserViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
}

- (IBAction)gotoCHSI:(id)sender {
    BrowserViewController *browser = [[BrowserViewController alloc]init];
    browser.defaultUrl = @"http://my.chsi.com.cn/archive/xlarchive.action?trnd=73437634925636218083722806314070";
//    browser.defaultUrl = @"http://www.cnblogs.com/YouXianMing/";
    [self presentViewController:browser animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
