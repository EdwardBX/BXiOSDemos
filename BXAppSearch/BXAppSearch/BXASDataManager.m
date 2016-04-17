//
//  BXASDataManager.m
//  BXAppSearch
//
//  Created by bx_1512 on 16/4/15.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "BXASDataManager.h"
#import <CoreSpotlight/CoreSpotlight.h>

NSString *const BXASDataManagerKey = @"title";
NSString *const BXASDataManagerValue = @"description";

@implementation BXASDataManager

+ (instancetype)sharedInstance {
    static BXASDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDataSource];
        [self indexForSpotlight];
    }
    return self;
}

- (void)createDataSource {
    self.people = @[@{BXASDataManagerKey: @"xbx", BXASDataManagerValue:@"cc's bf"},
                    @{BXASDataManagerKey: @"cc", BXASDataManagerValue:@"xbx's gf"},
                    @{BXASDataManagerKey: @"starman", BXASDataManagerValue:@"xbx's nickname"}];
}


- (void)indexForSpotlight {
    NSMutableArray *mySearchableItems = [NSMutableArray new];
    
    NSUInteger id = 0;
    for (NSDictionary *item in self.people) {
        CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"person"];
        [attributeSet setTitle:[item objectForKey:BXASDataManagerKey]];
        [attributeSet setContentDescription:[item objectForKey:BXASDataManagerValue]];
        // 拨打电话
        [attributeSet setPhoneNumbers:@[@"18771023314"]];
        [attributeSet setSupportsPhoneCall:@1];
        
        CSCustomAttributeKey *key = [[CSCustomAttributeKey alloc] initWithKeyName:@"xbx.BXAppSearch.key" searchable:YES searchableByDefault:YES unique:YES multiValued:NO];
        [attributeSet setValue:[item objectForKey:BXASDataManagerKey] forCustomKey:key];
        NSString *uniqueIdentifier = [NSString stringWithFormat:@"%li", (long)id++];
        
        // 创建一个可搜索条目，提供它的 unique identifier, domain identifier, and the attribute set
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:uniqueIdentifier domainIdentifier:@"xbx.BXAppSearch" attributeSet:attributeSet];
        
        [mySearchableItems addObject:item];
    }
    
    // 将条目添加到 on-device index.
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:mySearchableItems completionHandler: ^(NSError * __nullable error) {
        if (error == nil) {
            NSLog(@"Search items indexed");
        } else {
            NSLog(@"Failed to index items: %@", error.localizedDescription);
        }
    }];
}

@end
