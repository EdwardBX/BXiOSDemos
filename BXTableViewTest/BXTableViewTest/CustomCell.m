//
//  CustomCell.m
//  BXTableViewTest
//
//  Created by bx_1512 on 16/2/19.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.customLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.customLabel];
    }
    return self;
}

-(void)layoutSubviews{
    self.customLabel.frame = CGRectMake(50, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.customLabel.textColor = [UIColor yellowColor];
}

@end
