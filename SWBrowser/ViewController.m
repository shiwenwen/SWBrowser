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
#import "WebViewJavascriptBridge.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 375, 467)];
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.qichacha.com/firm_BJ_9aa24730a5ba37a8e215d0f054ad84aa.shtml"]]];

    self.webView.delegate = self;
    
//    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    [_bridge registerHandler:@"getQiChaChaData" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
        
        
        
    }];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    

    
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
   
    
    
}
- (IBAction)gotoCHSI:(id)sender {
//    WKWebViewViewController *browser = [[WKWebViewViewController alloc]init];
//    browser.defaultUrl = @"http://my.chsi.com.cn/archive/xlarchive.action";
//    browser.allowedUrls = @[@"http://order.jd.com/center/list.action",@"http://my.chsi.com.cn/archive/xlarchive.action",@"https://www.baidu.com"];
//    [self presentViewController:browser animated:YES completion:^{
//        
//    }];
    NSString *js = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"aa" ofType:@"js"]] encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    
    
    
}
- (IBAction)gotoBaidu:(id)sender {
    BrowserViewController *browser = [[BrowserViewController alloc]init];
    browser.defaultUrl = @"http://www.qichacha.com/firm_BJ_9aa24730a5ba37a8e215d0f054ad84aa.shtml";
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
- (IBAction)gotoTaoBao:(id)sender {
    
    BrowserViewController *browser = [[BrowserViewController alloc]init];
    browser.defaultUrl = @"https://buyertrade.taobao.com/trade/itemlist/list_bought_items.htm";
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
