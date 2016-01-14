//
//  ViewController.m
//  BXCoreText
//
//  Created by bx_1512 on 16/1/10.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "ViewController.h"
#import "BXCoreTextView.h"

@interface ViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet BXCoreTextView *coreTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) NSArray *typeArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typeArray = [NSArray arrayWithObjects:@"DrawPureText", @"DrawColumnarText", @"DrawTextLabel", @"DrawStyledParagraph", @"DrawDonutText",nil];
    self.coreTextView.drawType = DrawPureText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ----UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.typeArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.typeArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.coreTextView.drawType = DrawPureText;
        [self.coreTextView setNeedsDisplay];
    } else if (row == 1){
        self.coreTextView.drawType = DrawColumnarText;
        [self.coreTextView setNeedsDisplay];
    } else if (row == 2){
        self.coreTextView.drawType = DrawTextLabel;
        [self.coreTextView setNeedsDisplay];
    } else if (row == 3){
        self.coreTextView.drawType = DrawStyledParagraph;
        [self.coreTextView setNeedsDisplay];
    } else {
        self.coreTextView.drawType = DrawDonutText;
        [self.coreTextView setNeedsDisplay];
    }
}

@end
