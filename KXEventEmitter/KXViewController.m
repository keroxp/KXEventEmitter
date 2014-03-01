//
//  KXViewController.m
//  KXEventEmitter
//
//  Created by keroxp on 2014/03/01.
//  Copyright (c) 2014年 keroxp. All rights reserved.
//

#import "KXViewController.h"
#import "NSObject+KXEventEmitter.h"

@interface KXViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation KXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self kx_on:@"event" handler:^(NSNotification *n) {
        self.seg.selectedSegmentIndex = (self.seg.selectedSegmentIndex == 0) ? 1: 0;
        [self kx_emit:@"seg" userInfo:@{@"index":@(self.seg.selectedSegmentIndex)}];
    }];
    [self kx_on:@"seg" handler:^(NSNotification *n) {
        self.lab.text = [[[n userInfo] objectForKey:@"index"] stringValue];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emit:(id)sender {
    [self kx_emit:@"event"];
}


@end
