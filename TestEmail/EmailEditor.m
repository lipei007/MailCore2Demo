//
//  EmailEditor.m
//  TestEmail
//
//  Created by Jack on 2017/8/14.
//  Copyright © 2017年 buakaw.lee.com.www. All rights reserved.
//

#import "EmailEditor.h"

@interface EmailEditor () {
    int menuItemFlag;
}



@end

@implementation EmailEditor

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 初始化时设置将覆盖系统值
//    UIMenuController *mc = [UIMenuController sharedMenuController];
//    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"copy" action:@selector(insert:)];
//    UIMenuItem *select = [[UIMenuItem alloc] initWithTitle:@"select" action:@selector(insert:)];
//    UIMenuItem *paste = [[UIMenuItem alloc] initWithTitle:@"paste" action:@selector(insert:)];
//    UIMenuItem *insert = [[UIMenuItem alloc] initWithTitle:@"insert" action:@selector(insert:)];
//    mc.menuItems = @[copy,select,paste,insert];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        UIMenuController *mc = [UIMenuController sharedMenuController];
//        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"copy" action:@selector(insert:)];
//        UIMenuItem *select = [[UIMenuItem alloc] initWithTitle:@"select" action:@selector(insert:)];
//        UIMenuItem *paste = [[UIMenuItem alloc] initWithTitle:@"paste" action:@selector(insert:)];
//        UIMenuItem *insert = [[UIMenuItem alloc] initWithTitle:@"insert" action:@selector(insert:)];
//        mc.menuItems = @[copy,select,paste,insert];
    }
    return self;
}

- (void)didMoveToSuperview {

    menuItemFlag = 0;
    // 显示在父视图上后设置menuItems 将会在数组menuItems append
    UIMenuController *mc = [UIMenuController sharedMenuController];
    UIMenuItem *photo = [[UIMenuItem alloc] initWithTitle:@"Photos" action:@selector(insertPhoto:)];
    mc.menuItems = @[photo];
    
    
}


- (void)insertPhoto:(UIMenuItem *)sender {

    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    // 控制显示
    NSString *sel = NSStringFromSelector(action);
    
    NSLog(@"can perform action: %@                  sender: %@",sel,sender);
    
    if ([sel isEqualToString:@"cut:"]) {
        return YES;
    }
    if ([sel isEqualToString:@"copy:"]) {
        return YES;
    }
    if ([sel isEqualToString:@"paste:"]) {
        return YES;
    }
    if ([sel isEqualToString:@"select:"]) {
        return YES;
    }
    if ([sel isEqualToString:@"selectAll:"]) {
        return YES;
    }
    if ([sel isEqualToString:@"_showTextStyleOptions:"]) {
        return YES;
    }
    if ([sel isEqualToString:@"insertPhoto:"]) {
        return YES;
    }
    
    
    // toggleBoldface: toggleItalics: toggleUnderline:
    if ([sel isEqualToString:@"toggleBoldface:"]) { // 粗体
        return YES;
    }
    if ([sel isEqualToString:@"toggleItalics:"]) { // 斜体
        return YES;
    }
    if ([sel isEqualToString:@"toggleUnderline:"]) { // 下划线
        return YES;
    }
    
    return NO;
}

- (id)targetForAction:(SEL)action withSender:(id)sender {
    
    NSString *sel = NSStringFromSelector(action);
    
    if ([sel isEqualToString:@"cut:"]) {
        menuItemFlag = 1 << 0;
    }
    if ([sel isEqualToString:@"copy:"]) {
        menuItemFlag = 1 << 1;
    }
    if ([sel isEqualToString:@"paste:"]) {
        menuItemFlag = 1 << 2;
    }
    if ([sel isEqualToString:@"select:"]) {
        menuItemFlag = 1 << 3;
    }
    if ([sel isEqualToString:@"selectAll:"]) {
        menuItemFlag = 1 << 4;
    }
    if ([sel isEqualToString:@"_showTextStyleOptions:"]) {
        menuItemFlag = 1 << 5;
    }
    if ([sel isEqualToString:@"insertPhoto:"]) {
        menuItemFlag = 1 << 6;
    }
    
    
    // toggleBoldface: toggleItalics: toggleUnderline:
    if ([sel isEqualToString:@"toggleBoldface:"]) { // 粗体
        menuItemFlag = 1 << 7;
    }
    if ([sel isEqualToString:@"toggleItalics:"]) { // 斜体
        menuItemFlag = 1 << 8;
    }
    if ([sel isEqualToString:@"toggleUnderline:"]) { // 下划线
        menuItemFlag = 1 << 9;
    }

    
    
    NSLog(@"target for  action: %@                  withSender: %@",NSStringFromSelector(action),sender);
    id obj = [super targetForAction:action withSender:sender];
    
    return obj;
}


@end
