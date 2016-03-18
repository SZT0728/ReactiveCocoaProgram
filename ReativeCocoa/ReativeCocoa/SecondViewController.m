//
//  SecondViewController.m
//  ReativeCocoa
//
//  Created by SZT on 16/3/16.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "SecondViewController.h"
#import "ReactiveCocoa.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;


@property(nonatomic,copy)NSString *countString;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc]initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftbtn;
    
    RAC(self.loginbtn,enabled) = [RACSignal combineLatest:@[self.count.rac_textSignal,self.password.rac_textSignal] reduce:^id{
        return @(self.count.text.length > 6 && self.password.text.length >6);
    }];
    
    [self.count.rac_textSignal subscribeNext:^(id x) {
        
        self.countString = (NSString *)x;

    }];
    
    
    //观察者的另一种写法
//    [RACObserve(self, self.countString) subscribeNext:^(id x) {
//        
//        NSLog(@"self.countString变化了%@",self.countString);
//    }];
    
    
    //观察者还提供了过滤器
    [[RACObserve(self, self.countString) filter:^BOOL(id value) {
        return [value hasPrefix:@"h"];
    }] subscribeNext:^(id x) {
        NSLog(@"现在就是以h开头的值了 ：%@",x);
    }];
    


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
