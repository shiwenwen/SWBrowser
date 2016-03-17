//
//  WWWebViewProtocol.m
//  SWBrowser
//
//  Created by 石文文 on 16/3/17.
//  Copyright © 2016年 shiwenwen. All rights reserved.
//

#import "WWWebViewProtocol.h"
#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImage+MultiFormat.h"
#import "NSData+ImageContentType.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
static NSString * const hasInitKey = @"WWWebViewProtocol";

@interface WWWebViewProtocol ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;

@end
@implementation WWWebViewProtocol




+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([request.URL.scheme hasPrefix:@"http"]) {
        NSString *str = request.URL.path;

        if (([str hasSuffix:@".png"] || [str hasSuffix:@".jpg"] || [str hasSuffix:@".gif"]||[str rangeOfString:@"viewphoto.action"].location != NSNotFound)
            && ![NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
            
            return YES;
        }
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //这边可用更改更改地址，提取里面的请求内容，或者设置里面的请求头。。

    
    return mutableReqeust;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //做下标记，防止递归调用
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];
    
    //查看本地是否已经缓存了图片
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL];
    
    NSData *data = [[SDImageCache sharedImageCache]diskImageDataBySearchingAllPathsForKey:key];
    
    if ([UIImage imageWithData:data]) {
        NSLog(@"key = %@",key);
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
                                                            MIMEType:[NSData sd_contentTypeForImageData:data]
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
    else {
        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    }
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *cacheImage = [UIImage sd_imageWithData:self.responseData];
    
    if (cacheImage) {
        
        //利用SDWebImage提供的缓存进行保存图片
        [[SDImageCache sharedImageCache] storeImage:cacheImage
                               recalculateFromImage:NO
                                          imageData:self.responseData
                                             forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL]
                                             toDisk:YES];
    }

    
    [self.client URLProtocolDidFinishLoading:self];
}

#pragma mark -- NSURLSessionDelegate



@end
