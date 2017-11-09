//
//  JKPOPMail.m
//  TestEmail
//
//  Created by Jack on 2017/8/10.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKPOPMail.h"
#import <MailCore/MailCore.h>

@interface JKPOPMail ()

@property (nonatomic,assign) BOOL authorized;
@property (nonatomic,strong) MCOPOPSession *session;

@property (nonatomic,copy) NSString *host;
@property (nonatomic,assign) unsigned int port;

@end

@implementation JKPOPMail

+ (instancetype)popMailHostName:(NSString *)host port:(unsigned int)port {
    JKPOPMail *pop = [[JKPOPMail alloc] init];
    pop.host = host;
    pop.port = port;
    
    return pop;
}

- (void)login:(NSString *)emailAddress password:(NSString *)password {
    
    if (self.session == nil) {
        self.session = [[MCOPOPSession alloc] init];
    }
    self.session.hostname = self.host;
    self.session.port = self.port;
    self.session.username = emailAddress;
    self.session.password = password;
    self.session.connectionType = MCOConnectionTypeTLS;
    [self.session setCheckCertificateEnabled:NO];
    self.session.authType = MCOAuthTypeXOAuth2;
    
    // 登录邮箱
    MCOPOPOperation *popOperation = [self.session checkAccountOperation];
    
    // 开启异步请求，检查目前该配置是否能正确登录邮箱
    [popOperation start:^(NSError * __nullable error) {
        if (error == nil) {
            NSLog(@"login account successed");
            
            self.authorized = YES;
            
        } else {
            NSLog(@"login account failure: %@", error);
            
            self.authorized = NO;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleLogin:)]) {
            [self.delegate handleLogin:self.authorized];
        }
        
    }];

}

- (void)fethMessages {
    if (!self.authorized || self.session == nil) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    // 获取最新20封邮件头，与之前获取邮件最大uid做对比，有差值，则同步新数据
    MCOPOPFetchMessagesOperation *op = [self.session fetchMessagesOperation];
    [op start:^(NSError * _Nullable error, NSArray * _Nullable messages) {
        if (!error) {
            
            for (MCOPOPMessageInfo *info in messages) {
                
                [weakself fethMessageWithIndex:info.index];
                
            }
            
        }
    }];
    
}

- (void)fethMessageWithIndex:(unsigned int)index {
    
    __weak typeof(self) weakself = self;
    MCOPOPFetchMessageOperation *msgOp = [self.session fetchMessageOperationWithIndex:index];
    [msgOp start:^(NSError * _Nullable error, NSData * _Nullable messageData) {
        
        if (!error) {
            MCOMessageParser * msgPaser =[MCOMessageParser messageParserWithData:messageData];
            [weakself parseMessage:msgPaser];
        }
    }];

}

- (void)parseMessage:(MCOMessageParser *)msgParser {


    if (self.delegate && [self.delegate respondsToSelector:@selector(handleFetchMessage:)]) {
        [self.delegate handleFetchMessage:msgParser];
    }
    
    
}

@end
