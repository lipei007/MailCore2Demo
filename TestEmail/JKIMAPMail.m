//
//  JKIMAPMail.m
//  TestEmail
//
//  Created by Jack on 2017/8/11.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "JKIMAPMail.h"


@interface JKIMAPMail ()

@property (nonatomic,assign) BOOL authorized;
@property (nonatomic,strong) MCOIMAPSession *session;

@property (nonatomic,copy) NSString *host;
@property (nonatomic,assign) unsigned int port;

@end

@implementation JKIMAPMail

+ (instancetype)imapMailHostName:(NSString *)host port:(unsigned int)port {
    JKIMAPMail *mail = [[JKIMAPMail alloc] init];
    mail.host = host;
    mail.port = port;
    
    return mail;
}

- (void)login:(NSString *)emailAddress password:(NSString *)password {
    
    self.session = [[MCOIMAPSession alloc] init];
    
    self.session.hostname = self.host;
    self.session.port = self.port;
    self.session.username = emailAddress;
    self.session.password = password;
    self.session.connectionType = MCOConnectionTypeTLS;
    [self.session setCheckCertificateEnabled:NO];
    
    MCOIMAPOperation *imapOperation = [self.session checkAccountOperation];
    [imapOperation start:^(NSError * __nullable error) {
        if (error == nil) {
            NSLog(@"login account successed\n");
            
            self.authorized = YES;
            // 在这里获取邮件，获取文件夹信息
            [self loadIMAPFolder];
            
        } else {
            NSLog(@"login account failure: %@\n", error);
        }  
    }];
}

- (void)loadIMAPFolder {
    MCOIMAPFetchFoldersOperation *imapFetchFolderOp = [self.session fetchAllFoldersOperation];
    [imapFetchFolderOp start:^(NSError * error, NSArray * folders) {
        
        for (MCOIMAPFolder *folder in folders) {
            NSLog(@"folder: %@ delimiter: %c flags: %ld",folder.path,folder.delimiter,folder.flags);
        }
        [self getInBoxFolder];
    }];
}

- (void)getInBoxFolder {
    
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
    (MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
     MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
     MCOIMAPMessagesRequestKindFlags);
    
    // 获取收件箱信息（包含邮件总数等信息）
    NSString *folderName = @"INBOX";
    MCOIMAPFolderInfoOperation * folderInfoOperation = [self.session folderInfoOperation:folderName];
    [folderInfoOperation start:^(NSError *error, MCOIMAPFolderInfo * info) {
        
        NSLog(@"total number: %d", info.messageCount);
        
        NSInteger numberOfMessages = 10;
        numberOfMessages -= 1;
        MCOIndexSet *numbers = [MCOIndexSet indexSetWithRange:MCORangeMake([info messageCount] - numberOfMessages, numberOfMessages)];
        
        MCOIMAPFetchMessagesOperation *imapMessagesFetchOp = [self.session fetchMessagesByNumberOperationWithFolder:folderName
                                                                                                       requestKind:requestKind
                                                                                                           numbers:numbers];
        
        // 异步获取邮件
        [imapMessagesFetchOp start:^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages) {
           
            for (MCOIMAPMessage *msg in messages) {
                [self getEmailContent:msg folder:folderName];
            }
            
        }];
    }];
}

- (void)getEmailContent:(MCOIMAPMessage *)msg folder:(NSString *)folder {
    
    MCOIMAPFetchContentOperation * fetchContentOp = [self.session fetchMessageOperationWithFolder:folder uid:[msg uid]];
    
    [fetchContentOp start:^(NSError * error, NSData * data) {
        if ([error code] != MCOErrorNone) {
            return;
        }
        // 解析邮件内容
        MCOMessageParser * msgPareser = [MCOMessageParser messageParserWithData:data];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleFetchMessage:)]) {
            [self.delegate handleFetchMessage:msgPareser];
        }
        
    }];
}

@end
