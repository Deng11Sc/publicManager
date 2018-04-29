//
//  RoyaleRootViewController.m
//  RoyaleRoulette
//
//  Created by Yonger on 2018/4/21.
//  Copyright © 2018年 RouletteRoyale. All rights reserved.
//

#import "RoyaleRootViewController.h"
#import <WebKit/WebKit.h>
#import "SDWebImageDownloader.h"
#import "WKProgressView.h"
#import "WKBottomView.h"
#import "WKNoNetworkAlertView.h"

#import <AFNetworking.h>
#import "RoyaleHeader.h"
#import "SVProgressHUD.h"

#define PROGRESS_HEIGHT     4.0f

@interface RoyaleRootViewController ()<WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate,WKBottomViewDelegate>
{
    WKWebView *kWKWebView;
    BOOL isShowAlert;
    
    WKBottomView *contentBottomView;
    AFNetworkReachabilityStatus networkStatus;
}

@property (nonatomic,strong) WKProgressView *progressView;
@property (nonatomic,strong) WKNoNetworkAlertView *noNetworkAlertView;
@end

@implementation RoyaleRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    contentBottomView = [[WKBottomView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - TabBarHeight, MainScreenWidth, TabBarHeight)];
    contentBottomView.delegate = self;
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    NSString *source = @"";
    WKUserScriptInjectionTime injectionTime = WKUserScriptInjectionTimeAtDocumentStart;
    BOOL forMainFrameOnly = NO;
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:injectionTime forMainFrameOnly:forMainFrameOnly];
    [userContentController addUserScript:script];
    
    WKProcessPool *processPool = [[WKProcessPool alloc] init];
    WKWebViewConfiguration *webViewController = [[WKWebViewConfiguration alloc] init];
    webViewController.processPool = processPool;
    webViewController.userContentController = userContentController;
    
    kWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, self.view.frame.size.width, MainScreenHeight - StatusBarHeight - contentBottomView.frame.size.height) configuration:webViewController];
    kWKWebView.UIDelegate = self;
    kWKWebView.navigationDelegate = self;
    kWKWebView.allowsBackForwardNavigationGestures = YES;
    kWKWebView.scrollView.showsVerticalScrollIndicator = NO;
    kWKWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:kWKWebView];
    [self.view addSubview:contentBottomView];
    
    if (@available(iOS 11,*)) {
        kWKWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [kWKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGes.delegate = self;
    longPressGes.minimumPressDuration = 0.35;
    [kWKWebView addGestureRecognizer:longPressGes];

    networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
    
/* ===== 重要的问题警告三遍 ====*/
#warning ----- 这个值只是测试用的，提交appStore的时候用接口数据
#warning ----- 这个值只是测试用的，提交appStore的时候用接口数据
#warning ----- 这个值只是测试用的，提交appStore的时候用接口数据
    self.urlString = @"https://xvns.yule-app.net/";
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)longPressAction:(UIGestureRecognizer*)ges{
    
    if (isShowAlert == YES) {
        return;
    }
    
    CGPoint point = [ges locationInView:kWKWebView];
    NSString *jsStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src",point.x,point.y];
    
    [kWKWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSString *imageUrlStr = (NSString*)obj;
        if ([imageUrlStr rangeOfString:@"http://"].location != NSNotFound) {
            imageUrlStr = [imageUrlStr stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([imageUrlStr length] > 0) {
                isShowAlert = YES;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrlStr]
                                                                          options:SDWebImageDownloaderHighPriority
                                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                              UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                          }];
                    isShowAlert = NO;
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    isShowAlert = NO;
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
    }];
}

#pragma mark 图片保存的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"图片保存失败，无法访问相册"
                                                                            message:@"请在“设置>隐私>照片”打开相册访问权限"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)performOperationWithStyle:(OperationStyle)style{
    switch (style) {
        case OperationStyleGoBack:
        {
            if ([kWKWebView canGoBack]) {
                [kWKWebView goBack];
            }
        }
            break;
        case OperationStyleGoForward:
        {
            if ([kWKWebView canGoForward]) {
                [kWKWebView goForward];
            }
        }
            break;
        case OperationStyleRefresh:
        {
            [kWKWebView reload];
        }
            break;
        case OperationStyleMenu:
        {
            [self openContentUseB];
        }
            break;
        case OperationStyleHomePage:
        {
            if (kWKWebView.backForwardList != nil && kWKWebView.backForwardList.backList.count > 0) {
                [kWKWebView goToBackForwardListItem:[kWKWebView.backForwardList.backList firstObject]];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)openContentUseB{
    NSURL *url = kWKWebView.URL;
    if (url == nil || [url.absoluteString isBlankString]) {
        url = [NSURL URLWithString:self.urlString];
    }
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [SVProgressHUD showInfoWithStatus:@"加载失败"];
    }
}

#pragma mark ------------------------  监听网页内容加载进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == kWKWebView) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            if (newValue == 1) {
                self.progressView.hidden = YES;
                self.progressView.frame  = CGRectMake(0, self.progressView.frame.origin.y, 0, PROGRESS_HEIGHT);
            }else{
                self.progressView.hidden = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    self.progressView.frame = CGRectMake(0, self.progressView.frame.origin.y, MainScreenWidth*newValue, PROGRESS_HEIGHT);
                }];
            }
        }
    }
}

#pragma mark -------------------------  进度条
- (WKProgressView*)progressView{
    if (_progressView == nil) {
        _progressView = [[WKProgressView alloc] initWithFrame:CGRectMake(0, NaviBarHeight, 0, PROGRESS_HEIGHT)];
        [self.view addSubview:_progressView];
    }
    
    [self.view bringSubviewToFront:_progressView];
    return _progressView;
}

#pragma mark 无网提示视图
- (WKNoNetworkAlertView*)noNetworkAlertView{
    if (_noNetworkAlertView == nil) {
        _noNetworkAlertView = [[WKNoNetworkAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - TabBarHeight)];
        [self.view addSubview:_noNetworkAlertView];
    }
    
    [self.view bringSubviewToFront:_noNetworkAlertView];
    
    return _noNetworkAlertView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat height  = IsPortrait?TabBarHeight:BGNaviBarHeight;
    CGFloat originY = IsPortrait?(MainScreenHeight - height):MainScreenHeight;
    contentBottomView.frame = CGRectMake(0, originY, MainScreenWidth, height);
    
    [self resetContentWebFrame];
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        self.noNetworkAlertView.hidden = NO;
    }else{
        if (_noNetworkAlertView) {
            _noNetworkAlertView.hidden = YES;
        }
    }
    
    if (_noNetworkAlertView) {
        _noNetworkAlertView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - (IsPortrait?TabBarHeight:0));
    }
}

#pragma mark 设置web的frame
- (void)resetContentWebFrame{
    CGFloat originY = IsPortrait?(iPhoneX?(StatusBarHeight-10):StatusBarHeight):0;
    CGFloat height  = contentBottomView.frame.origin.y - originY;
    
    if (_progressView) {
        _progressView.frame = CGRectMake(0, originY, _progressView.frame.size.width, PROGRESS_HEIGHT);
    }
    
    kWKWebView.frame = CGRectMake(0, originY, MainScreenWidth, height);
}

#pragma mark 网络监听
- (void)networkStatusDidChanged:(NSNotification*)info{
    NSDictionary *inforDict = [info userInfo];
    if (inforDict) {
        NSString *statusStr = [NSObject getStringFromDict:inforDict withKey:AFNetworkingReachabilityNotificationStatusItem];
        if (statusStr == nil || [statusStr isBlankString]) {
            statusStr = [NSObject getStringFromDict:inforDict withKey:@"LCNetworkingReachabilityNotificationStatusItem"];
        }
        NSInteger status   = [statusStr integerValue];
        networkStatus = status;
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            self.noNetworkAlertView.hidden = NO;
        }else{
            if (_noNetworkAlertView) {
                _noNetworkAlertView.hidden = YES;
            }
            
            NSURL *url = kWKWebView.URL;
            if (url == nil || [url.absoluteString isBlankString]) {
                [self loadMainPageContent];
            }else{
                [kWKWebView reload];
            }
        }
    }
}

#pragma mark 加载主页面
- (void)loadMainPageContent{
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [kWKWebView loadRequest:request];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark ----------------------------------------------------------- 是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *urlStr = [NSString stringWithFormat:@"%@",navigationAction.request.URL.absoluteString];
    if ([urlStr hasPrefix:@"itms"] || [urlStr hasPrefix:@"itunes.apple.com"] ) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"在App Store中打开?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:url];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }else{
            [SVProgressHUD showInfoWithStatus:@"跳转失败"];
        }
    }
    
    //如果是跳转的是需要浏览器打开的页面则不允许跳转并用浏览器打开
    NSString *openUseBrowser = @"UseBrowser";
    if ([urlStr hasPrefix:@"my"] || [urlStr rangeOfString:openUseBrowser].location != NSNotFound) {
        NSMutableString *mutableStr=[[NSMutableString alloc]initWithString:urlStr];
        if ([urlStr hasPrefix:@"my"]) {
            [mutableStr deleteCharactersInRange:NSMakeRange(0, 2)];
        }
        if ([mutableStr rangeOfString:openUseBrowser].location != NSNotFound) {
            mutableStr = [mutableStr stringByReplacingOccurrencesOfString:openUseBrowser withString:@""].mutableCopy;
        }
        
        NSURL *url = [NSURL URLWithString:mutableStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            BOOL canOpen = [[UIApplication sharedApplication] openURL:url];
            if (canOpen == YES) {
                NSLog(@"跳转到浏览器成功");
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -----------------------------------------------------------  开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
}

#pragma mark -----------------------------------------------------------  web view页面开始接收数据
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}

#pragma mark -----------------------------------------------------------  web view加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([self isAppDomain]) {
        NSString *str=str = @"function getRefs() { \
                                    var oA = document.getElementsByTagName('a');\
                                    var length = oA.length;\
                                    for(var i= 0;i<length;i++){\
                                        var hreff = oA[i].getAttribute(\"href\");\
                                        var current = oA[i].getAttribute(\"class\");\
                                        if(current == 'appweb'){\
                                                oA[i].setAttribute(\"href\", \"my\" + hreff);}}}\
                                getRefs();";
        [kWKWebView evaluateJavaScript:str completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        }];
    }
}

- (BOOL)prefersStatusBarHidden{
    return !IsPortrait;
}

- (BOOL)isAppDomain{
    NSString *current = [kWKWebView.URL absoluteString];
    if ((current == nil || [current isBlankString]) ||
        (self.urlString == nil || [self.urlString isBlankString])) {
        return YES;
    }
    
    NSString *host = [kWKWebView.URL host];
    if ([self.urlString rangeOfString:host].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

#pragma mark -----------------------------------------------------------  加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}

#pragma mark ----------------------------------------------------------- 网页弹框 --- 确认弹框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark ----------------------------------------------------------- 网页弹框 --- 错误提示弹框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -----------------------------------------------------------  接收到服务器跳转请求  收到服务器重定向
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}

#pragma mark -----------------------------------------------------------  在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *name = [kWKWebView.URL absoluteString];
    if (name == nil || [name isBlankString]) {
        [self loadMainPageContent];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
