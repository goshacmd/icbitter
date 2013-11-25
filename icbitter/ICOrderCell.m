//
//  ICOrderCell.m
//  icbitter
//
//  Created by Gosha Arinich on 11/17/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICOrderCell.h"

@implementation ICOrderCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILabel *directionLabel = [[UILabel alloc] init];
        directionLabel.textColor = [UIColor darkGrayColor];
        directionLabel.font = [UIFont systemFontOfSize:17.0f];
        directionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:directionLabel];
        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.textColor = [UIColor darkGrayColor];
        statusLabel.font = [UIFont systemFontOfSize:17.0f];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:statusLabel];
        
        UILabel *quantityLabel = [[UILabel alloc] init];
        quantityLabel.textColor = [UIColor blackColor];
        quantityLabel.font = [UIFont systemFontOfSize:17.0f];
        quantityLabel.textAlignment = NSTextAlignmentCenter;
        quantityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:quantityLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.font = [UIFont systemFontOfSize:17.0f];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:priceLabel];

        self.directionLabel = directionLabel;
        self.statusLabel = statusLabel;
        self.quantityLabel = quantityLabel;
        self.priceLabel = priceLabel;
        
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    UILabel *directionLabel = self.directionLabel;
    UILabel *statusLabel = self.statusLabel;
    UILabel *quantityLabel = self.quantityLabel;
    UILabel *priceLabel = self.priceLabel;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(directionLabel, statusLabel, quantityLabel, priceLabel);
    
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[directionLabel(>=35)]-11-[statusLabel(>=50)]-11-[quantityLabel(>=directionLabel)]-11-[priceLabel(>=directionLabel)]-14-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    
    [self.contentView addConstraints:constraints];
    
    [@[directionLabel, statusLabel, quantityLabel, priceLabel] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    [self.directionLabel invalidateIntrinsicContentSize];
    [self.statusLabel invalidateIntrinsicContentSize];
    [self.quantityLabel invalidateIntrinsicContentSize];
    [self.priceLabel invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

@end
