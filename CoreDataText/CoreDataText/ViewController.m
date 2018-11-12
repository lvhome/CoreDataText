//
//  ViewController.m
//  CoreDataText
//
//  Created by 祥云创想 on 2018/11/9.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "LHModel.h"
#import "CoreDataManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // CoreData的简单理解  CoreData是一个模型层的技术，也是一种持久化技术，它能将模型对象的状态持久化到磁盘里，我们不需要使用SQL语句就能对它进行操作。
   // CoreData 不是一个数据库但是可以使用数据库来存储数据，也可以使用其他方式，比如：数据库文件，XML，二进制文件，内存等。CoreData 提供了 对象-关系映射(ORM) 功能。能够实现数据库数据和 OC 对象的相互转换，在这个转换过程中我们不需要编写任何 SQL 语句。
    
    //为什么要使用CoreData
//    极大的减少Model层的代码量
//    优化了使用SQLite时候的性能
//    提供了可视化设计

//    .xcdatamodeld 文件：定义了数据库数据和 OC 对象转换的映射关系，编译后为 .momod 文件
    

    
    
    
    
    
    // CoreData的使用  1、创建步骤  如果你是一个新的项目 可以创建项目的时候选择 CoreData  如图
    // 如果是老的项目 之前没有使用CoreData ,则按照如下的步骤
    //CoreData 用到的类
    
    //NSManagedObjectContext  数据库操作：NSManagedObjectContext 被管理的对象上下文（对数据直接操作）
//    NSManagedObjectContext：等同于一个容器，用来存储从数据库中转换出来的所有的 OC 对象。我们的增删改查操作直接对这个类使用来获得或者修改需要的 OC 对象，它能够调用 NSPersistentStoreCoordinator 类实现对数据库的同步
//    这个对象有点像SQLite对象(用来管理.xcdatamodeld中的数据)。
//    负责数据和应用库之间的交互(CRUD，即增删改查、保存等接口都是用这个对象调用).
//    每个 NSManagedObjectContext 和其他 NSManagedObjectContext 都是完全独立的。
//    所有的NSManagedObject（个人理解：实体数据）都存在于NSManagedObjectContext中。
//    每个NSManagedObjectContext都知道自己管理着哪些NSManagedObject（实体数据）
//可以通过TA去访问底层的框架对象集合，这些对象集合统称为持久化堆栈（persistence stack）——它在应用程序和外部数据存储的对象之间提供访问通道
//Managed Object Context 的作用相当重要，对数据对象进行的操作都与它有关。当创建一个数据对象并插入 Managed Object Context 中，Managed Object Context 就开始跟踪这个数据对象的一切变动，并在合适的时候提供对 undo/redo 的支持，或调用 Persistent Store Coordinato 将变化保存到数据文件中去
//redo: 恢复已经提交的事务  undo: 回滚操作，支持读一致性，恢复失败的事务
    
//    查询语句：NSPetchRequest  相当于select语句
//    Fetch Requests 相当于一个查询语句，你必须指定要查询的 Entity。我们通过 Fetch Requests 向 Managed Object Context 查询符合条件的数据对象，   以 NSArray 形式返回查询结果，如果我们没有设置任何查询条件，则返回该 Entity 的所有数据对象。我们可以使用谓词来设置查询条件，通常会将常用的 Fetch Requests 保存到 dictionary 以重复利用
    
  
    
    //NSManagedObjectModel  Core Data的模型文件，有点像SQLite的.sqlite文件(个人理解：表示一个.xcdatamodeld文件)
    //应用程序的数据模型，数据库中所有表格和他们之间的联系
//        NSManagedObjectModel：负责读取解析 .momod 文件
//    NSManagedObjectModel   * model    = [self managedObjectModel];//获取实例
//    NSDictionary           * entities = [model entitiesByName];//entitiesByName 得到所有的表的名字
//    NSEntityDescription    * entity   = [entities valueForKey:@"CoreDataModel"];//从里面找出名为 Student 的表
    
//    NSPersistentStoreCoordinator 持久化存储库，CoreData的存储类型（比如SQLite数据库就是其中一种）。
//    用来将对象管理部分和持久化部分捆绑在一起，负责相互之间的交流
//    用来设置CoreData存储类型和存储路径
//    使用 Core Data document 类型的应用程序，通常会从磁盘上的数据文中中读取或存储数据，这写底层的读写就由 Persistent Store Coordinator 来处理。一   般我们无需与它直接打交道来读写文件，Managed Object Context 在背后已经为我们调用 Persistent Store Coordinator 做了这部分工作
//    NSPersistentStoreCoordinator：通过解析结果去实现数据库和 OC 对象之间的相互转换，主要是操作数据库的，我们一般用不上，由系统处理

    
//    NSEntityDescription  用来描述实体(Entity) 表格结构： 相当于数据库中的一个表，TA描述一种抽象数据类型
//    通过Core Data从数据库中取出的对象,默认情况下都是NSManagedObject对象.
    //+insertNewObjectForEntityForName:inManagedObjectContext: 工厂方法，根据给定的 Entity 描述，生成相应的 NSManagedObject 对象，并插入到 ManagedObjectContext 中
//    LHModel * model = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataMode" inManagedObjectContext:self.managedObjectContext];
    //通过上面的代码可以得到model这个表的实例，然后可以使用这个实例去为表中的属性赋值
//    model.title = @"标题";
//    model.content = @"内容";
    
//    NSManagedObject的工作模式有点类似于NSDictionary对象,通过键-值对来存取所有的实体属性.     NSManagedObject：数据库中的数据转换而来的OC对象
//    setValue:forkey:存储属性值(属性名为key);
//    valueForKey:获取属性值(属性名为key).
//    每个NSManagedObject都知道自己属于哪个NSManagedObjectContext   用于插入数据使用：获得实体，改变实体各个属性值，保存后就代表插入
    
    NSDictionary * dict = @{@"title":@"title2",@"content":@"content2"};
    [[CoreDataManager sharedInstance] insertNewEntity:dict success:^{
        NSLog(@"成功");
    } fail:^(NSError *error) {
        NSLog(@"失败");
    }];
    
    [[CoreDataManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
        NSLog(@"数据---%@",results);
    } fail:^(NSError *error) {
        
    }];
    
    NSString * filterString = [NSString stringWithFormat:@"title = 'title'"];
    [[CoreDataManager sharedInstance] selectEntity:nil ascending:YES filterString:filterString success:^(NSArray *results) {
        NSLog(@"数据---%@",results);
        if (results.count>0) {
            //删除某个
            [[CoreDataManager sharedInstance] deleteEntity:[results firstObject] success:^{
            } fail:^(NSError *error) {
            }];
        }
       
    } fail:^(NSError *error) {
    }];
    
    [[CoreDataManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
        NSLog(@"数据---%@",results);
        //全部删除
        for (NSManagedObject *obj in results){
            [[CoreDataManager sharedInstance] deleteEntity:obj success:^{
            } fail:^(NSError *error) {
            }];
        }
    } fail:^(NSError *error) {
        
    }];
    [[CoreDataManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
        NSLog(@"数据---%@",results);
    } fail:^(NSError *error) {
        
    }];

//    [[CoreDataManager sharedInstance] insertNewEntity:dict success:^{
//        NSLog(@"成功");
//    } fail:^(NSError *error) {
//        NSLog(@"失败");
//    }];
    
//    [[CoreDataManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
//        NSLog(@"数据---%@",results);
//        if (results.count>0) {
//            //更新某个
//            NSManagedObject * model = [results firstObject];
//            [model setValue:@"xiugaile title" forKey:@"title"];
//            [model setValue:@"xiugaile content" forKey:@"content"];
//            [[CoreDataManager sharedInstance] updateEntity:^{
//            } fail:^(NSError *error) {
//            }];
//        }
//    } fail:^(NSError *error) {
//
//    }];
//
//    [[CoreDataManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results) {
//        NSLog(@"数据---%@",results);
//    } fail:^(NSError *error) {
//
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
