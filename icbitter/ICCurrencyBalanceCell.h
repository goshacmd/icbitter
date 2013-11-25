//
//  ICCurrencyBalanceCell.h
//  icbitter
//
//  Created by Gosha Arinich on 11/14/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

@interface ICCurrencyBalanceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *netValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *marginPercentLabel;

@end
