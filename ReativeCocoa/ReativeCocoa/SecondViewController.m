//
//  SecondViewController.m
//  ReativeCocoa
//
//  Created by SZT on 16/3/16.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc]initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftbtn;
}

- (void)backAction:(UIBarButtonItem *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeColor" object:[UIColor grayColor]];
    UIColor *color = [UIColor redColor];
    [self.subject sendNext:color];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
