//
//  MailListVC.m
//  TestEmail
//
//  Created by Jack on 2017/8/10.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "MailListVC.h"
#import "MailCell.h"
#import "JKPOPMail.h"
#import "ViewController.h"
#import "JKIMAPMail.h"
#import "JKSMTPMailSender.h"
#import "SendEmailVC.h"

@interface MailListVC ()<UITableViewDelegate,UITableViewDataSource,JKPOPMailOperationHandler,JKIMAPMailHandler>

@property (strong, nonatomic) IBOutlet UITableView *mailTable;
@property (nonatomic,strong) NSMutableArray *mails;
@property (nonatomic,strong) JKPOPMail *pop;
@property (nonatomic,strong) JKIMAPMail *imap;


@end

@implementation MailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mails = [NSMutableArray array];
    
//    self.pop = [JKPOPMail popMailHostName:@"pop.qq.com" port:995];
//    self.pop.delegate = self;
//    [self.pop login:@"676034689@qq.com" password:@"xxxxxx123456789"];

    
//    JKIMAPMail *imap = [JKIMAPMail imapMailHostName:@"imap.qq.com" port:993];
//    self.imap = imap;
//    self.imap.delegate = self;
//    [imap login:@"676034689@qq.com" password:@"xxxxxx123456789"];

    
    
//    JKSMTPMailSender *sender = [JKSMTPMailSender smtpSenderHost:@"smtp.qq.com" port:587];
//
//    [sender loginAddress:@"676034689@qq.com" password:@"xxxxxx123456789"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MCOMessageParser *msg = [self.mails objectAtIndex:indexPath.row];
    
    [self setupCell:cell withMessage:msg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)setupCell:(MailCell *)cell withMessage:(MCOMessageParser *)messages {
    
    // MCOMessageHeader包含了邮件标题，时间等头信息
    MCOMessageHeader *header = messages.header;
    
    cell.senderLB.text = [NSString stringWithFormat:@"%@ (%@)",header.from.displayName,header.from.mailbox];
    
    cell.subjectLB.text = header.subject;
    
    cell.attach.hidden = messages.attachments.count <= 0;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCOMessageParser *msg = [self.mails objectAtIndex:indexPath.row];
    
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.msg = msg;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)handleLogin:(BOOL)login {
    if (login) {
        [self.pop fethMessages];
    }
}

- (void) handleFetchMessage:(MCOMessageParser *)message {
    [self.mails addObject:message];
    [self.mailTable reloadData];
}


- (IBAction)penBtnClick:(UIButton *)sender {
    
    SendEmailVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SendEmailVC"];
    
    [self presentViewController:vc animated:YES completion:nil];
}


@end
