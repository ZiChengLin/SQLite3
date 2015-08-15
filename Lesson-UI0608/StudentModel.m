//
//  StudentModel.m
//  Lesson-UI0608
//
//  Created by lin on 15/6/8.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel

-(instancetype)initWithName:(NSString *)name andAge:(int)age andPhone:(NSString *)phone andID:(int)ID {
    
    self = [super init];
    if (self) {
        
        self.name = name;
        self.age = age;
        self.phone = phone;
        self.ID = ID;
    }
    return self;
}

@end
