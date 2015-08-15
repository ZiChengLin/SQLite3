//
//  StudentModel.h
//  Lesson-UI0608
//
//  Created by lin on 15/6/8.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject

// 四个属性分别对应数据库里面的四个字段
@property (nonatomic, assign)int ID;
@property (nonatomic, assign)int age;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *phone;

- (instancetype)initWithName:(NSString *)name andAge:(int)age andPhone:(NSString *)phone andID:(int)ID;

@end
