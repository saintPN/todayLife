//
//  weatherViewController.m
//  恣意生活
//
//  Created by saintPN on 15/7/16.
//  Copyright (c) 2015年 saintPN. All rights reserved.
//

#import "weatherViewController.h"
#import "TableViewCell.h"


@interface weatherViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *wordLabel;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UILabel *leftLabel;

@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic) IBOutlet UITableView *weatherTableView;

@property (strong, nonatomic) NSDictionary *basicDictionary;

@property (strong, nonatomic) NSDictionary *nowDictionary;

@property (strong, nonatomic) NSArray *forecastArray;

@property (strong, nonatomic) NSString *localString;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end


@implementation weatherViewController

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"clound"];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageview.image = image;
    [self.view insertSubview:imageview atIndex:0];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.weatherTableView registerNib:nib forCellReuseIdentifier:@"TableViewCell"];
    self.weatherTableView.dataSource = self;
    self.weatherTableView.delegate = self;
    self.weatherTableView.backgroundColor = [UIColor clearColor];
    [self setupActivityIndicator];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.localString = [defaults stringForKey:@"localString"];
    if (self.localString) {
        NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
        NSString *httpArg = [NSString stringWithFormat:@"city=%@", self.localString];
        [self request: httpUrl withHttpArg: httpArg];
    } else {
        NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
        NSString *httpArg = @"city=guangzhou";
        [self request: httpUrl withHttpArg: httpArg];
    }
    
    [self wordrequest];
}

//  ios8取消tableview分隔线左留空
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if ([self.weatherTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.weatherTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.weatherTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.weatherTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self wordrequest];
}


#pragma mark - 天气数据请求

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    __typeof (self) __weak weakSelf = self;
    
    [self.indicator startAnimating];
    
    //配置网络请求
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"ee94c3ee2c0d20a52136a187d51e5557" forHTTPHeaderField: @"apikey"];
    
    //发起网络请求,处理返回数据
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
    
            if (error) {
                
                NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                
            } else {
                
                NSDictionary *rawDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSDictionary *ripeDictionary = [rawDictionary[@"HeWeather data service 3.0"] firstObject];
                
                weakSelf.basicDictionary = ripeDictionary[@"basic"];
                weakSelf.nowDictionary = ripeDictionary[@"now"];
                weakSelf.forecastArray = ripeDictionary[@"daily_forecast"];
                
                weakSelf.iconImageView.image = [UIImage imageNamed:weakSelf.nowDictionary[@"cond"][@"code"]];
                weakSelf.leftLabel.text = weakSelf.basicDictionary[@"city"];
                weakSelf.rightLabel.text = [NSString stringWithFormat:@"%@", weakSelf.nowDictionary[@"cond"][@"txt"]];
                [weakSelf.weatherTableView reloadData];
                
                [self.indicator stopAnimating];
            }
    }];
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text) {
        NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
        NSString *httpArg = [NSString stringWithFormat:@"city=%@", textField.text];
        [self request: httpUrl withHttpArg: httpArg];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:textField.text forKey:@"localString"];
    }
}

#pragma mark - 文字数据请求

- (void)wordrequest {
    __typeof (self) __weak weakSelf = self;
        
    //配置网络请求
    NSString *urlStr = @"http://hello.api.235dns.com/api.php?code=json&key=bd95866ed42b6a915158980e9b9bda61";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    
    //发起网络请求,处理返回数据
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            
            NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
            
        } else {
            
            NSDictionary *rawDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            weakSelf.wordLabel.text = rawDictionary[@"words"];
            
        }
    }];
    
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forecastArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    if (self.forecastArray) {
        
        cell.backgroundColor = [UIColor clearColor];
        NSDictionary *dictionary = self.forecastArray[indexPath.row];
        if (indexPath.row == 0) {
            
            if (dictionary[@"cond"][@"code_d"]) {
                
                cell.dateLabel.textColor = [UIColor whiteColor];
                cell.tmpLabel.textColor = [UIColor whiteColor];
                cell.txtLabel.textColor = [UIColor whiteColor];
                cell.dateLabel.text = @"现在";
                cell.cellIcon.image = [UIImage imageNamed:dictionary[@"cond"][@"code_d"]];
                cell.txtLabel.text = [NSString stringWithFormat:@"%@",dictionary[@"cond"][@"txt_d"]];
                cell.tmpLabel.text = [NSString stringWithFormat:@"%@℃/%@℃", dictionary[@"tmp"][@"max"],dictionary[@"tmp"][@"min"]];
                
            } else {
                
                cell.dateLabel.textColor = [UIColor whiteColor];
                cell.tmpLabel.textColor = [UIColor whiteColor];
                cell.txtLabel.textColor = [UIColor whiteColor];
                cell.dateLabel.text = @"现在";
                cell.cellIcon.image = [UIImage imageNamed:dictionary[@"cond"][@"code_n"]];
                cell.txtLabel.text = [NSString stringWithFormat:@"%@",dictionary[@"cond"][@"txt_n"]];
                cell.tmpLabel.text = [NSString stringWithFormat:@"%@℃/%@℃", dictionary[@"tmp"][@"max"],dictionary[@"tmp"][@"min"]];
                
            }

        } else {
            
            if (dictionary[@"cond"][@"code_d"]) {
                
                cell.dateLabel.text = [dictionary[@"date"] substringFromIndex:5];
                cell.cellIcon.image = [UIImage imageNamed:dictionary[@"cond"][@"code_d"]];
                cell.txtLabel.text = [NSString stringWithFormat:@"%@",dictionary[@"cond"][@"txt_d"]];
                cell.tmpLabel.text = [NSString stringWithFormat:@"%@℃/%@℃", dictionary[@"tmp"][@"max"],dictionary[@"tmp"][@"min"]];
                
            } else {
                
                cell.dateLabel.text = [dictionary[@"date"] substringFromIndex:5];
                cell.cellIcon.image = [UIImage imageNamed:dictionary[@"cond"][@"code_n"]];
                cell.txtLabel.text = [NSString stringWithFormat:@"%@",dictionary[@"cond"][@"txt_n"]];
                cell.tmpLabel.text = [NSString stringWithFormat:@"%@℃/%@℃", dictionary[@"tmp"][@"max"],dictionary[@"tmp"][@"min"]];
                
            }

            
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.weatherTableView cellForRowAtIndexPath: indexPath ];

    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator | UITableViewCellAccessoryCheckmark;

}

#pragma mark - 导航栏按钮事件

- (IBAction)showAlert:(UIBarButtonItem *)sender {
    __typeof (self) __weak weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入城市拼音" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        [textField addTarget:weakSelf action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"搜索" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self.indicator startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.localString = [defaults stringForKey:@"localString"];
    if (self.localString) {
        NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
        NSString *httpArg = [NSString stringWithFormat:@"city=%@", self.localString];
        [self request: httpUrl withHttpArg: httpArg];
    } else {
        NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
        NSString *httpArg = @"city=guangzhou";
        [self request: httpUrl withHttpArg: httpArg];
    }
    
    [self.indicator stopAnimating];
}

#pragma mark - 提示器

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

@end
