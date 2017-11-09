//
//  JKIMAPMail.h
//  TestEmail
//
//  Created by Jack on 2017/8/11.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

@protocol JKIMAPMailHandler <NSObject>

@optional
- (void)handleFetchMessage:(MCOMessageParser *)msg;

@end

@interface JKIMAPMail : NSObject

@property (nonatomic,weak) id<JKIMAPMailHandler> delegate;

+ (instancetype)imapMailHostName:(NSString *)host port:(unsigned int)port;

- (void)login:(NSString *)emailAddress password:(NSString *)password;

@end
