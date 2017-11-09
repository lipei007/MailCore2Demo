//
//  SendEmailVC.m
//  TestEmail
//
//  Created by Jack on 2017/8/14.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "SendEmailVC.h"
#import "EmailEditor.h"
#import "JKSMTPMailSender.h"

@interface SendEmailVC () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *senderTF;
@property (strong, nonatomic) IBOutlet UITextField *ccTF;
@property (strong, nonatomic) IBOutlet UITextField *bccTF;
@property (strong, nonatomic) IBOutlet UITextField *subjectTF;
@property (strong, nonatomic) IBOutlet EmailEditor *editTV;

@property (nonatomic,strong) JKSMTPMailSender *sender;

@end

@implementation SendEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sender = [JKSMTPMailSender smtpSenderHost:@"smtp.qq.com" port:587];

    [self.sender loginAddress:@"676034689@qq.com" password:@"xxxxx1234566"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    v.backgroundColor = [UIColor redColor];
    self.editTV.inputAccessoryView = v;
    
    UIBarButtonItem* itemOne = [[UIBarButtonItem alloc] initWithTitle:@"One"
                                                                style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem* itemTwo = [[UIBarButtonItem alloc] initWithTitle:@"Two"
                                                                style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem* itemThree = [[UIBarButtonItem alloc] initWithTitle:@"Three"
                                                                  style:UIBarButtonItemStylePlain target:self action:nil];
    
    // Use a nil action to display the individual items when tapped.
    UIBarButtonItem* itemChoose = [[UIBarButtonItem alloc] initWithTitle:@"Choose"
                                                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Create the item group.
    UIBarButtonItemGroup* group = [[UIBarButtonItemGroup alloc]
                                   initWithBarButtonItems:@[itemOne, itemTwo, itemThree] representativeItem:itemChoose];
    
    // Display the items before the typing suggestions.
    self.editTV.inputAssistantItem.trailingBarButtonGroups = @[group];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sentBtnClick:(UIButton *)sender {
    NSArray *to = [self.senderTF.text componentsSeparatedByString:@";"];
    NSArray *cc = [self.ccTF.text componentsSeparatedByString:@";"];
    NSArray *bcc = [self.bccTF.text componentsSeparatedByString:@";"];
    NSString *subject = self.subjectTF.text;
    NSString *body = self.editTV.text;
    
    [self.sender sendEmail:body attachments:nil subject:subject to:to cc:cc bcc:bcc completion:^(NSError *error) {
        if (error) {
            NSLog(@"send failed");
        } else {
            NSLog(@"send successful");
        }
    }];
}


#pragma mark -

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}


@end
