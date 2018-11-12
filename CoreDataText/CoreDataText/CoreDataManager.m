//
//  CoreDataManager.m
//  CoreDataText
//
//  Created by 祥云创想 on 2018/11/9.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "CoreDataManager.h"


//获取CoreData的.xcdatamodel文件的名称
static NSString * const coreDataModelName = @"CoreDataText";
//获取CodeData
static NSString * const coreDataEntityName = @"CoreDataMode";
//数据库
static NSString * const sqliteName = @"CoreDataMode.sqlite";
@interface CoreDataManager()

@end

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


static CoreDataManager *coreDataManager = nil;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[CoreDataManager alloc] init];
    });
    return coreDataManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (coreDataManager == nil) {
            coreDataManager = [super allocWithZone:zone];
        }
    });
    return coreDataManager;
}



- (void)insertNewEntity:(NSDictionary *)dict success:(void (^)(void))success fail:(void (^)(NSError *))fail {
    if (!dict||dict.allKeys.count == 0) return;
    // 通过传入上下文和实体名称，创建一个名称对应的实体对象（相当于数据库一组数据，其中含有多个字段）
    NSManagedObject * entity = [NSEntityDescription insertNewObjectForEntityForName:coreDataEntityName inManagedObjectContext:self.managedObjectContext];
    // 实体对象存储属性值（相当于数据库中将一个值存入对应字段)
    for (NSString *key in [dict allKeys]) {
        [entity setValue:[dict objectForKey:key] forKey:key];
    }
    // 保存信息，同步数据
    NSError *error = nil;
    BOOL result = [self.managedObjectContext save:&error];
    if (!result) {
        NSLog(@"添加数据失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        NSLog(@"添加数据成功");
        if (success) {
            success();
        }
    }
}

- (void)deleteEntity:(NSManagedObject *)model success:(void (^)(void))success fail:(void (^)(NSError *))fail {
    // 传入需要删除的实体对象
    [self.managedObjectContext deleteObject:model];
    // 同步到数据库
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"删除失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        NSLog(@"删除成功");
        if (success) {
            success();
        }
    }
}

- (void)selectEntity:(NSArray *)selectKays ascending:(BOOL)isAscending filterString:(NSString *)filterString success:(void (^)(NSArray *))success fail:(void (^)(NSError *))fail {
    // 1.初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 2.设置要查询的实体
    NSEntityDescription *desc = [NSEntityDescription entityForName:coreDataEntityName inManagedObjectContext:self.managedObjectContext];
    request.entity = desc;
    // 3.设置查询结果排序
    if (selectKays&&selectKays.count>0) { // 如果进行了设置排序
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *key in selectKays) {
            /**
             *  设置查询结果排序
             *  sequenceKey:根据某个属性（相当于数据库某个字段）来排序
             *  isAscending:是否升序
             */
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:isAscending];
            [array addObject:sort];
        }
        if (array.count>0) {
            request.sortDescriptors = array;// 可以添加多个排序描述器，然后按顺序放进数组即可
        }
    }
    // 4.设置条件过滤
    if (filterString) { // 如果设置了过滤语句
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
        request.predicate = predicate;
    }
    // 5.执行请求
    NSError *error = nil;
    NSArray *objs = [self.managedObjectContext executeFetchRequest:request error:&error]; // 获得查询数据数据集合
    if (error) {
        NSLog(@"失败");
        if (fail) {
            fail(error);
        }
    } else{
        NSLog(@"成功");
        if (success) {
            success(objs);
        }
    }
}

- (void)updateEntity:(void (^)(void))success fail:(void (^)(NSError *))fail {
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"删除失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        if (success) {
            success();
        }
    }
}

#pragma 懒加载
//managedObjectModel 属性的getter方法
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) return _managedObjectModel;
    //.xcdatamodeld文件 编译之后变成.momd文件  （.mom文件）
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:coreDataModelName withExtension:@"momd"];
    //把文件的内容读取到managedObjectModel中
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

//Coordinator 调度者负责数据库的操作 创建数据库 打开数据 增删改查数据
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) return _persistentStoreCoordinator;
    //根据model创建了persistentStoreCoordinator
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    // 设置数据库存放的路径
    NSURL * storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:sqliteName];
    NSError * error = nil;
    //如果没有得到数据库，程序崩溃
    /*
     持久化存储库的类型：
     NSSQLiteStoreType  SQLite数据库
     NSBinaryStoreType  二进制平面文件
     NSInMemoryStoreType 内存库，无法永久保存数据
     虽然这3种类型的性能从速度上来说都差不多，但从数据模型中保留下来的信息却不一样
     在几乎所有的情景中，都应该采用默认设置，使用SQLite作为持久化存储库
     */
    // 添加一个持久化存储库并设置类型和路径，NSSQLiteStoreType：SQLite作为存储库
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        if (error) {
            NSLog(@"添加数据库失败:%@",error);
        } else {
            NSLog(@"添加数据库成功");
        }
        NSLog(@"错误信息: %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}

-(NSURL *)applicationDocumentsDirectory
{
    //获取沙盒路径下documents文件夹的路径 NSURL   (类似于search)
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].absoluteString);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


//容器类 存放OC的对象
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)  return _managedObjectContext;
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
    {
        return nil;
    }
    //创建context对象
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //让context和coordinator关联   context可以对数据进行增删改查功能   // 设置上下文所要关联的持久化存储库
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


@end
