//
//  WKViewController.m
//  aaa
//
//  Created by JoKy_Li on 16/2/24.
//  Copyright © 2016年 IVT. All rights reserved.
//

#import "WKViewController.h"
#import <WebKit/WebKit.h>
@interface WKViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //如果从safari打开可以用 [[UIApplication sharedApplication] openURL:url]
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.view.frame), 2)];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    NSURL *url = [NSURL URLWithString:@"https://www.invasivecode.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    [self.view addSubview:_progressView];
}
#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    [_progressView setProgress:0.0 animated:false];
    self.title = webView.title;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//
//    // 如果响应的地址是百度，则允许跳转
//    if ([navigationResponse.response.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
//
//        // 允许跳转
//        decisionHandler(WKNavigationResponsePolicyAllow);
//        return;
//    }
//    // 不允许跳转
//    decisionHandler(WKNavigationResponsePolicyCancel);
//}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    // 如果请求的是百度地址，则延迟5s以后跳转
//    if ([navigationAction.request.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
//
//        // 延迟5s之后跳转
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            // 允许跳转
//            decisionHandler(WKNavigationActionPolicyAllow);
//        });
//
//        // 允许跳转
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
//    // 不允许跳转
//    decisionHandler(WKNavigationActionPolicyCancel);
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
