//
//  LHModel.h
//  CoreDataText
//
//  Created by 祥云创想 on 2018/11/9.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LHModel : NSManagedObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@end
