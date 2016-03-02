//
//  ViewController.m
//  DictionaryApp
//
//  Created by Fikirte Derso on 2/29/16.
//  Copyright (c) 2016 Fikirte Derso. All rights reserved.
//





#import "ViewController.h"
#import <AFNetworking.h>
#import "CustomeTableViewCell.h"
#import "MBProgressHUD.h"


@interface ViewController () 


@property (weak, nonatomic) IBOutlet UITextField *lookUpTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * responseArray;
@property (nonatomic, strong) NSMutableDictionary * resposnseDict;

@property (nonatomic, strong) MBProgressHUD * hud;

- (IBAction)lookupBtnPressed:(UIButton *)sender;



@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [_lookUpTextField setDelegate:self];
   
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud hide:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count %i", [_responseArray count]);
    return [_responseArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    CustomeTableViewCell * cell = (CustomeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
     [_hud hide:YES];
        NSDictionary  * dict = [_responseArray objectAtIndex:indexPath.row];
    
        cell.wordLbl.text = [dict valueForKey:@"Word"];
        cell.formLbl.text = [dict valueForKey:@"PartOfSpeech"];
    
        
        NSArray *array = [dict valueForKey:@"Definitions"];
        cell.definitionLbl.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:0]];

    
    
    return cell;
}


-(void)fetchDataFor:(NSString*)word
{
    //1. Create the URL instace with the URL address
    NSString * requestString = @"http://dictionaryapi.net/api/definition/";
  
   
    
    AFHTTPRequestOperationManager * operationM = [AFHTTPRequestOperationManager manager];
    operationM.responseSerializer = [AFJSONResponseSerializer serializer];
    operationM.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [operationM GET:requestString parameters:@{@"Word": word} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _responseArray = responseObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
        });
        
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Empty field" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [_hud hide:YES];
        [alertView show];
        
    }];
    

    
}


- (IBAction)lookupBtnPressed:(UIButton *)sender {
    
    [_hud show:YES];
    if (![_lookUpTextField.text  isEqual: @""])
    {
        if ([_responseArray count] == 0)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Not Found" message:@"No definition found for the word entered." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
        [self fetchDataFor:_lookUpTextField.text];
        
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Empty field" message:@"Please enter a word to look up." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

@end