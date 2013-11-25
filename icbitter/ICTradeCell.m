//
//  ICTradeCell.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICTradeCell.h"

@implementation ICTradeCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.font = [UIFont systemFontOfSize:15.0f];
        priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:priceLabel];
        
        UILabel *quantityLabel = [[UILabel alloc] init];
        quantityLabel.textColor = [UIColor darkGrayColor];
        quantityLabel.font = [UIFont systemFontOfSize:15.0f];
        quantityLabel.textAlignment = NSTextAlignmentCenter;
        quantityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:quantityLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:13.0f];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:timeLabel];
        
        self.priceLabel = priceLabel;
        self.quantityLabel = quantityLabel;
        self.timeLabel = timeLabel;
        
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    UILabel *priceLabel = self.priceLabel;
    UILabel *quantityLabel = self.quantityLabel;
    UILabel *timeLabel = self.timeLabel;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(priceLabel, quantityLabel, timeLabel);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[priceLabel(>=75)]-22-[quantityLabel(>=50)]-22-[timeLabel(>=50)]-14-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    
    [self.contentView addConstraints:constraints];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.quantityLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    
    [@[priceLabel, quantityLabel, timeLabel] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:obj
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.priceLabel invalidateIntrinsicContentSize];
    [self.quantityLabel invalidateIntrinsicContentSize];
    [self.timeLabel invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

@end
