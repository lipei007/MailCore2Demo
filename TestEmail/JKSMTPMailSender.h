//
//  JKSMTPMailSender.h
//  TestEmail
//
//  Created by Jack on 2017/8/11.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

@interface JKSMTPMailSender : NSObject

+ (instancetype)smtpSenderHost:(NSString *)host port:(unsigned int)port;

- (void)loginAddress:(NSString *)emailAddress password:(NSString *)password;

- (void)testSend;

- (void)sendEmail:(NSString *)htmlBody attachments:(NSArray *)attachments subject:(NSString *)subject to:(NSArray *)to cc:(NSArray *)cc bcc:(NSArray *)bcc completion:(void(^)(NSError *error)) handler;


@end
