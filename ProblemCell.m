//
//  ProblemCell.m
//  XiaoHeiKa
//
//  Created by Hyperion on 2019/2/11.
//  Copyright © 2019 Anonymous. All rights reserved.
//

#import "ProblemCell.h"
#import "Masonry.h"

#define HEIGHT 1
#define WIDTH 1

@interface ProblemCell()
{
    UILabel      *_textTitle;
    UILabel      *_textContent;
    UIButton     *_moreTextBtn;
}
@end

@implementation ProblemCell


+ (CGFloat)cellDefaultHeight:(ProblemEntity *)entity
{
    //默认cell高度
    return 60.0*HEIGHT;
}

+ (CGFloat)cellMoreHeight:(ProblemEntity *)entity
{
    //展开后得高度(计算出文本内容的高度+固定控件的高度)
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [entity.textContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 100000) options:option attributes:attribute context:nil].size;;
    return size.height + 85*HEIGHT;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 16*HEIGHT, SCREEN_HEIGHT, 50*HEIGHT)];
    
        titleView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:titleView];
        
        UIView *lind = [[UIView alloc] initWithFrame:CGRectMake(8, 17, 5, 15)];
        lind.backgroundColor = XJBlue;
        [titleView addSubview:lind];
        
        _textTitle = [[UILabel alloc]init];
        _textTitle.textColor = [UIColor blackColor];
        _textTitle.font = [UIFont systemFontOfSize:14];
        [titleView addSubview:_textTitle];
        
        [_textTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17*1);
            make.centerY.mas_equalTo(0);
        }];
        
        _textContent = [[UILabel alloc]initWithFrame:CGRectMake(15*WIDTH, 75*HEIGHT,SCREEN_WIDTH - 30*WIDTH , 0)];
        _textContent.textColor = [UIColor blackColor];
        _textContent.font = [UIFont systemFontOfSize:14];
        _textContent.numberOfLines = 0;
        [titleView addSubview:_textContent];
        
        _moreTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreTextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _moreTextBtn.frame = CGRectMake(0,0,SCREEN_HEIGHT,50*HEIGHT);
        [titleView addSubview:_moreTextBtn];
        [_moreTextBtn addTarget:self action:@selector(showMoreText) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textTitle.text = self.entity.textName;
    
    _textContent.text = self.entity.textContent;
    if (self.entity.isShowMoreText)
    {
        ///计算文本高度
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14*HEIGHT]};
        NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
        CGSize size = [self.entity.textContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30*WIDTH, 100000) options:option attributes:attribute context:nil].size;
        [_textContent setFrame:CGRectMake(15*WIDTH, 65*HEIGHT, SCREEN_WIDTH - 30*WIDTH, size.height)];
    
        
    }
    else
    {

        [_textContent setFrame:CGRectMake(15*WIDTH, 65*HEIGHT, SCREEN_WIDTH - 30*WIDTH, 0)];
    }
    
}

- (void)showMoreText
{
    //将当前对象的isShowMoreText属性设为相反值
    self.entity.isShowMoreText = !self.entity.isShowMoreText;
    if (self.showMoreTextBlock)
    {
        self.showMoreTextBlock(self);
    }
}
@end
