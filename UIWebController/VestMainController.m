//
//  VestMainController.m
//  MerryS
//
//  Created by SongChang on 2018/1/15.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "VestMainController.h"
#import <WebKit/WKWebView.h>
#import "WKWebViewJavascriptBridge.h"
#import "NSString+Common.h"

#import "DY_WebTabbarView.h"

@interface VestMainController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIProgressView *progressView;//添加进度条


@property (nonatomic,strong)DY_WebTabbarView *toolbar;

@property (nonatomic,strong)NSString *homeUrlStr;

@end

@implementation VestMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.homeUrlStr = self.urlStr;
    [self setUpWKWebView];
}


//网页初始化
- (void)setUpWKWebView{
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 1)];
    progressView.tintColor = mainColor;
    progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.preferences.minimumFontSize = 18;//限制字体最小大小
    config.selectionGranularity = WKSelectionGranularityDynamic; //允许用户自定义复制文字
    config.allowsInlineMediaPlayback = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    WKUserScript *u2 = [[WKUserScript alloc] initWithSource:@"document.documentElement.style.webkitTouchCallout='none';" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [config.userContentController addUserScript:u2];
    
    if (iOS10_Later){
        config.mediaTypesRequiringUserActionForPlayback = NO;
    }else if(iOS9_Later){
        config.requiresUserActionForMediaPlayback = NO;
    }else{
        config.mediaPlaybackRequiresUserAction = NO;
    }
    
    CGRect webRect = CGRectMake(self.view.bounds.origin.x, 21, self.view.bounds.size.width, CC_Height-44-21);
    WKWebView *wkWeb = [[WKWebView alloc] initWithFrame:webRect configuration:config];
    wkWeb.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWeb.navigationDelegate = self;
    wkWeb.UIDelegate = self;//测试弹框代理
    wkWeb.scrollView.delegate = self;
    [self.view insertSubview:wkWeb belowSubview:progressView];
    
    [wkWeb addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.wkWebView = wkWeb;
    self.wkWebView.backgroundColor = [UIColor clearColor];
    self.wkWebView.scrollView.backgroundColor = [UIColor whiteColor];
    
    ///加工具栏
    [self.view addSubview:self.toolbar];
    
    [self loadingWebWihtURLString];
    
}

//网页加载
- (void)loadingWebWihtURLString{
    NSString *urlName = [NSString getCommonUrlStr:self.urlStr];
    
//    [self initWKWebViewJavascriptBridge];//初始化JS交互
    
    NSString *encodedString = nil;
//    if (iOS9_Later) {
//        NSString *charactersToEscape = @"!$&'()*+,-./:;=?@_~%#[]";
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
//        encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
//    } else {
//        //消除链接含有文字的链接
//        encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlName, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//    }
    encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlName, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    NSURL *h5Url = [NSURL URLWithString:encodedString];
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:h5Url];
    
    [self.wkWebView loadRequest:requestUrl];
    
}



#pragma mark - UIScrollDelegate
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"content刷新");
    [webView reload];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGPoint point = scrollView.contentOffset;
//    
//    if (point.y < 0) {
//        CGRect rect = [self.wkWebView.scrollView viewWithTag:1001].frame;
//        rect.origin.y = point.y;
//        rect.size.height = -point.y;
//        [self.wkWebView.scrollView viewWithTag:1001].frame = rect;
//    }else{
//        [self.wkWebView.scrollView viewWithTag:1001].frame = CGRectMake(0, 0, CC_Width, 0);
//    }
//    
//}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@">>recieveMessages>>>=%@", message);
}

- (void)scalesPageToFit:(BOOL)isScale webView:(WKWebView *)wkWebView
{
    
    //    NSString* jScript = @"";
    NSString* jScript =
    @"var head = document.getElementsByTagName('head')[0];\
    var hasViewPort = 0;\
    var metas = head.getElementsByTagName('meta');\
    for (var i = metas.length; i>=0 ; i--) {\
    var m = metas[i];\
    if (m && m.name == 'viewport') {\
    hasViewPort = 1;\
    break;\
    }\
    }; \
    if(hasViewPort == 0) { \
    var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    head.appendChild(meta);\
    }";
    
    WKUserContentController *userContentController = wkWebView.configuration.userContentController;
    NSMutableArray<WKUserScript *> *array = [userContentController.userScripts mutableCopy];
    WKUserScript* fitWKUScript = nil;
    for (WKUserScript* wkUScript in array) {
        if ([wkUScript.source isEqual:jScript]) {
            fitWKUScript = wkUScript;
            break;
        }
    }
    if (isScale) {
        if (!fitWKUScript) {
            fitWKUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [userContentController addUserScript:fitWKUScript];
        }
    }
    else {
        if (fitWKUScript) {
            [array removeObject:fitWKUScript];
        }
        ///没法修改数组 只能移除全部 再重新添加
        [userContentController removeAllUserScripts];
        for (WKUserScript* wkUScript in array) {
            [userContentController addUserScript:wkUScript];
        }
    }
}



#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self scalesPageToFit:YES webView:webView];
    
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var obj = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<obj.length;i++){\
    imgScr = imgScr + obj[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView evaluateJavaScript:jsGetImages completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    }];
    
    self.navigationItem.title = webView.title;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSString *urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"123___%@",urlStr);
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"%@",urlStr);
    
    
    if ([urlStr containsString:@"itms://"] || [urlStr containsString:@"itms-apps://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
//    else if ([urlStr containsString:@"alipay://"]) {
//
//        NSString* dataStr=[urlStr substringFromIndex:23];
//        NSLog(@"%@",dataStr);
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//
//        NSMutableString* mString=[[NSMutableString alloc] init];
//        [mString appendString:@"alipays://platformapi/startApp?appId=20000125&orderSuffix="];
//        //url进行编码
//        [mString appendString:[self encodeString:dict[@"dataString"]]];
//
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mString]];
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}


-(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
    
}


#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)dealloc
{
    self.wkWebView.UIDelegate = nil;
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.scrollView.delegate = nil;
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    self.wkWebView = nil;
    [self.wkWebView removeFromSuperview];
    
    NSLog(@"-----------------------------------dealloc:%@", self.class);

}






#pragma mark ------------------------- 非wkWebView的控件 ------------------------
- (DY_WebTabbarView *)toolbar {
    if (!_toolbar) {
        @weakify(self)
        _toolbar = [[DY_WebTabbarView alloc] initWithFrame:CGRectMake(0, CC_Height - 44, CC_Width, 44)];
        _toolbar.actionBlock = ^(DYWebBtnType btnType) {
            @strongify(self)
            switch (btnType) {
                case DYWebBtnTypeTohome:
                {
                    NSString *urlStr = [NSString getCommonUrlStr:self.homeUrlStr];
                    if (![[self.wkWebView.URL absoluteString] isEqualToString:urlStr]) {
                        
                        WKBackForwardList *list = self.wkWebView.backForwardList;
                        if (list.backList.firstObject) {
                            [self.wkWebView goToBackForwardListItem:list.backList.firstObject];
                        }
                        
//                        NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//                        [self.wkWebView loadRequest:requestUrl];
                    }
                }
                    break;
                    
                case DYWebBtnTypeRefresh:
                {
                    [self.wkWebView reload];
                }
                    break;
                    
                case DYWebBtnTypeBack:
                {
                    if (self.wkWebView.canGoBack) {
                        [self.wkWebView goBack];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                    break;
                    
                case DYWebBtnTypeNext:
                {
                    if (self.wkWebView.canGoForward) {
                        [self.wkWebView goForward];
                    }
                }
                    break;
                case DYWebBtnTypeClean:
                {
                    [self cleanCacheAndCookie];
                }
                    break;
                    
                default:
                    break;
            }
            
        };
    }
    return _toolbar;
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}




@end
