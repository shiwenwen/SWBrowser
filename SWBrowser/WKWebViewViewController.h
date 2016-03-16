//
//  WKWebViewViewController.h
//  SWBrowser
//
//  Created by 石文文 on 16/3/16.
//  Copyright © 2016年 shiwenwen. All rights reserved.
//

#import "ViewController.h"

@interface WKWebViewViewController : ViewController
@property (nonatomic,copy)NSString *defaultUrl;//默认打开的URL
@property (nonatomic,copy)NSArray *allowedUrls;//允许读取数据的Url数组
@end
