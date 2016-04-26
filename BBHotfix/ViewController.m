//
//  ViewController.m
//  BBHotfix
//
//  Created by Gary on 4/25/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "ViewController.h"
#import "BBHotfix/BBHotfix.h"
#import "OtherViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Push TableViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn2 setTitle:@"sync" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(handleBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn3 setTitle:@"Push Other ViewController" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(handleBtn3:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleBtn:(id)sender {
}

- (void)handleBtn2:(id)sender {
    [[BBHotfix sharedInstance] sync];
}

- (void)handleBtn3:(id)sender {
    
    OtherViewController *otherViewController = [[OtherViewController alloc] init];
    [self.navigationController pushViewController:otherViewController animated:YES];
}

@end
