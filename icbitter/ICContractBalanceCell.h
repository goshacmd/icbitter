//
//  ICContractBalanceCell.h
//  icbitter
//
//  Created by Gosha Arinich on 11/14/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

@interface ICContractBalanceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *unrealizedPLLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialMarginLabel;
@property (weak, nonatomic) IBOutlet UILabel *execPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
