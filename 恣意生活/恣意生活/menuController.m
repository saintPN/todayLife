//
//  KLNewsMenuController.m
//  KnowingLife
//
//  Created by tanyang on 14/11/6.
//  Copyright (c) 2014年 tany. All rights reserved.
//

#import "menuController.h"
#import "REMenu.h"
#import "newsViewController.h"


@interface menuController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) REMenu *menu;

@end


#define fenghuangURL @"http://news.ifeng.com"
#define tengxunURL   @"http://news.qq.com"
#define baiduURL     @"http://news.baidu.com"
#define sinaURL      @"http://news.sina.com.cn"
#define sohuURL      @"http://news.sohu.com"


@implementation menuController

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = [UIImage imageNamed:@"心情"];
    [self setupMenuView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self.menu isOpen]) {
        [self.menu showFromNavigationController:self.navigationController];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self.menu isOpen]) {
        [self.menu close];
    }
}

#pragma mark - 导航栏按钮事件

- (IBAction)showMenu:(UIBarButtonItem *)sender {
    if (![self.menu isOpen]) {
        [self.menu showInView:self.view];
    } else {
        [self.menu close];
    }
}

#pragma mark - 设置下拉菜单

- (void)setupMenuView {
    __typeof (self) __weak weakSelf = self;
    REMenuItem *fenghuangItem = [[REMenuItem alloc] initWithTitle:@"凤凰新闻"
                                                         subtitle:@"提供重大新闻资讯"
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                               [weakSelf pushViewControllerWithUrl:fenghuangURL];
                                                           }];
    REMenuItem *tengxunItem = [[REMenuItem alloc] initWithTitle:@"腾讯新闻"
                                                       subtitle:@"新闻事实派"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [weakSelf pushViewControllerWithUrl:tengxunURL];
                                                         }];
    REMenuItem *baiduItem = [[REMenuItem alloc] initWithTitle:@"百度新闻"
                                                     subtitle:@"真实反映新闻热点"
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [weakSelf pushViewControllerWithUrl:baiduURL];
                                                       }];
    REMenuItem *sinaItem = [[REMenuItem alloc] initWithTitle:@"新浪新闻"
                                                    subtitle:@"滚动报道社会新闻"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [weakSelf pushViewControllerWithUrl:sinaURL];
                                                      }];
    REMenuItem *sohuItem = [[REMenuItem alloc] initWithTitle:@"搜狐新闻"
                                                    subtitle:@"不间断的最新资讯"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [weakSelf pushViewControllerWithUrl:sohuURL];
                                                      }];
    
    
    self.menu = [[REMenu alloc] initWithItems:@[fenghuangItem, tengxunItem, baiduItem, sinaItem,sohuItem]];
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    self.menu.textColor = [UIColor whiteColor];
    self.menu.subtitleTextColor = [UIColor whiteColor];
    
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)pushViewControllerWithUrl:(NSString *)url {
    newsViewController *nvc = [[newsViewController alloc]init];
    nvc.url = url;
    [self.navigationController pushViewController:nvc animated:YES];
}
















@end
