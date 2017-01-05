//
//  ViewController.m
//  gesture
//
//  Created by 夏世萍 on 2016/12/31.
//  Copyright © 2016年 夏世萍. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong)NSArray *arr;

@property (nonatomic,strong)UIImageView *img;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arr = @[@"1",@"2",@"3"];
    
    for (int i = 0; i < 3; i++)
    {
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30)];
        self.img.tag = i;
        self.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.arr[i]]];
//        self.img.image = [UIImage imageNamed:@"1"];
        self.img.contentMode = UIViewContentModeScaleToFill;
        self.img.userInteractionEnabled = YES; //为YES时，才可以接收手势操作
        [self.view addSubview:self.img];
        [self addGesture];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)addGesture
{
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTouchesRequired = 1; //设置点击是的手指的个数
    [self.view addGestureRecognizer:tap];
    
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    longPress.minimumPressDuration = 1.0; //默认是0.5秒
    longPress.numberOfTouchesRequired = 1;
    [self.img addGestureRecognizer:longPress]; //注意由于我们要做长按提示删除操作，因此这个手势不再添加到控制器视图上而是添加到了图片上

    
    //捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.view addGestureRecognizer:pinch];
    
    /*添加旋转手势*/
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateImage:)];
    [self.view addGestureRecognizer:rotationGesture];
    
    /*添加拖动手势*/
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panImage:)];
    [self.img addGestureRecognizer:panGesture];
    
    /*添加轻扫手势*/
    //注意一个轻扫手势只能控制一个方向，默认向右，通过direction进行方向控制
    UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    //swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;//默认为向右轻扫
    [self.view addGestureRecognizer:swipeGestureToRight];
    
    UISwipeGestureRecognizer *swipeGestureToLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    swipeGestureToLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureToLeft];

}

//点击隐藏导航栏
- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    BOOL hidden = !self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
}

//长按删除图片
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress
{
    //由于连续手势此方法会调用多次，所以需要判断其手势状态
    UIImageView *image = (UIImageView *)[longPress view];
    
    switch (longPress.state) {
        case UIGestureRecognizerStatePossible:
//                [image removeFromSuperview];
            break;
        case UIGestureRecognizerStateBegan:
//                [image removeFromSuperview];
            break;
        case UIGestureRecognizerStateChanged:
//                [image removeFromSuperview];
            break;
        case UIGestureRecognizerStateEnded:
                [image removeFromSuperview];
            break;
            
        default:
            break;
    }
    
   
}

//捏合时缩放图片
- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch
{
    if (pinch.state == UIGestureRecognizerStateChanged)
    {
        //捏合手势中scale属性记录的按宽高比例缩放
        self.img.transform=CGAffineTransformMakeScale(pinch.scale, pinch.scale);
    }
    else if(pinch.state == UIGestureRecognizerStateEnded)
    {   //结束后恢复
        [UIView animateWithDuration:0.5 animations:^{
            self.img.transform=CGAffineTransformIdentity;//取消一切形变
        }];
    }
}

//旋转图片
- (void)rotateImage:(UIRotationGestureRecognizer *)rotate
{
    if (rotate.state == UIGestureRecognizerStateChanged)
    {
        self.img.transform = CGAffineTransformMakeRotation(rotate.rotation); //利用拖动手势的translationInView:方法取得在相对指定视图（这里是控制器根视图）的移动
    }
    else if (rotate.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.img.transform = CGAffineTransformIdentity;
        }];
    }
}

//拖动图片
- (void)panImage:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [pan translationInView:self.view];
        self.img.transform = CGAffineTransformMakeTranslation(point.x, point.y);
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.img.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)swipeImage:(UISwipeGestureRecognizer *)swipe
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
