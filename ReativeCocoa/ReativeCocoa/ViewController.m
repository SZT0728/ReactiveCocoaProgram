//
//  ViewController.m
//  ReativeCocoa
//
//  Created by SZT on 16/3/16.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "SecondViewController.h"
#import "ImageModel.h"

#import "RACDelegateProxy.h"

#import "RACReturnSignal.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@property(nonatomic,strong)RACCommand *command;

@property(nonatomic,strong)RACCommand *btnCommand;

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *redView;


@property (weak, nonatomic) IBOutlet UISlider *slider;

@property(nonatomic,strong)UIImagePickerController *imagePicker;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property(nonatomic,assign)NSInteger currentValue;


@property (weak, nonatomic) IBOutlet UIButton *valueButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentValue = 0;

    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"23.jpg"] forBarMetrics:(UIBarMetricsDefault)];
    
    
   
    
    /**
     *      RACSignal(信号类)的简单使用
     */
//    [self useTheRACSignal];
    
    /**
            RACSubject（信号的提供者），自己可以充当信号又能发送信号
    */
//    [self useTheRACSubject];
    
    /**
     *
            RACReplaySubject是RACSubject的子类，重复提供信号类
        跟RACSubject的区别： RACReplaySubject可以先发送信号再订阅，RACSubject不可以
     使用1:如果一个信号被订阅一次就需要把之前的的值发送一次，这个时候就需要RACReplaySubject
     使用2:可以设置capitiry来限制缓存的value的数量，即只缓存最新的几个值
     *
    */
//    [self useTheRACReplaySubject];
    
    
    /**
     *  RACSequece   集合类，常用来代替数组 字典快速遍历
     */
//    [self useTheRACSequece];
    
    /**
        RACCommand    命令的简单使用
     */
//    [self useTheRACCommand];
    
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"next" style:(UIBarButtonItemStylePlain) target:self action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
//    绑定textView,textfield同理
   [self.myTextView.rac_textSignal subscribeNext:^(id x) {
      
       NSLog(@"输出：%@",x);
       
   }];
    
    
    
//    绑定按钮，处理按钮监听，替换之前的targetAction
    [[self.btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
//        NSLog(@"click:%@",x);
        
        //处理UIImagePicker
        self.imagePicker = [UIImagePickerController new];
        [self.imagePicker.rac_imageSelectedSignal subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
            NSDictionary *dic = (NSDictionary *)x;
            self.myImageView.image = dic[@"UIImagePickerControllerOriginalImage"];
            
            [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
        }];

        [[self.imagePicker.rac_delegateProxy signalForSelector:@selector(imagePickerControllerDidCancel:)] subscribeNext:^(id x) {
            //该block调用时候：当delegate要执行imagePickerControllerDidCancel：该方法的时候机会调用该block，可以把block当作selector里面要执行的内容
            [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        
        
    }];
    
//    绑定slider
    [[self.slider rac_signalForControlEvents:(UIControlEventValueChanged)] subscribeNext:^(id x) {
        UISlider *slider = (UISlider *)x;
        NSLog(@"the value is change:%f",slider.value);
    }];
    
//    绑定手势
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [self.redView addGestureRecognizer:tap];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        NSLog(@"点击了红色的view");
    }];
    
    
    //通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ChangeColor" object:nil] subscribeNext:^(id x) {
        NSNotification *notification = (NSNotification *)x;
        NSLog(@"收到通知：%@",notification.object);
        self.view.backgroundColor = (UIColor *)notification.object;
    }];
    
    //观察者(观察self 的currentvalue的变化，只要一变化就调用block)
    
    [[self rac_valuesAndChangesForKeyPath:@"currentValue" options:(NSKeyValueObservingOptionNew) observer:self] subscribeNext:^(id x) {
        
        RACTupleUnpack(NSString *kind,NSString *new) = x;
        NSLog(@"观察到currentValue的值发生改变,现在的value等于%@,%@",kind,new);
        
    }];
//    self的valueButton没点击一下就让currentValue的值加一
    [[self.valueButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        self.currentValue ++;
    }];
    
    
    
}




- (void)nextAction:(UIBarButtonItem *)btn
{
    
    
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [s instantiateViewControllerWithIdentifier:@"second"];
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    SecondViewController *secondVC = [[SecondViewController alloc]init];
    //创建信号
    secondVC.subject = [RACSubject subject];
//    //订阅第二个页面的信号，当第二个页面的信号发送value的时候在这里回调就改变这个页面的颜色
    [secondVC.subject subscribeNext:^(id x) {
        UIColor *color = (UIColor *)x;
        self.view.backgroundColor = color;
    }];
    [self.navigationController pushViewController:secondVC animated:YES];
     
     */
}

- (void)useTheRACSignal
{
    /**
     步骤一：首先通过RACSignal类调用类方法+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe 创建一个信号
     步骤二：订阅该信号，订阅该信号后就会回调上面的block
     */
    
    /**
     *  创建信号
     */
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //        subscriber  表示订阅者用于发送对象的。通过creat出来的都有一个订阅者帮他发送数据
        /**
         *  block调用的时候：每当有订阅者订阅该信号就会调用这个block
         */
        
        //       发送信号
        [subscriber sendNext:@"value"];
        
        //        发送信号结束后如果不再发送信号最好调用一下发送完成，内部会自动调用[RACDisposable disposable]取消订阅信号
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            //RACDisposable用于取消订阅和清理资源的，在信号发送完成或者失败的时候调用
            // 这个block调用的时候：当信号发送完成或失败的时候自动执行这个block取消订阅者
            
            //            执行完这个block后，当前信号就不在被订阅了
            //            执行完改block，信号就不再订阅的范围内
            NSLog(@"信号被销毁了");
        }];
        
        
    }];
    
    //  订阅该信号，否则该信号一直都是冷信号，值改变了也不会触发，只有订阅了该信号才会触发，信号才会变成热信号
    [signal subscribeNext:^(id x) {
        
        //         该block调用的时候：每当有信号发出的时候就会回调该block
        NSLog(@"接收到数据:%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"第二次订阅 %@",x);
    }];

}

-(void)useTheRACSubject
{
    //     *  创建信号，创建信号的时候没有block回调
    RACSubject *signalSubject = [RACSubject subject];
    
    //    订阅该信号(可以多次订阅该信号)
    [signalSubject subscribeNext:^(id x) {
        //block回调的时候就是接受到数据的时候
        NSLog(@"第一次订阅，接受到的数据：%@",x);
    }];
    
    [signalSubject subscribeNext:^(id x) {
        NSLog(@"第二次订阅，接收到的数据%@",x);
    }];
    //    发送信号
    [signalSubject sendNext:@"wahaha"];
    
    
}

- (void)useTheRACReplaySubject
{
    //    创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //    发送信号(在没有订阅该信号之前就可以先发送值，在以后订阅信号的时候都会收到)
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    //    订阅该信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一次订阅，收到的值： %@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二次订阅，收到的值:%@",x);
    }];

    
}


//RAC的集合类
- (void)useTheRACSequece
{
    //    遍历数组
    NSArray *arraydemo = @[@1,@2,@3,@4];
    [arraydemo.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        NSLog(@" 数组%@",[NSThread currentThread]);
    }];
    
    //    遍历字典
    NSDictionary *dict = @{@1:@"value1",@2:@"value2",@3:@"value3",@4:@"value4"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //解包元组
        NSLog(@"字典%@",[NSThread currentThread]);
        RACTupleUnpack(NSNumber *num,NSString *str) = x;
        NSLog(@"%@------%@",num,str);
    }];
    
    
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:imageFile];
    NSMutableArray *modelArray = [NSMutableArray array];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSDictionary *dic = (NSDictionary *)x;
        ImageModel *model = [ImageModel imageModelWithDict:dic];
        [modelArray addObject:model];
    }];
}


- (void)useTheRACCommand
{
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行操作");
        //创建如果是空信号的话必须返回        return [RACSignal empty];
        //        如果是非空信号，则：
        return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"value"];
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    //    命令必须被强用，否则一旦被销毁就接收不到命令
    _command = command;
    //    订阅命令当中的信号，此时并不会发送数据，只有命令执行的时候才会发送数据
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"订阅command中的信号，接收到的值为：%@",x);
        }];
    }];
    
    //    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
    //
    //        NSLog(@"%@",x);
    //
    //    }];
    
    //    监听命令是否执行结束
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }
        else{
            NSLog(@"执行结束");
        }
    }];
    
    [self.command execute:@2];

}

@end
