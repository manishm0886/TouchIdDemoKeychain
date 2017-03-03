//
//  ViewController.m
//  TouchIdKeychain
//
//  Created by Manish Kumar on 3/3/17.
//  Copyright © 2017 Manish Kumar. All rights reserved.
//

#import "ViewController.h"
#import "TouchIdManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *savedLabel;

@end

@implementation ViewController
- (IBAction)save:(id)sender {
    [TouchIdManager addKeychainPassword:@"Prabha"];
}
- (IBAction)fetch:(id)sender {
    [TouchIdManager fetchKeychainPassword:@"Kumari"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
