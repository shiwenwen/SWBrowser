//
//  BrowserViewController.m
//  SWBrowser
//
//  Created by 石文文 on 16/3/15.
//  Copyright © 2016年 shiwenwen. All rights reserved.
//

#import "BrowserViewController.h"
#import "TFHpple.h"
@interface BrowserViewController ()<UITextFieldDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UITextField *addressField;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextView *contentView;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100,KScreenWidth, KScreenHeight - 300 )];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor colorWithRed:0.001 green:0.734 blue:1.000 alpha:1.000];
    NSURLRequest *request ;
    if (self.defaultUrl) {
        request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.defaultUrl]
                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    }else{
        request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    
    [self.webView loadRequest:request];
//    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.webView.scalesPageToFit=YES;
//    self.webView.scrollView.bounces = NO;
    self.webView.multipleTouchEnabled=YES;
    
    self.webView.userInteractionEnabled=YES;
    self.webView.delegate = self;
    /*
     
     - (void)reload;
     - (void)stopLoading;
     
     - (void)goBack;
     - (void)goForward;
     */
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, KScreenWidth - 60, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    self.addressField = [[UITextField alloc]initWithFrame:CGRectMake(40, 40, KScreenWidth - 60, 30)];
    self.addressField.keyboardType = UIKeyboardTypeASCIICapable;
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressField.returnKeyType = UIReturnKeyGo;
    self.addressField.clearButtonMode = UITextFieldViewModeAlways;
//    self.addressField.text = [NSString stringWithFormat:@"%@",self.defaultUrl?self.defaultUrl:@150"https://www.baidu.com"];
//    NSLog(@"requrst = %@",self.webView.request);
    
    self.addressField.delegate = self;
    [self.view addSubview:self.addressField];
    
    
    
    self.contentView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.webView.bottom, KScreenWidth, 200)];
    self.contentView.font = [UIFont systemFontOfSize:11];
    self.contentView.backgroundColor = [UIColor colorWithRed:0.001 green:0.734 blue:1.000 alpha:1.000];
    self.contentView.textColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 100, 0, 100, 200)];
    [self.contentView addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.hidden = YES;
    
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
        
        
        //         NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
        
        //        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allCoolkies];
        
        //            NSArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //           BOOL result =  [fileManager createFileAtPath:kCookiePath contents:data attributes:nil];
        //            NSLog(@"result ======== %d",result);
        
        [NSKeyedArchiver archiveRootObject:allCoolkies toFile:kCookiePath];
        
        
    }
    
    
    
    
}
#pragma mark -- 取得cookie
- (void)updateCookie{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    NSArray *cookies = [NSArray arrayWithContentsOfFile:kCookiePath];
    //    NSData *data = [NSData dataWithContentsOfFile:kCookiePath];
    //    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
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
            [self.webView goBack];
        }
            break;
        case 1:
        {
            [self.webView goForward];
        }
            break;
        case 2:
        {
            [self.webView stopLoading];
        }
            break;
        case 3:
        {
            [self.webView reload];
        }
            break;
        default:
            break;
    }
    
}
- (void)hiddenKeyBoard:(UITapGestureRecognizer *)tap{
    
    [self.addressField resignFirstResponder];
}
- (IBAction)closeBroswer:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark -- textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",textField.text];
    if (![urlStr hasPrefix:@"http"]) {
        
        [urlStr insertString:@"http://" atIndex:0];
    }
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];

    
    [self.webView loadRequest:request];
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    textField.text = @"";
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.addressField.text = [NSString stringWithFormat:@"%@",self.webView.request.URL];
}
#pragma mark -- webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.webView.request.URL];
    self.addressField.text = urlStr;
    
    
//    获取所有html:
    NSString *lJs1 = @"document.documentElement.innerHTML";
//    获取网页title:
    NSString *lJs2 = @"document.title";
   
    NSString *lHtml1 = [self.webView stringByEvaluatingJavaScriptFromString:lJs1];
    NSString *lHtml2 = [self.webView stringByEvaluatingJavaScriptFromString:lJs2];
    
//    NSLog(@"lHtml1 = %@\n lHtml2 =%@ ",lHtml1,lHtml2);
    
    self.titleLabel.text = lHtml2;
//    self.contentView.text = lHtml1;
    //获取html的data数据
//    NSData *htmlData = [[NSData alloc]initWithContentsOfURL:self.webView.request.URL];
    
    NSData *htmlData = [lHtml1 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *htmlStr = [[NSString  alloc]initWithData:htmlData encoding:NSUTF8StringEncoding];
//    NSLog(@"htmlStr = %@",htmlData);
    //即系html数据
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlData];
    //根据标签来进行过滤

//    NSArray *allElement = [xpathParser searchWithXPathQuery:@"//*"];
//    
//    for (TFHppleElement *element in allElement) {
//        NSLog(@"all --- %@",element.raw);
//    }
//
    if (![urlStr hasPrefix:@"http://my.chsi.com.cn/archive/xlarchive.action"]) {
        self.imageView.hidden = YES;
        self.contentView.text = @"无可用数据 请进入学信档案 - 高等教育 - 学历信息";
        
        return;
    }
    NSMutableArray *tdArr = [NSMutableArray arrayWithArray:[xpathParser searchWithXPathQuery:@"//td|//td[@*]"]];
    if (tdArr.count > 1) {
        
        TFHppleElement *imgElement = tdArr[1];
        NSArray *childs = [imgElement searchWithXPathQuery:@"//img"];
        imgElement = childs.lastObject;
        
        NSLog(@"image = %@",imgElement.raw);
        
        NSLog(@"image = %@",[imgElement objectForKey:@"src"]);


        if ([imgElement objectForKey:@"src"]) {
        NSString *photoUrl = [NSString stringWithFormat:@"http://my.chsi.com.cn%@",[imgElement objectForKey:@"src"]];
            self.imageView.hidden = NO;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil options:SDWebImageHandleCookies];
            
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
    
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        [self saveLoginSession];
    });
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
    [[CustomAlertView shareCustomAlertView]showAlertViewWtihTitle:[NSString stringWithFormat:@"error:%@",error] viewController:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
