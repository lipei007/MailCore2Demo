//
//  MailCell.h
//  TestEmail
//
//  Created by Jack on 2017/8/10.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *attach;
@property (strong, nonatomic) IBOutlet UILabel *senderLB;
@property (strong, nonatomic) IBOutlet UILabel *subjectLB;

@end
