//
//  SQLManager.h
//  Lesson-UI0608
//
//  Created by lin on 15/6/8.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/*
 1.添加系统类库
 */


#pragma -mark 工具类里面的方法最好封装成加号方法  这样使用的时候就不用再开辟内存空间了
@class StudentModel;
@interface SQLManager : NSObject

+ (sqlite3 *)openDB;
+ (void)closeDB;

+ (BOOL)addStudent:(StudentModel *)stu;

+ (NSMutableArray *)findAllStudent;

+ (BOOL)updateStudentName:(NSString *)name andAge:(int)age andPhone:(NSString *)phone WhereIDIsEqual:(int)ID;

+ (BOOL)deleteByID:(int)ID;

@end



/*
 
 对API的总结：
 sqlite3_open: 根据一个路径打开一个数据库文件
 sqlite3_exec: 数据库对表的操作
 sqlite3_close: 关闭数据库
 sqlite3_free: 释放指针
 sqlite_prepare_v2: 准备一个sql语句
 sqlite_bing_xxx: 对数据库里面的字段进行赋值的函数
 sqlite_step: 对sql语句的执行
 sqlite_stmt: 数据库管理员
 
 SQLITE_OK: 执行成功
 SQLITE_DONE: 执行完毕
 SQLITE_ROW: has another row ready不仅表示当前行还能自动走到下一行
 
 sqlite_column_xxx:从数据库里面按照一个字段一个字段的读取数据
 
 */
