//
//  WKWebViewViewController.m
//  SWBrowser
//
//  Created by 石文文 on 16/3/16.
//  Copyright © 2016年 shiwenwen. All rights reserved.
//

#import "WKWebViewViewController.h"
#import <WebKit/WebKit.h>
#import "TFHpple.h"
@interface WKWebViewViewController ()<UITextFieldDelegate,WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)UITextField *addressField;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextView *contentView;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation WKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self BrowserrUI];
}
#pragma mark - 浏览器UI
- (void)BrowserrUI{
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 100,KScreenWidth, KScreenHeight - 300 )];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor colorWithRed:0.001 green:0.734 blue:1.000 alpha:1.000];
    NSMutableURLRequest *request ;
    if (self.defaultUrl) {
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.defaultUrl]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    }else{
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];//默认百度
    }
    request.HTTPShouldHandleCookies = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    
    [self.webView loadRequest:request];
    

    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    /*
     
     - (void)reload;
     - (void)stopLoading;
     
     - (void)goBack;
     - (void)goForward;
     */
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, KScreenWidth - 60, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    //地址栏
    self.addressField = [[UITextField alloc]initWithFrame:CGRectMake(40, 40, KScreenWidth - 60, 30)];
    self.addressField.keyboardType = UIKeyboardTypeASCIICapable;
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressField.returnKeyType = UIReturnKeyGo;
    self.addressField.clearButtonMode = UITextFieldViewModeAlways;
    //    self.addressField.text = [NSString stringWithFormat:@"%@",self.defaultUrl?self.defaultUrl:@150"https://www.baidu.com"];
    //    NSLog(@"requrst = %@",self.webView.request);
    
    self.addressField.delegate = self;
    [self.view addSubview:self.addressField];
    
    
    //底部内容视图
    self.contentView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.webView.bottom, KScreenWidth, 200)];
    self.contentView.font = [UIFont systemFontOfSize:11];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.001 green:0.734 blue:1.000 alpha:1.000];
    self.contentView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 100, 0, 100, 200)];
    [self.contentView addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.hidden = YES;
    
    //浏览器控制按钮
    for (int i = 0; i < 4; i ++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * KScreenWidth / 4, 70, KScreenWidth / 4,30)];
        button.tag = 1000 + i;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(browserClick:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (i) {
            case 0:
            {
                [button setTitle:@"后退" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [button setTitle:@"前进" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [button setTitle:@"停止" forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [button setTitle:@"重载" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
    }
    
}
#pragma mark -- 保存cookie
- (void)saveLoginSession{
    
    NSArray *allCoolkies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    if (allCoolkies.count > 0) {
        
        [NSKeyedArchiver archiveRootObject:allCoolkies toFile:kCookiePath];
        
        
    }
    
    
}
#pragma mark -- 取得cookie
- (void)updateCookie{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithFile:kCookiePath];
    for (NSHTTPCookie *cookie in cookies) {
        
        [cookieStorage setCookie:cookie];
        
    }
    
    
    
}

- (void)browserClick:(UIButton *)button{
    NSInteger tag = button.tag - 1000;
    switch (tag) {
        case 0:
        {
            if ([self.webView canGoBack]) {
                [self.webView goBack];//返回
            }

        }
            break;
        case 1:
        {
            if ([self.webView canGoForward]) {
                
                [self.webView goForward];//前进
            }

        }
            break;
        case 2:
        {
            [self.webView stopLoading];//停止
        }
            break;
        case 3:
        {
            [self.webView reload];//重新载入
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 隐藏键盘
- (void)hiddenKeyBoard:(UITapGestureRecognizer *)tap{
    
    [self.addressField resignFirstResponder];
}
#pragma mark -  关闭浏览器
- (IBAction)closeBroswer:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark -- textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //点击回车 前往输入的URL
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",textField.text];
    if (![urlStr.lowercaseString hasPrefix:@"http"]) {
        
        [urlStr insertString:@"http://" atIndex:0];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    request.HTTPShouldHandleCookies = YES;
    
    
    [self.webView loadRequest:request];
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    textField.text = @"";
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.addressField.text = [NSString stringWithFormat:@"%@",self.webView.URL];
}

#pragma mark -- WKNavigationDelegate
/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"%s", __FUNCTION__);
    //开始载入时清空内容
    self.contentView.text = @"";
    self.imageView.hidden = YES;
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.webView.URL];
    self.addressField.text = urlStr;

}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        [self saveLoginSession];
    });

    
    NSLog(@"%s", __FUNCTION__); //网页加载完成
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.webView.URL];
    self.addressField.text = urlStr;
//
    
//    //    获取所有html:
//    NSString *lJs1 = @"document.documentElement.innerHTML";
//    //    获取网页title:
//    NSString *lJs2 = @"document.title";
//    
         self.titleLabel.text = self.webView.title;//设置标题
//
    [self.webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id _Nullable unknown, NSError * _Nullable error) {
        
//        NSLog(@"%@ ",unknown);
        
 
        //    NSString *lHtml2 ;
        NSString *lHtml1 = [NSString stringWithFormat:@"%@",unknown];
//        NSLog(@"lHtml1 = %@\n lHtml2 =%@ ",lHtml1,lHtml2);
        //

        //
        //获取html的data数据
        //    NSData *htmlData = [[NSData alloc]initWithContentsOfURL:self.webView.request.URL];
        lHtml1 = [lHtml1 stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">"
                                                    withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
        NSData *htmlData = [lHtml1 dataUsingEncoding:NSUTF8StringEncoding];
        //    NSString *htmlStr = [[NSString  alloc]initWithData:htmlData encoding:NSUTF8StringEncoding];
        //    NSLog(@"htmlStr = %@",htmlData);
        //解析html数据
        TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlData];
        //根据标签来进行过滤
        
        
        if ([self getAllowedUrlIndexFromAllowedUrlsWithUrlString:urlStr] < 0) {
            //不是需要抓取的页面
            
            self.imageView.hidden = YES;
            self.contentView.text = @"无可用数据 请进入学信档案 - 高等教育 - 学历信息";
            //            self.contentView.text = lHtml1;//调试用
            return;
        }else if ([self getAllowedUrlIndexFromAllowedUrlsWithUrlString:urlStr] == 0){
            

            self.contentView.text = lHtml1;
            [self getJingdongList:xpathParser];
        }else if ([self getAllowedUrlIndexFromAllowedUrlsWithUrlString:urlStr] == 1){
            
            [self getInfoFromCHSI:xpathParser];//学信网信息抓取
        }
    }];


}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
          // 允许跳转
        decisionHandler(WKNavigationResponsePolicyAllow);
    
    // 不允许跳转
//    decisionHandler(WKNavigationResponsePolicyCancel);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);

    // 不允许跳转
//    decisionHandler(WKNavigationActionPolicyCancel);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    

    
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    
}
#pragma mark --  WKScriptMessageHandler,
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@", message);
    
    
    
}
#pragma mark - 学信抓取
- (void)getInfoFromCHSI:(TFHpple *)xpathParser {
    
    
    NSMutableArray *tdArr = [NSMutableArray arrayWithArray:[xpathParser searchWithXPathQuery:@"//td|//td[@*]"]];
    if (tdArr.count > 1) {
        
        TFHppleElement *imgElement = tdArr[1];
        NSArray *childs = [imgElement searchWithXPathQuery:@"//img"];
        imgElement = childs.lastObject;
        
        NSLog(@"image = %@",imgElement.raw);
        
        NSLog(@"image = %@",[imgElement objectForKey:@"src"]);
        
        
        if ([imgElement objectForKey:@"src"]) {
            
            NSString *photoUrl = [NSString stringWithFormat:@"%@://%@%@",self.webView.URL.scheme,self.webView.URL.host,[imgElement objectForKey:@"src"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.hidden = NO;
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil options:SDWebImageHandleCookies];
            });

            
        }else{
            
            
        }
        
        
        [tdArr removeObjectAtIndex:1];
        
    }else{
        self.imageView.hidden = YES;
        self.contentView.text = @"无可用数据 请进入学信档案 - 高等教育 - 学历信息";
        
        return;
    }
    
    
    NSArray *thArr = [xpathParser searchWithXPathQuery:@"//th"];
    
    
    NSMutableString *infoStr = [NSMutableString string];
    //开始整理数据
    for (int i = 0; i < tdArr.count; i++) {
        
        TFHppleElement *tdElement = tdArr[i];
        TFHppleElement *ththElement = thArr[i];
        NSLog(@"%@%@",ththElement.text,tdElement.text);
        [infoStr appendString:[NSString stringWithFormat:@"%@%@\n",ththElement.text,tdElement.text]];
    }
    self.contentView.text = infoStr;
    
    
    
}
#pragma mark -- 京东订单
- (void)getJingdongList:(TFHpple *)xpathParser {
    
    NSArray *tbodyElements = [xpathParser searchWithXPathQuery:@"//tbody|tbody[@*]"];
    for (TFHppleElement *tbodyElement in tbodyElements) {
        
        
    }
    
    
    
}
#pragma mark - 获取可抓取页面的url字符串index
- (NSInteger )getAllowedUrlIndexFromAllowedUrlsWithUrlString:(NSString *)urlString{
    
    NSInteger index = 0;
    for (NSString *url in self.allowedUrls) {
        
        if ([urlString hasPrefix:url]) {
            
            return index;
        }
        index++;
    }
    
    
    return -1;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
