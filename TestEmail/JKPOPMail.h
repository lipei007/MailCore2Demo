//
//  JKPOPMail.h
//  TestEmail
//
//  Created by Jack on 2017/8/10.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

@protocol JKPOPMailOperationHandler <NSObject>

@optional

-(void) handleLogin:(BOOL)login;

- (void) handleFetchMessage:(MCOMessageParser *)message;

@end


@interface JKPOPMail : NSObject

@property (nonatomic,weak) id<JKPOPMailOperationHandler> delegate;

+ (instancetype)popMailHostName:(NSString *)host port:(unsigned int)port;

- (void)login:(NSString *)emailAddress password:(NSString *)password;

- (void)fethMessages;

@end
