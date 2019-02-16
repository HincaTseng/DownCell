//
//  ProblemCell.h
//  XiaoHeiKa
//
//  Created by Hyperion on 2019/2/11.
//  Copyright © 2019 Anonymous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemEntity.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProblemCell : UITableViewCell

@property(nonatomic, strong) ProblemEntity *entity;
///展开多个活动信息
@property(nonatomic, copy) void (^showMoreTextBlock)(UITableViewCell  *currentCell);

///未展开时的高度
+ (CGFloat)cellDefaultHeight:(ProblemEntity *)entity;
///展开后的高度
+(CGFloat)cellMoreHeight:(ProblemEntity *)entity;
@end

NS_ASSUME_NONNULL_END
