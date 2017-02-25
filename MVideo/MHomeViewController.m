//
//  MHomeViewController.m
//  MVideo
//
//  Created by LHL on 17/2/15.
//  Copyright © 2017年 LHL. All rights reserved.
//

#import "MHomeViewController.h"
#import "ListViewController.h"

#define FileNamePre         @"直播列表"
#define TVHostURL           @"https://lihongli528628.github.io/text/"
#define VideosTVListName    @"VideosTVListName.txt"

@interface MHomeViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self operationStr];
    [self requestNetWorkData];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeTableViewCell"];
}

- (void)operationStr{
    [self.dataSource addObject:@{@"title":@"已测试可播放列表",
                                 @"filePath":[ListViewController getResultDocumentFilePath]}];
    
    for (NSInteger count = 1 ; count < NSIntegerMax; count ++) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@",FileNamePre,@(count)];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self.dataSource addObject:@{@"title":fileName,
                                         @"filePath":filePath}];
        }else {
            NSLog(@"%@.txt不存在", fileName);
            break;
        }
    }
}

- (void)requestNetWorkData{
    NSString *videosTVListNameUrl = [NSString stringWithFormat:@"%@%@", TVHostURL,VideosTVListName];
    __block NSError *error = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *videoList = [NSString stringWithContentsOfURL:[NSURL URLWithString:videosTVListNameUrl] encoding:NSUTF8StringEncoding error:&error];
        error ? NSLog(@"%@", error) : nil;
        NSArray *titleArray = [videoList componentsSeparatedByString:@"\n"];
        for (NSString *title in titleArray) {
            [self.dataSource addObject:@{@"title":title,
                                         @"filePath":[NSString stringWithFormat:@"%@%@", TVHostURL, title]}];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    ListViewController *listVC = [[ListViewController alloc] init];
    listVC.dict = dict;
    [self.navigationController pushViewController:listVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
