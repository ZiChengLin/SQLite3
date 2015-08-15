//
//  SQLManager.m
//  Lesson-UI0608
//
//  Created by lin on 15/6/8.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SQLManager.h"
#import "StudentModel.h"

#pragma -mark 为什么要用static? 因为要保证的数据库对象只有一个 所以用static修饰
static sqlite3 *db = nil;

@implementation SQLManager

// 封装打开数据库的方法
+(sqlite3 *)openDB {
    
    // 如果db存在 即数据库已经是打开状态（判断一下程序严谨）
    if (db) {
        
        return db;
    }
    // 否则 1.先创建一个数据库路径保存到沙盒的document文件中
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    // 2.创建数据库路径 (注意:通常数据库文件都要以.sqlite结尾 这样用数据库的图形工具可以直接打开)
    NSString *filePath = [docPath stringByAppendingPathComponent:@"studentDB.sqlite"];
    NSLog(@"%@", filePath);
    // 3.在filePath路径下创建一个数据库文件 (因为sqlite3的操作都是基于c的接口 所以要用UTF8String把OC的转化成c) 参数1是数据库文件的路径 参数2是数据库对象的地址
    int state = sqlite3_open([filePath UTF8String], &db);
    
    if (state != SQLITE_OK) {
        
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 4.在数据库里面创建储存数据的表（数据库中的数据以表的形式来储存）写数据库语句不容写错
    
    /*
      创建表的关键字create table
      classA:表名
      primary key:表示主键
      text:表示字符串类型
     */
    
    NSString *createTableStr = @"create table if not exists classA(ID integer primary key, name text, phone text, age integer)";
    
    // 5.使用sql语句来创建表 (exec 执行语句 参数1是数据库对象 参数2是数据库执行语句、需要转化成c 参数3 系统预留参数 参数4系统预留参数 参数5是错误信息 双指针类型则对该指针取地址)
    char *errmsg;
    int result = sqlite3_exec(db, [createTableStr UTF8String], NULL, NULL, &errmsg);
    
    // 如果创建成功 该函数功能实现 关闭数据库并释放错误信息指针
    if (result) {
        
        sqlite3_close(db);
        sqlite3_free(errmsg);
    }
    
    return db;
}

// 封装关闭数据库的方法
+(void)closeDB {
    
    if (db) {
        
        sqlite3_close(db);
    }
    
}

#pragma -mark 添加一个学生
+(BOOL)addStudent:(StudentModel *)stu {
    
    // 1.打开数据库
    sqlite3 *db = [SQLManager openDB];
    // 2.创建一个数据库管理员对象
    sqlite3_stmt *stmt = nil;
    // 3.准备一个sql语句 (参数1是对要操作的数据库对象 参数2是sql语句 问好？表示占位符 参数3的－1:会自动的计算传入数据的大小 参数4是谁对数据进行操作(数据管理员) 参数5是系统预留参数)。
    int state = sqlite3_prepare_v2(db, "insert into classA(name,phone,age) values(?,?,?)", -1, &stmt, nil);
    
    if (state == SQLITE_OK) {
        // sql语句准备没有错误 则对？赋值
        // 第一个是name 字符串类型 c里面的text
        // 参数1是谁对数据进行操作(数据库管理员) 参数2的1表示对哪一个问号赋值 参数3是要赋的具体的值 参数4 -1:自动计算 参数5是系统预留参数
        sqlite3_bind_text(stmt, 1, [stu.name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [stu.phone UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 3, stu.age);
        
        // 执行sql语句(让管理员去进行一步一步的操作数据)
        int result = sqlite3_step(stmt);
        
        if (result == SQLITE_DONE) {
            
            NSLog(@"数据添加成功!");
            return YES;
        }
    }
    return NO;
}

#pragma -mark 查找全部学生
+(NSMutableArray *)findAllStudent {
    
    // 1.打开数据库
    sqlite3 *db = [SQLManager openDB];
    // 2.创建一个数据库管理员
    sqlite3_stmt *stmt = nil;
    // 3.准备一个sql语句
    int state = sqlite3_prepare_v2(db, "select * from classA", -1, &stmt, nil);

    // 4.创建一个存放model类的数组用来存放查找到的数据
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    
    if (state == SQLITE_OK) {
        
        // 5.在循环中一个字段一个字段的搜索
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            // 如果想要搜索包含主键 主键就要从0列开始
            int ID = sqlite3_column_int(stmt, 0);
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            const unsigned char *phone = sqlite3_column_text(stmt, 2);
            int age = sqlite3_column_int(stmt, 3);
            
            StudentModel *stu = [[StudentModel alloc]init];
            stu.ID = ID;
            stu.name = [NSString stringWithUTF8String:(char *)name];     // 需要将c的字符串转化为oc的字符串
            stu.phone = [NSString stringWithUTF8String:(char *)phone];
            stu.age = age;
            
            [mArray addObject:stu];
        }
    }
    return mArray;
}

#pragma -mark 修改学生信息
+(BOOL)updateStudentName:(NSString *)name andAge:(int)age andPhone:(NSString *)phone WhereIDIsEqual:(int)ID {
    
    sqlite3 *db = [SQLManager openDB];
    sqlite3_stmt *stmt = nil;
    int state = sqlite3_prepare_v2(db, "update classA set name = ?, phone = ?, age = ? where ID = ?", -1, &stmt, nil);
    
    if (state == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [phone UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 3, age);
        sqlite3_bind_int(stmt, 4, ID);
        
        int result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            return YES;
        }
    }
    return NO;
}

#pragma -mark 删除学生信息
+(BOOL)deleteByID:(int)ID {
    
    sqlite3 *db = [SQLManager openDB];
    sqlite3_stmt *stmt = nil;
    int state = sqlite3_prepare_v2(db, "delete from classA where ID = ?", -1, &stmt, nil);
    
    if (state == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, ID);   // 数据库一般将该记录梓空
        
        int result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            
            return YES;
        }
    }
    return NO;
}

@end
