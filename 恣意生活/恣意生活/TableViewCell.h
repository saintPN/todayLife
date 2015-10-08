//
//  TableViewCell.h
//  恣意生活
//
//  Created by saintPN on 15/7/17.
//  Copyright (c) 2015年 saintPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIImageView *cellIcon;

@property (strong, nonatomic) IBOutlet UILabel *txtLabel;

@property (strong, nonatomic) IBOutlet UILabel *tmpLabel;

@end
