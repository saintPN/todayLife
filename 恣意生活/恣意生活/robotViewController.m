//
//  robotViewController.m
//  恣意生活
//
//  Created by saintPN on 15/7/22.
//  Copyright (c) 2015年 saintPN. All rights reserved.
//

#import "robotViewController.h"


@interface robotViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSDictionary *dict;

@end


@implementation robotViewController

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮事件

- (IBAction)ask:(UIButton *)sender {
    if (self.textField.text) {
        NSString *httpUrl = @"http://www.tuling123.com/openapi/api";
        NSString *httpArg1 = @"key=becf904056ba4a4d6f81fa2b6bcf9696";
        NSString *httpArg2 = [NSString stringWithFormat:@"info=%@",self.textField.text];
        NSString *httpArg3 = @"userid=pns55891";
        [self request:httpUrl withHttpArg1:httpArg1 withHttpArg2:httpArg2 withHttpArg2:httpArg3];
    }
    [self.textField resignFirstResponder];
}

- (IBAction)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.textField resignFirstResponder];
}

#pragma mark - 导航栏按钮事件

- (IBAction)show:(UIBarButtonItem *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"图灵机器人"
                                                                   message:@"像真人一样和你对答如流，并且超多实用查询功能:新闻、火车、飞机等等不在话下!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 数据请求

-(void)request:(NSString*)httpUrl withHttpArg1:(NSString*)HttpArg1 withHttpArg2:(NSString*)HttpArg2 withHttpArg2:(NSString*)HttpArg3  {
    __typeof (self) __weak weakSelf = self;
    
    //配置网络请求
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@&%@&%@", httpUrl,HttpArg1,HttpArg2,HttpArg3];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    
    //发起网络请求,处理返回数据
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (data) {
            weakSelf.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            // 判断返回数据类型并做相应处理
            if ([weakSelf.dict[@"code"] isEqualToNumber:[NSNumber numberWithUnsignedLong:100000]]) {
                
                weakSelf.textView.text = weakSelf.dict[@"text"];
                
            } else if ([weakSelf.dict[@"code"] isEqualToNumber:[NSNumber numberWithUnsignedLong:200000]]) {
                
                weakSelf.textView.text = [NSString stringWithFormat:@"%@,网址:%@", weakSelf.dict[@"txt"],weakSelf.dict[@"url"]];
                
            } else if ([weakSelf.dict[@"code"] isEqualToNumber:[NSNumber numberWithUnsignedLong:302000]]) {
                
                weakSelf.textView.text = [NSString stringWithFormat:@"%@,标题:%@,来源:%@,详情地址:%@",
                                          weakSelf.dict[@"txt"],
                                          weakSelf.dict[@"list"][@"article"],
                                          weakSelf.dict[@"list"][@"source"],
                                          weakSelf.dict[@"list"][@"detailurl"]];
                
            } else if ([weakSelf.dict[@"code"] isEqualToNumber:[NSNumber numberWithUnsignedLong:305000]]) {
                
                weakSelf.textView.text = [NSString stringWithFormat:@"%@,车次:%@,始发站:%@,终点站:%@,始发时间:%@,终点时间:%@,详情地址:%@",
                                          weakSelf.dict[@"txt"],
                                          weakSelf.dict[@"list"][@"trainnum"],
                                          weakSelf.dict[@"list"][@"start"],
                                          weakSelf.dict[@"list"][@"terminal"],
                                          weakSelf.dict[@"list"][@"starttime"],
                                          weakSelf.dict[@"list"][@"endtime"],
                                          weakSelf.dict[@"list"][@"detailurl"]];
                
            } else if ([weakSelf.dict[@"code"] isEqualToNumber:[NSNumber numberWithUnsignedLong:306000]]) {
                
                weakSelf.textView.text = [NSString stringWithFormat:@"%@,航班:%@,路线:%@,起飞时间:%@,着陆时间:%@,状态:%@,详情地址:%@,",
                                          weakSelf.dict[@"txt"],
                                          weakSelf.dict[@"list"][@"flight"],
                                          weakSelf.dict[@"list"][@"route"],
                                          weakSelf.dict[@"list"][@"starttime"],
                                          weakSelf.dict[@"list"][@"endtime"],
                                          weakSelf.dict[@"list"][@"state"],
                                          weakSelf.dict[@"list"][@"detailurl"]];
                
            }  else if ([weakSelf.dict[@"code"] isEqualToNumber:[NSNumber numberWithUnsignedLong:308000]]) {
                
                weakSelf.textView.text = [NSString stringWithFormat:@"%@,名称:%@,详情:%@,详情地址:%@",
                                          weakSelf.dict[@"txt"],
                                          weakSelf.dict[@"list"][@"name"],
                                          weakSelf.dict[@"list"][@"info"],
                                          weakSelf.dict[@"list"][@"detailurl"]];
                
            }

        } else {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"机器人图灵开小差去了!"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好吧" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

@end
