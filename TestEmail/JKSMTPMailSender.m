//
//  JKSMTPMailSender.m
//  TestEmail
//
//  Created by Jack on 2017/8/11.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKSMTPMailSender.h"

@interface JKSMTPMailSender ()

@property (nonatomic,assign) BOOL authorized;
@property (nonatomic,strong) MCOSMTPSession *session;

@property (nonatomic,copy) NSString *host;
@property (nonatomic,assign) unsigned int port;

@end

@implementation JKSMTPMailSender

+ (instancetype)smtpSenderHost:(NSString *)host port:(unsigned int)port {
    JKSMTPMailSender *smtp = [[JKSMTPMailSender alloc] init];
    
    smtp.host = host;
    smtp.port = port;
    
    return smtp;
}

- (void)loginAddress:(NSString *)emailAddress password:(NSString *)password {
    
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = self.host;
    smtpSession.port = self.port;
    smtpSession.username = emailAddress;
    smtpSession.password = password;
    smtpSession.connectionType = MCOConnectionTypeStartTLS;
    [self.session setCheckCertificateEnabled:NO];
    
    self.session = smtpSession;
    
    MCOSMTPOperation *smtpOperation = [self.session loginOperation];
    [smtpOperation start:^(NSError * error) {
        if (error == nil) {
            NSLog(@"login account successed");
            self.authorized = YES;
//            [self testSend];
        } else {
            self.authorized = NO;
            NSLog(@"login account failure: %@", error);
        }  
    }];
}


- (void)testSend {

    //来自
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc]init];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:@"Li ei" mailbox:@"676034689@qq.com"]];
    
    //接收
    NSArray *toArray = @[@"Jack.Li@qq.net"];
    if(toArray){
        NSMutableArray *to = [[NSMutableArray alloc]init];
        for (NSString *item in toArray) {
            [to addObject:[MCOAddress addressWithMailbox:item]];
        }
        [[builder header] setTo:to]; 
    }
    
    //抄送
    NSArray *ccArray = @[@"emerys.lee@qq.com"];
    if(ccArray){
        NSMutableArray *cc = [[NSMutableArray alloc]init];
        for (NSString *item in ccArray) {
            [cc addObject:[MCOAddress addressWithMailbox:item]];
        }
        [[builder header] setCc:cc];
    }

    //密送
    NSArray *bccArray = nil;
    if(bccArray){
        NSMutableArray *bcc = [[NSMutableArray alloc]init];
        for (NSString *item in ccArray) {
            [bcc addObject:[MCOAddress addressWithMailbox:item]];
        }
        [[builder header] setBcc:bcc];
    }
    
    //主题
    [[builder header] setSubject:@"Test Send"];
    
    // 邮件阅读回执
    [[builder header] setExtraHeaderValue:@"676034689@qq.com" forName:@"Disposition-Notification-To"];
    [[builder header] setExtraHeaderValue:@"1" forName:@"ReturnReceipt"];
    
    //内容
    [builder setHTMLBody:@"<div style=\"padding-bottom: 20px;\"></div><div><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><title></title></head><body><div style=\"font:14px/1.5 'Lucida Grande', '微软雅黑';color:#333;\"><div style=\"font:14px/1.5 'Lucida Grande', '微软雅黑';color:#333;\"><div style=\"font:14px/1.5 'Lucida Grande', '微软雅黑';color:#333;\">危乎高哉。蜀道之难难于上青天<div><br /></div><div><img src=\"cid:EC5695EFA3AE6FBF0A1E04BEC0DDAC03\" modifysize=\"82%\" style=\"width: 841px; height: 841px;\" class="" /></div></div></div></div></body></html>"];
    
    // 附件
    MCOAttachment *attachment = [MCOAttachment attachmentWithContentsOfFile:@"/Users/macmini1/Downloads/redAnt.png"];
    attachment.contentID = @"EC5695EFA3AE6FBF0A1E04BEC0DDAC03";
    [builder setAttachments:@[attachment]];
    
    NSData *rfc822Data = [builder data];
    MCOSMTPSendOperation *sendOperation = [self.session sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError *error) {
        
        if (error) {
            NSLog(@"send failed");
        } else {
            NSLog(@"send successful");
        }
        
    }];
}

- (void)sendEmail:(NSString *)htmlBody attachments:(NSArray *)attachments subject:(NSString *)subject to:(NSArray *)to cc:(NSArray *)cc bcc:(NSArray *)bcc completion:(void (^)(NSError *error)) handler {
    
    //来自
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc]init];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:@"" mailbox:self.session.username]];
    
    //接收
    if(to){
        NSMutableArray *toArr = [[NSMutableArray alloc]init];
        for (NSString *item in to) {
            [toArr addObject:[MCOAddress addressWithMailbox:item]];
        }
        [[builder header] setTo:toArr];
    }
    
    //抄送
    if(cc){
        NSMutableArray *ccArr = [[NSMutableArray alloc]init];
        for (NSString *item in cc) {
            [ccArr addObject:[MCOAddress addressWithMailbox:item]];
        }
        [[builder header] setCc:ccArr];
    }
    
    //密送
    if(bcc){
        NSMutableArray *bccArr = [[NSMutableArray alloc]init];
        for (NSString *item in bcc) {
            [bccArr addObject:[MCOAddress addressWithMailbox:item]];
        }
        [[builder header] setBcc:bccArr];
    }
    
    //主题
    [[builder header] setSubject:subject];
    
    // 邮件阅读回执
    [[builder header] setExtraHeaderValue:self.session.username forName:@"Disposition-Notification-To"];
    [[builder header] setExtraHeaderValue:@"1" forName:@"ReturnReceipt"];
    
    //内容
    [builder setHTMLBody:htmlBody];
    
    // 附件
    [builder setAttachments:attachments];
    
    NSData *rfc822Data = [builder data];
    MCOSMTPSendOperation *sendOperation = [self.session sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError *error) {
        
        if (handler) {
            handler(error);
        }
        
        
    }];
    
}

@end
