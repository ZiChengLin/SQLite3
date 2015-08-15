//
//  ViewController.m
//  Lesson-UI0608
//
//  Created by lin on 15/6/8.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import "StudentModel.h"
#import "SQLManager.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 
 NULL 表示基本数据类型int float..为空 开辟了一块空间梓空
 nil  对象为空
 0 值为0
 
 */

- (IBAction)doAdd:(id)sender {
    
    StudentModel *stu = [[StudentModel alloc]initWithName:@"ZiCheng" andAge:20 andPhone:@"13751755081" andID:0];
    
    BOOL isSuccess = [SQLManager addStudent:stu];
    if (isSuccess) {
        
        NSLog(@"成功");
        
    } else {
        
        NSLog(@"失败");
    }
}

- (IBAction)doSelect:(id)sender {
    
    NSArray *array = [SQLManager findAllStudent];
    for (StudentModel *stu in array) {
        
        NSLog(@"姓名:%@ 手机号:%@ ID:%d 年龄:%d", stu.name, stu.phone, stu.ID, stu.age);
    }
    
}

- (IBAction)doUpdate:(id)sender {
    
    BOOL isSuccess = [SQLManager updateStudentName:@"sam" andAge:12 andPhone:@"13014452362" WhereIDIsEqual:1];
    if (isSuccess) {
        
        NSLog(@"修改成功");
    } else {
        
        NSLog(@"修改失败");
    }
}


- (IBAction)doDelete:(id)sender {
    
    BOOL isSuccess = [SQLManager deleteByID:1];
    if (isSuccess) {
        
        NSLog(@"删除成功");
    } else {
        
        NSLog(@"删除失败");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
