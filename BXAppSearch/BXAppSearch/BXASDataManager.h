//
//  BXASDataManager.h
//  BXAppSearch
//
//  Created by bx_1512 on 16/4/15.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BXASDataManagerKey;
extern NSString *const BXASDataManagerValue;

@interface BXASDataManager : NSObject

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *people;

+ (instancetype)sharedInstance;

@end
