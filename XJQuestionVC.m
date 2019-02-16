//
//  XJQuestionVC.m
//  demo
//
//  Created by 曾宪杰 on 2019/2/15.
//  Copyright © 2019 zengxianjie. All rights reserved.
//

#import "XJQuestionVC.h"
#import "ProblemEntity.h"
#import "ProblemCell.h"

static NSString *const qIdinifier = @"questioncell";

@interface XJQuestionVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView      *tabelView;
@property(nonatomic, strong)NSMutableArray   *dataArr;

@end

@implementation XJQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    
    //tab
    self.dataArr = [NSMutableArray array];
    [self initData];
    
    [self setBody];
    
    UIImage *aimage = [UIImage imageNamed:@"返回"];
    UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBody{
    
    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.backgroundColor = [UIColor whiteColor];
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tabelView];
    
    if (@available(iOS 11.0,*)) {
        self.tabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tabelView.estimatedRowHeight = 0;
        self.tabelView.estimatedSectionFooterHeight = 0;
        self.tabelView.estimatedSectionHeaderHeight = 0;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
}

- (void)initData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"GetMInfo" ofType:@"json"];
    NSString *jsonContent=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (jsonContent != nil)
    {
        NSData *jsonData = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&err];
        NSArray *textList = [dic objectForKey:@"GetMList"];
        for (NSDictionary *dict in textList)
        {
            ProblemEntity *entity = [[ProblemEntity alloc]initWithDict:dict];
            if (entity)
            {
                [self.dataArr addObject:entity];
            }
        }
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
        }
    }
}

#pragma  mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ProblemCell *cell = (ProblemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[ProblemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.dataArr count] > indexPath.row)
    {
        //这里的判断是为了防止数组越界
        cell.entity = [self.dataArr objectAtIndex:indexPath.row];
    }
    //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
    cell.showMoreTextBlock = ^(UITableViewCell *currentCell){
        NSIndexPath *indexRow = [self->_tabelView indexPathForCell:currentCell];
        [self.tabelView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProblemEntity *entity = nil;
    if ([self.dataArr count] > indexPath.row)
    {
        entity = [self.dataArr objectAtIndex:indexPath.row];
    }
    
    //根据isShowMoreText属性判断cell的高度
    if (entity.isShowMoreText)
    {
        return [ProblemCell cellMoreHeight:entity];
    }
    else
    {
        return [ProblemCell cellDefaultHeight:entity];
    }
    return 0;
}

@end
