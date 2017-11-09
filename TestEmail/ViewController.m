//
//  ViewController.m
//  TestEmail
//
//  Created by Jack on 2017/8/9.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "ViewController.h"
#import <MailCore/MailCore.h>

@interface ViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *senderLB;
@property (strong, nonatomic) IBOutlet UILabel *receiverLB;
@property (strong, nonatomic) IBOutlet UILabel *ccLB;
@property (strong, nonatomic) IBOutlet UILabel *timeLB;
@property (strong, nonatomic) IBOutlet UIWebView *contentWeb;
@property (strong, nonatomic) IBOutlet UILabel *subjectLB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.contentWeb.delegate = self;
    self.contentWeb.scrollView.bounces = NO;
    
    if (self.msg) {
        [self handleFetchMessage:self.msg];
    }
}

- (IBAction)backClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"err: %@",error);
}



- (void)handleFetchMessage:(MCOMessageParser *)messages {
    // MCOMessageHeader包含了邮件标题，时间等头信息
    MCOMessageHeader *header = messages.header;
    
    // 发件人
    self.senderLB.text = [NSString stringWithFormat:@"%@ (%@)",header.from.displayName,header.from.mailbox];
    
    // 收件人
    NSMutableString *toStr = [NSMutableString string];
    NSArray *to = header.to;
    for (int i = 0; i < to.count; i++) {
        MCOAddress *addr = [to objectAtIndex:i];
        if (i == 0) {
            [toStr appendString:[NSString stringWithFormat:@"%@ (%@)",addr.displayName,addr.mailbox]];
        } else {
            [toStr appendString:[NSString stringWithFormat:@" , %@ (%@)",addr.displayName,addr.mailbox]];
        }
    }
    self.receiverLB.text = toStr;
    
    // 抄送
    NSMutableString *ccStr = [NSMutableString string];
    NSArray *cc = header.cc;
    for (int i = 0; i < cc.count; i++) {
        MCOAddress *addr = [cc objectAtIndex:i];
        if (i == 0) {
            [ccStr appendString:[NSString stringWithFormat:@"%@ (%@)",addr.displayName,addr.mailbox]];
        } else {
            [ccStr appendString:[NSString stringWithFormat:@" , %@ (%@)",addr.displayName,addr.mailbox]];
        }
    }
    self.ccLB.text = ccStr;
    
    // 日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月DD日 HH:mm:ss"];
    self.timeLB.text = [formatter stringFromDate:header.date];
    
    // Subject
    self.subjectLB.text = header.subject;
    
    // 获得邮件正文的HTML内容,一般使用webView加载
    NSString * bodyHtml = [messages htmlBodyRendering];
    
    // 处理附件（包括内容中的图片）
    if (messages.attachments.count > 0) {
        NSArray *attachments = messages.attachments;
        
        NSMutableArray *contentAttachments = [NSMutableArray array];
        NSMutableArray *realAttachment = [NSMutableArray array];
        for (int i = 0; i < attachments.count; i++) {

            MCOAttachment *attachment = [attachments objectAtIndex:i];
            NSString *attachment_filename = attachment.filename;
            
            NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *path = [dir stringByAppendingPathComponent:attachment_filename];
            
            [attachment.data writeToFile:path atomically:NO];
            
            if ([bodyHtml containsString:attachment.contentID]) {
                
                attachment.filename = path;
                [contentAttachments addObject:attachment];
                
            } else {
                [realAttachment addObject:attachment];
                
            }
            // 删除HTML中的附件描述
            NSString *fileName = [self convertChinese:attachment_filename]; // 校验中文
            NSRange range = [bodyHtml rangeOfString:fileName options:NSBackwardsSearch];
            NSRange divBegin = [bodyHtml rangeOfString:@"<div>" options:NSBackwardsSearch range:NSMakeRange(0, range.location)];
            NSRange divEnd = [bodyHtml rangeOfString:@"</div>" options:NSCaseInsensitiveSearch range:NSMakeRange(range.location, bodyHtml.length - range.location)];
            NSRange deleteRange = NSMakeRange(divBegin.location, divEnd.location - divBegin.location + divEnd.length);
            bodyHtml = [bodyHtml stringByReplacingCharactersInRange:deleteRange withString:@""];

        }
        
        /**
         处理附件
         */
        for (MCOAttachment *attachment in contentAttachments) {
            
        }
        
        // 将附件赋值到内容
        for (MCOAttachment *attachment in contentAttachments) {
            // web加载图片
            UIImage *img = [UIImage imageWithContentsOfFile:attachment.filename];
            NSData *imageData = UIImageJPEGRepresentation(img,1.0);
            NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
            bodyHtml = [bodyHtml stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"cid:%@",attachment.contentID] withString:imageSource];
        }

    }
    
    [self.contentWeb loadHTMLString:bodyHtml baseURL:nil];
}

- (NSString *)chineseToDDDDD:(NSString *)chinese {
    
    NSMutableString *value = [NSMutableString string];
    for (int i = 0; i < chinese.length; i++) {
        [value appendString:[NSString stringWithFormat:@"&#%hu;",[chinese characterAtIndex:i]]];
    }
    return value;

}

- (NSString *)convertChinese:(NSString *)str {
    
    NSMutableString *result = [NSMutableString string];
    for(int i=0; i< [str length];i++)
    {
        int a =[str characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            [result appendString:[self chineseToDDDDD:[str substringWithRange:NSMakeRange(i, 1)]]];
        } else {
            [result appendString:[str substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    
    return result;
}


@end
