//
//  PreviousCostCell.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 4/14/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "PreviousCostCell.h"

@implementation PreviousCostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    /*
    if (!self)
        return self;
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // configure up some interesting display properties inside the cell
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, 147, 26)];
    [ _textLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    [ _textLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [self.contentView addSubview: _textLabel];
     */
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
