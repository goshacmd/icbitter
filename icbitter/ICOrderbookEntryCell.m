//
//  ICOrderbookEntryCell.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICOrderbookEntryCell.h"

@implementation ICOrderbookEntryCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILabel *leftQuantityLabel = [[UILabel alloc] init];
        leftQuantityLabel.textColor = [UIColor darkGrayColor];
        leftQuantityLabel.font = [UIFont systemFontOfSize:15.0f];
        leftQuantityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:leftQuantityLabel];
        
        UILabel *rightQuantityLabel = [[UILabel alloc] init];
        rightQuantityLabel.textColor = [UIColor darkGrayColor];
        rightQuantityLabel.font = [UIFont systemFontOfSize:15.0f];
        rightQuantityLabel.textAlignment = NSTextAlignmentRight;
        rightQuantityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:rightQuantityLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.font = [UIFont systemFontOfSize:15.0f];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:priceLabel];
        
        self.leftQuantityLabel = leftQuantityLabel;
        self.rightQuantityLabel = rightQuantityLabel;
        self.priceLabel = priceLabel;
        
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    UILabel *leftQuantityLabel = self.leftQuantityLabel;
    UILabel *rightQuantityLabel = self.rightQuantityLabel;
    UILabel *priceLabel = self.priceLabel;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(leftQuantityLabel, rightQuantityLabel, priceLabel);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[leftQuantityLabel(>=50)]-22-[priceLabel(>=75)]-22-[rightQuantityLabel(==leftQuantityLabel)]-14-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    
    [self.contentView addConstraints:constraints];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.priceLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    
    [@[leftQuantityLabel, priceLabel, rightQuantityLabel] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    [self.leftQuantityLabel invalidateIntrinsicContentSize];
    [self.rightQuantityLabel invalidateIntrinsicContentSize];
    [self.priceLabel invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

@end
