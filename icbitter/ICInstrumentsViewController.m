//
//  ICInstrumentsViewController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/14/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICInstrumentsViewController.h"
#import "ICBITInstrument+Format.h"
#import "ICDataSource.h"

@interface ICInstrumentsViewController ()

- (void)instrumentsChanged:(NSNotification *)notification;

@end

@implementation ICInstrumentsViewController

- (void)instrumentsChanged:(NSNotification *)notification {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ticker"
                                                                     ascending:YES];
    self.instruments = [ICDataSource.sharedSource fetchModelsOfType:@"instrument"
                                                               sort:@[sortDescriptor]];
    
    [self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(instrumentsChanged:)
                                                 name:ICStoreInstrumentsNotification
                                               object:nil];
    
    [self instrumentsChanged:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *ticker = [self.instruments[indexPath.row] ticker];
    [segue.destinationViewController setTicker:ticker];
    [segue.destinationViewController setTitle:ticker];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instruments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"InstrumentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    ICBITInstrument *instrument = self.instruments[indexPath.row];
    
    cell.textLabel.text = instrument.name;
    cell.detailTextLabel.text = instrument.textDescription;
    
    return cell;
}

@end
