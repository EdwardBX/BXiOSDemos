//
//  ViewController.m
//  BXViewTest
//
//  Created by bx_1512 on 16/1/26.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *myIV;
@property (nonatomic, assign) BOOL isRotate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    UIButton *rotateBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 50, 100, 40)];
    [rotateBtn setTitle:@"点击旋转" forState:UIControlStateNormal];
    [rotateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rotateBtn.backgroundColor = [UIColor yellowColor];
    [rotateBtn addTarget:self action:@selector(rotateView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateBtn];
    
    self.myIV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 120, 100, 100)];
    self.myIV.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myIV];
    
    self.isRotate = NO;
    
    // 创建一个 CALayer 实例
    CALayer* myLayer = [[CALayer alloc] init];
    
    // 把 layer 的内容设置为图像
    UIImage *layerContents = [UIImage imageNamed:@"myImage"];
    CGSize imageSize = layerContents.size;
    
    myLayer.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    myLayer.contents = (id)layerContents.CGImage;
    
    CALayer *viewLayer = self.view.layer;
    [viewLayer addSublayer:myLayer];
    
    // 在 view 中把这个 layer 居中
    CGRect viewBounds = self.view.bounds;
    myLayer.position = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds));
}

- (void)rotateView {
    if (!self.isRotate) {
        CGAffineTransform xform = CGAffineTransformMakeRotation(M_PI/4.0);
        self.myIV.transform = xform;
        self.isRotate = YES;
    } else {
        CGAffineTransform xform = CGAffineTransformMakeRotation(0);
        self.myIV.transform = xform;
        self.isRotate = NO;
    }
}

#pragma mark - ----external display
- (void)displaySelectionInSecondaryWindow:(UIWindow *)window{
    
}

- (void)displaySelectionOnMainScreen{
    
}


@end
