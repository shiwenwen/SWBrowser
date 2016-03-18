//
//  BrowserViewController.m
//  SWBrowser
//
//  Created by 石文文 on 16/3/15.
//  Copyright © 2016年 shiwenwen. All rights reserved.
//

#import "BrowserViewController.h"
#import "TFHpple.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "NSData+Base64.h"
@interface BrowserViewController ()<UITextFieldDelegate,UIWebViewDelegate,NJKWebViewProgressDelegate>{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UITextField *addressField;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextView *contentView;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self BrowserrUI];
}

#pragma mark - 浏览器UI
- (void)BrowserrUI{
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100,KScreenWidth, KScreenHeight - 300 )];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor colorWithRed:0.001 green:0.734 blue:1.000 alpha:1.000];
    NSMutableURLRequest *request ;
    if (self.defaultUrl) {
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.defaultUrl]
                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];

    }else{
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];//默认百度
    }
    request.HTTPShouldHandleCookies = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    
    
    [self.webView loadRequest:request];

//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"网页测试" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
//    
    self.webView.scalesPageToFit=YES;
    self.webView.multipleTouchEnabled=YES;
    
    self.webView.userInteractionEnabled=YES;
    //初始化进度
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _progressView = [[NJKWebViewProgressView alloc]initWithFrame:CGRectMake(0, 98, KScreenWidth, 2)];

    
    self.webView.delegate = _progressProxy;
    
    
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
    [self.view addSubview:_progressView];
    
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
            [self.webView goBack];//返回
        }
            break;
        case 1:
        {
            [self.webView goForward];//前进
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];

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
    
    self.addressField.text = [NSString stringWithFormat:@"%@",self.webView.request.URL];
}
#pragma mark -- webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.webView.request.URL];
    self.addressField.text = urlStr;
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.webView.request.URL];
    self.addressField.text = urlStr;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{


    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    

    
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    

    
    if (progress == 0) {
         //开始载入时清空内容
        self.contentView.text = @"";
        self.imageView.hidden = YES;
    }else if (progress == 1){
        
       
        dispatch_async(dispatch_get_global_queue(2, 0), ^{
            [self saveLoginSession];
        });
        

  
        //网页加载完成
        NSString *urlStr = [NSString stringWithFormat:@"%@",self.webView.request.URL];
        self.addressField.text = urlStr;
        
        
        //    获取所有html:
        NSString *lJs1 = @"document.documentElement.innerHTML";
        //    获取网页title:
        NSString *lJs2 = @"document.title";
        
        NSString *lHtml1 = [self.webView stringByEvaluatingJavaScriptFromString:lJs1];
        NSString *lHtml2 = [self.webView stringByEvaluatingJavaScriptFromString:lJs2];
        

        
        self.titleLabel.text = lHtml2;//设置标题

        //获取html的data数据
        //转换成GBK编码
        NSStringEncoding gbEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSData *htmlData = [lHtml1 dataUsingEncoding:gbEncoding];

        lHtml1 = [lHtml1 stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">"
                                                   withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
        NSLog(@"lHtml1 = %@\n lHtml2 =%@ ",lHtml1,lHtml2);
        htmlData = [lHtml1 dataUsingEncoding:NSUTF8StringEncoding];
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
            
            [self getJingdongList:xpathParser];
            
        }else if ([self getAllowedUrlIndexFromAllowedUrlsWithUrlString:urlStr] == 1){
            
             [self getInfoFromCHSI:xpathParser];//学信网信息抓取
        }else if ([self getAllowedUrlIndexFromAllowedUrlsWithUrlString:urlStr] == 2){
            
            
            
        }
        
        
        
        
    }
    
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
        
//        
//        if ([imgElement objectForKey:@"src"]) {
//            
//            NSString *photoUrl = [NSString stringWithFormat:@"%@://%@%@",self.webView.request.URL.scheme,self.webView.request.URL.host,[imgElement objectForKey:@"src"]];
//            
//            self.imageView.hidden = NO;
////            [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil options:SDWebImageHandleCookies];
//            
//            //查看本地是否已经缓存了图片
//            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:photoUrl]];
//            
//            NSData *data = [[SDImageCache sharedImageCache]diskImageDataBySearchingAllPathsForKey:key];
//            
//            if (data) {
//                self.imageView.image = [UIImage imageWithData:data];
//            }else{
//                
//                NSLog(@"没有缓存图片");
//               [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil options:SDWebImageHandleCookies];
//                
//            }
//            
//        }else{
//            
//        }
//
        /*
         获取img标签，可以用各种方法，ById，ByTags，elementFromPoint等。
         创建canvas标签，创建context，把canvas设置成和图片一样大
         把img画到context里
         返回canvas或context里的数据
         
         */
        NSString *js = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"test" ofType:@"js"]] encoding:NSUTF8StringEncoding error:nil];
        NSString *stringData = [self.webView stringByEvaluatingJavaScriptFromString:js];
        //返回的数据格式是 rrr,ggg,bbb,aaa,rrr,ggg,bbb,aaa,rrr,...  把这些数据传到CGBitmapContext里再转成CGImage
        NSArray *byteDataArray = [stringData componentsSeparatedByString:@","];
        if (byteDataArray) {
            NSInteger count = byteDataArray.count;
            if (byteDataArray.count > 2) {
                int width = [[byteDataArray objectAtIndex:(count - 2)] intValue];
                int height = [[byteDataArray objectAtIndex:(count - 1)] intValue];
                count -= 2;
                char *rawData = (char*)malloc(count);
                for (int i = 0; i < count; i++) {
                    rawData[i] = [(NSString*)[byteDataArray objectAtIndex:i] intValue];
                }
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef contextRef = CGBitmapContextCreate(rawData, width, height, 8, 4*width, colorSpace, kCGImageAlphaNoneSkipLast);
                CGColorSpaceRelease(colorSpace);
                CGImageRef cgImage = CGBitmapContextCreateImage(contextRef);
                CGContextRelease(contextRef);
                UIImage *image = [UIImage imageWithCGImage:cgImage];
                CGImageRelease(cgImage);
                free(rawData);
                self.imageView.image = image;
                self.imageView.hidden = NO;
            }
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
    
    if (tbodyElements.count < 1) {
        self.contentView.text = @"无可用数据 请进我的订单";
        
        return;
    }
    
    NSMutableString *content = [NSMutableString string];
    for (int i = 0; i < tbodyElements.count; i++) {
        
        
        
       
        
        [content appendString:@"\n---------------\n成交时间"];
        TFHppleElement *tbodyElement = tbodyElements[i];
        

        TFHppleElement *child = [tbodyElement searchWithXPathQuery:@"//span[@class='dealtime']"].firstObject;//成交时间

        [content appendString:[NSString stringWithFormat:@":%@\n",child.text]];
        
        child = [tbodyElement searchWithXPathQuery:@"//span[@class='number']"].firstObject;//订单号：
        
        [content appendString:[[child.text stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@"" ]];
        child = [tbodyElement searchWithXPathQuery:@"//span[@class='number']/a[@name='orderIdLinks']"].firstObject;//订单号

        [content appendString:[NSString stringWithFormat:@"%ld\n",(long)[child.text integerValue]]];
        
        NSArray *childs = [tbodyElement searchWithXPathQuery:@"//a[@class='a-link']"];
        for (TFHppleElement *element in childs) {
            
            [content appendString:[NSString stringWithFormat:@"%@\n",element.text]];//商品名称
        }

        
        child = [tbodyElement searchWithXPathQuery:@"//span[@class='order-shop']/span|//span[@class='order-shop']/a"].firstObject;
        if (child.text) {
            [content appendString:[NSString stringWithFormat:@"来自:%@\n",child.text]];//来自
        }

        
        
        child = [tbodyElement searchWithXPathQuery:@"//ul[@class='o-info']/li"].firstObject;
        
        if (child.text) {
            [content appendString:[NSString stringWithFormat:@"%@\n",child.text]];//info
        }
        child = [tbodyElement searchWithXPathQuery:@"//div[@class='consignee tooltip']/span[@class='txt']"].firstObject;
        if (child.text) {
            [content appendString:[NSString stringWithFormat:@"收货人:%@\n",child.text]];//
        }
        child = [tbodyElement searchWithXPathQuery:@"//div[@class='amount']/span"].firstObject;
        if (child.text) {
            [content appendString:[NSString stringWithFormat:@"%@\n",child.text]];//支付金额
        }
        child = [tbodyElement searchWithXPathQuery:@"//span[@class='ftx-13']"].firstObject;
        if (child.text) {
            [content appendString:[NSString stringWithFormat:@"支付方式:%@\n",child.text]];//
        }
        child = [tbodyElement searchWithXPathQuery:@"//div[@class='prompt-01 prompt-02']/div[@class='pc']"].firstObject;
        [content appendString:@"收货信息:"];
        for (TFHppleElement *element in child.children) {
            if (element.text) {
                [content appendFormat:@"%@  ",element.text];
            }

        }
        
    }
    
    self.contentView.text = content;
    
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
