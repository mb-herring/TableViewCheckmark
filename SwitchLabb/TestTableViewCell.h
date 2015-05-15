//
//  TestTableViewCell.h
//  TableViewCheckMark
//
//  Created by Martin Borstrand on 2015-05-14.
//  Copyright (c) 2015 Martin Borstrand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@end
