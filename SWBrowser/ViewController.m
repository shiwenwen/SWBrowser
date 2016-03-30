//
//  ViewController.m
//  SWBrowser
//
//  Created by 石文文 on 16/3/15.
//  Copyright © 2016年 shiwenwen. All rights reserved.
//

#import "ViewController.h"
#import "BrowserViewController.h"
#import "WKWebViewViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];



}

- (IBAction)gotoCHSI:(id)sender {
    BrowserViewController *browser = [[BrowserViewController alloc]init];
    browser.defaultUrl = @"http://my.chsi.com.cn/archive/xlarchive.action";
    browser.allowedUrls = @[@"http://order.jd.com/center/list.action",@"http://my.chsi.com.cn/archive/xlarchive.action",@"https://www.baidu.com"];
    [self presentViewController:browser animated:YES completion:^{
        
    }];
}
- (IBAction)gotoBaidu:(id)sender {
    BrowserViewController *browser = [[BrowserViewController alloc]init];
    browser.defaultUrl = @"https://www.baidu.com";
    browser.allowedUrls = @[@"http://order.jd.com/center/list.action",@"http://my.chsi.com.cn/archive/xlarchive.action",@"https://www.baidu.com"];
    [self presentViewController:browser animated:YES completion:^{
        
    }];


}
- (IBAction)gotoJingdong:(id)sender {
    
    WKWebViewViewController *browser = [[WKWebViewViewController alloc]init];
    browser.defaultUrl = @"http://order.jd.com/center/list.action";
    browser.allowedUrls = @[@"http://order.jd.com/center/list.action",@"http://my.chsi.com.cn/archive/xlarchive.action",@"https://www.baidu.com"];
    [self presentViewController:browser animated:YES completion:^{
        
    }];
}
- (IBAction)goto12306:(id)sender {
    BrowserViewController *browser = [[BrowserViewController alloc]init];
    browser.defaultUrl = @"https://kyfw.12306.cn/otn/passengers/init";
    //    browser.defaultUrl = @"https://m.baidu.com/static/index/plus/plus_logo.png";
    browser.allowedUrls = @[@"http://order.jd.com/center/list.action",@"http://my.chsi.com.cn/archive/xlarchive.action",@"https://www.baidu.com",@"https://kyfw.12306.cn/otn/passengers/init"];
    [self presentViewController:browser animated:YES completion:^{
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
