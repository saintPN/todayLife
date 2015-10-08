//
//  KLNewsViewController.m
//  KnowingLife
//
//  Created by tanyang on 14/10/28.
//  Copyright (c) 2014年 tany. All rights reserved.
//

#import "newsViewController.h"
#import "REMenu.h"


@interface newsViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, strong) REMenu *menu;

@property (nonatomic, weak) UIActivityIndicatorView* indicator;

@end


#define fenghuangURL @"http://news.ifeng.com"
#define tengxunURL   @"http://news.qq.com"
#define baiduURL     @"http://news.baidu.com"
#define sinaURL      @"http://news.sina.com.cn"
#define sohuURL      @"http://news.sohu.com"


@implementation newsViewController

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-left-frame"] style:UIBarButtonItemStylePlain target:self action:@selector(Canccel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toggle-down"] style:UIBarButtonItemStylePlain target:self action:@selector(selectMoreNews)];
    
    self.title = @"今日新闻";
    [self setupMenuView];
    [self setupWebview];
    [self setupActivityIndicator];
    [self loadWebViewUrl:self.url];
    
}

#pragma mark - 网络相关控件设置

- (void)setupMenuView {
    __typeof (self) __weak weakSelf = self;
    REMenuItem *fenghuangItem = [[REMenuItem alloc] initWithTitle:@"凤凰新闻"
                                                         subtitle:@"提供重大新闻资讯"
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               [weakSelf loadWebViewUrl:fenghuangURL];
                                                           }];
    REMenuItem *tengxunItem = [[REMenuItem alloc] initWithTitle:@"腾讯新闻"
                                                       subtitle:@"新闻事实派"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [weakSelf loadWebViewUrl:tengxunURL];
                                                         }];
    REMenuItem *baiduItem = [[REMenuItem alloc] initWithTitle:@"百度新闻"
                                                     subtitle:@"真实反映新闻热点"
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [weakSelf loadWebViewUrl:baiduURL];
                                                       }];
    REMenuItem *sinaItem = [[REMenuItem alloc] initWithTitle:@"新浪新闻"
                                                    subtitle:@"滚动报道社会新闻"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [weakSelf loadWebViewUrl:sinaURL];
                                                      }];
    REMenuItem *sohuItem = [[REMenuItem alloc] initWithTitle:@"搜狐新闻"
                                                    subtitle:@"不间断的最新资讯"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [weakSelf loadWebViewUrl:sohuURL];
                                                      }];
    
    self.menu = [[REMenu alloc] initWithItems:@[fenghuangItem, tengxunItem, baiduItem, sinaItem,sohuItem]];
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    self.menu.textColor = [UIColor whiteColor];
    self.menu.subtitleTextColor = [UIColor whiteColor];
}

- (void)setupWebview {
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    self.webView = webView;
    self.webView.delegate = self;
}

- (void)setupActivityIndicator {
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    indicator.backgroundColor = [UIColor grayColor];
    indicator.alpha = 0.5;
    indicator.layer.cornerRadius = 6;
    indicator.layer.masksToBounds = YES;
    
    [self.view addSubview:indicator];
    self.indicator = indicator;
    self.indicator.hidden = YES;
}

- (void)loadWebViewUrl:(NSString *)strUrl {
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

#pragma mark - 导航栏按钮事件

- (void)Canccel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectMoreNews {
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self.navigationController];
}

#pragma mark - webview代理

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView; {
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;

}


@end
