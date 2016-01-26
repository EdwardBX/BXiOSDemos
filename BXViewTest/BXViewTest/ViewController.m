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
@property (nonatomic, strong) UIImageView *nextIV;
@property (nonatomic, assign) BOOL isRotate;
@property (nonatomic, assign) BOOL isMyIVShow;

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
    UIButton *rotateBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 50, 80, 40)];
    [rotateBtn setTitle:@"点击旋转" forState:UIControlStateNormal];
    [rotateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rotateBtn.backgroundColor = [UIColor yellowColor];
    [rotateBtn addTarget:self action:@selector(rotateView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateBtn];
    
    UIButton *animateBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 50, 80, 40)];
    [animateBtn setTitle:@"动画隐藏" forState:UIControlStateNormal];
    [animateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    animateBtn.backgroundColor = [UIColor yellowColor];
    [animateBtn addTarget:self action:@selector(animateView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animateBtn];
    
    UIButton *transitionBtn = [[UIButton alloc]initWithFrame:CGRectMake(210, 50, 80, 40)];
    [transitionBtn setTitle:@"视图转换" forState:UIControlStateNormal];
    [transitionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    transitionBtn.backgroundColor = [UIColor yellowColor];
    [transitionBtn addTarget:self action:@selector(transitionView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transitionBtn];

    self.myIV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 120, 100, 100)];
    self.myIV.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myIV];
    
    self.nextIV = [[UIImageView alloc]initWithFrame:CGRectMake(150, 120, 100, 100)];
    self.nextIV.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.nextIV];
    
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

#pragma mark - ----action
- (void)rotateView {
    [UIView animateWithDuration:1.0 animations:^{
        if (!self.isRotate) {
            CGAffineTransform xform = CGAffineTransformMakeRotation(M_PI/4.0);
            self.myIV.transform = xform;
            self.isRotate = YES;
        } else {
            CGAffineTransform xform = CGAffineTransformMakeRotation(0);
            self.myIV.transform = xform;
            self.isRotate = NO;
        }
    }];
}

- (void)animateView {
    // 立即隐藏
    [UIView animateWithDuration: 1.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         self.myIV.alpha = 0.0;
                     }
                     completion: ^(BOOL finished){
                         // 1秒后在显示
                         [UIView animateWithDuration: 1.0
                                               delay: 1.0
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations: ^{
                                              self.myIV.alpha = 1.0;
                                          }
                                          completion:nil];
                     }];
}

//-(void)transitionView{
//    [UIView transitionWithView: self.myIV
//                      duration: 1.0
//                       options: UIViewAnimationOptionTransitionCurlUp
//                    animations: ^{
//                        self.myIV.hidden = YES;
//                        self.nextIV.hidden = NO;
//                    }
//                    completion:^(BOOL finished){
//                        UIImageView *temp = self.myIV;
//                        self.myIV = self.nextIV;
//                        self.nextIV = temp;
//                    }];
//}

- (void)transitionView {
    [UIView transitionFromView: (self.isMyIVShow ? self.myIV : self.nextIV)
                        toView: (self.isMyIVShow ? self.nextIV : self.myIV)
                      duration: 1.0
                       options: (self.isMyIVShow ? UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    completion: ^(BOOL finished) {
                        if (finished) {
                            self.isMyIVShow = !self.isMyIVShow;
                        }
                    }];
}

#pragma mark - ----external display
- (void)displaySelectionInSecondaryWindow:(UIWindow *)window{
    
}

- (void)displaySelectionOnMainScreen{
    
}


@end
