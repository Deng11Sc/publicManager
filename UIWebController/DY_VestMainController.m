//
//  DY_VestMainController.m
//  SanCai
//
//  Created by SongChang on 2018/4/17.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_VestMainController.h"
#import "DY_WebTabbarView.h"

@interface DY_VestMainController()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;//添加进度条

@property (nonatomic,strong)DY_WebTabbarView *toolbar;

@property (nonatomic,strong)NSString *homeUrlStr;


@end

@implementation DY_VestMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeUrlStr = self.urlStr;
    [self setUpWebView];
    
}

- (void)setUpWebView {
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 1)];
    progressView.tintColor = mainColor;
    progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, 21, self.view.bounds.size.width, CC_Height-44-21)];
    webView.scalesPageToFit = YES; // 对页面进行缩放以适应屏幕
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque=NO;//这句话很重要，webView是否是不透明的，no为透明 在webView下添加个imageView展示图片就可以了
    [self.view addSubview:webView];
    _webView = webView;
    
    [self.view insertSubview:_webView belowSubview:progressView];

    [self loadingWebWihtURLString];
    
    ///加工具栏
    [self.view addSubview:self.toolbar];
    
}


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
    
    [_webView loadRequest:requestUrl];

    
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
                    if (![self.webView.request.URL.absoluteString isEqualToString:urlStr]) {

//                        WKBackForwardList *list = self.webView.backForwardList;
//                        if (list.backList.firstObject) {
//                            [self.wkWebView goToBackForwardListItem:list.backList.firstObject];
//                        }
                        self.urlStr = urlStr;
                        [self loadingWebWihtURLString];
                    }
                }
                    break;
                    
                case DYWebBtnTypeRefresh:
                {
                    [self.webView reload];
                }
                    break;
                    
                case DYWebBtnTypeBack:
                {
                    if (self.webView.canGoBack) {
                        [self.webView goBack];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                    break;
                    
                case DYWebBtnTypeNext:
                {
                    if (self.webView.canGoForward) {
                        [self.webView goForward];
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


#pragma mark - delegate -

-(void) webViewDidStartLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"加载完成－－－");
    
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //获取当前页面的title
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title====%@",title);
    
    //获取当前URL
    NSString *URL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"URL===%@",URL);
    
    //得到网页代码
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML" ];
    NSLog(@"html====%@",html);// document.documentElement.textContent
    
    //拼接字符串 根据网页name找到控价并赋值
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"加载失败＝＝＝%@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    // 如果是被取消，什么也不干
    if([error code] == NSURLErrorCancelled)  {
        return;
    }

    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:@"An error occurred:%@",error.localizedDescription];
    [self.webView loadHTMLString:errorString baseURL:nil];
    
}


#pragma mark - 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
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
    [self.webView removeFromSuperview];
    self.webView = nil;
    
    NSLog(@"-----------------------------------dealloc:%@", self.class);
    
}


@end
