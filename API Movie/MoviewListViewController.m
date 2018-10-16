//
//  MoviewListViewController.m
//  API Movie
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 Digicon. All rights reserved.
//

#import "MoviewListViewController.h"

static NSString *MovieDomain = @"https://api.themoviedb.org";
static NSString *Movie_Token = @"888e98010b8b073de114f1824bb1257b";
static NSString *Movie_Token2 = @"4df263f48a4fe2621749627f5d001bf0";





@interface MoviewListViewController (){
    
    NSArray *dataArray;
    API *apiClass;

}

@end

@implementation MoviewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.dataListTableView.delegate  = self;
    self.dataListTableView.dataSource = self;
    
    
}

-(IBAction)rattedAction:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@/3/movie/top_rated?api_key=%@&page=1", MovieDomain,  Movie_Token];
    
    [self performSelector:@selector(showLoadingView:) onThread:[NSThread mainThread] withObject:@"Getting data, please wait..." waitUntilDone:YES];
    [self performSelector:@selector(getMovie:) withObject:url afterDelay:0.01];
}


- (IBAction)favouriteAction:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/3/movie/upcoming?api_key=%@&page=1", MovieDomain,  Movie_Token];
    
    [self performSelector:@selector(showLoadingView:) onThread:[NSThread mainThread] withObject:@"Getting data, please wait..." waitUntilDone:YES];
    [self performSelector:@selector(getMovie:) withObject:url afterDelay:0.01];
}


- (IBAction)recentAction:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/3/movie/now_playing?api_key=%@&page=1", MovieDomain,  Movie_Token];
    
    [self performSelector:@selector(showLoadingView:) onThread:[NSThread mainThread] withObject:@"Getting data, please wait..." waitUntilDone:YES];
    [self performSelector:@selector(getMovie:) withObject:url afterDelay:0.01];
}




- (IBAction)dummayButtonAction:(id)sender {
    
    [self performSelector:@selector(showLoadingView:) onThread:[NSThread mainThread] withObject:@"Getting data, please wait..." waitUntilDone:YES];
    [self performSelector:@selector(dummydata) withObject:nil afterDelay:0.01];
    
}

-(void)dummydata{
    
    NSString *url = @"https://jsonplaceholder.typicode.com/photos";
    
    apiClass = [[API alloc] initWithUrl:url apiName:@"jsonplaceholder" PostData:nil];
    apiClass.delegate = self;
    [apiClass accessAPI:@"GET" Synchronous:YES];
}

-(void)apiDidExecute:(API *)api apiName:(NSString *)apiName data:(id)data{
    
    [self CloseLoadingView];
    
    if([apiName isEqualToString:@"jsonplaceholder"]){
        
        
        if ([data isKindOfClass:[NSArray class]]) {
            dataArray  = [[NSArray alloc] initWithArray:data];
        }
        else {
            dataArray  = [[NSArray alloc] init];
        }
        
        [self.dataListTableView reloadData];
    }
    else {
        id result = [data objectForKey:@"results"];
        
        if (result) {
            if ([result isKindOfClass:[NSArray class]]) {
                dataArray  = [[NSArray alloc] initWithArray:result];
            }
            else {
                dataArray  = [[NSArray alloc] init];
            }
            
            [self.dataListTableView reloadData];
        }
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic  = [dataArray objectAtIndex:indexPath.row];
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableViewCellID"];
    cell.itemNameLabel.text = [dataDic objectForKey:@"title"];
    
    NSString *overview = [dataDic objectForKey:@"overview"];
    
    if(overview) {
        cell.itemDescTextView.text = overview;
    }
    else {
        cell.itemDescTextView.text = [dataDic objectForKey:@"url"];
    }
    
    NSString *poster = [dataDic objectForKey:@"poster_path"];
    
    if (poster){
        NSString *s = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500%@?api_key=%@",[dataDic objectForKey:@"poster_path"], Movie_Token];
        NSURL *url = [NSURL URLWithString:s];
        [cell.itemImageView sd_setImageWithURL:url placeholderImage:nil];
    }
    else{
        NSURL *url = [NSURL URLWithString:[dataDic objectForKey:@"thumbnailUrl"]];
        [cell.itemImageView sd_setImageWithURL:url placeholderImage:nil];
    }
    
    
    return cell;
}


-(void)showLoadingView:(NSString*)text{
    [[LoadingView alloc] initWithText:text Delegate:self];
    [LoadingView Show];
}

-(void)CloseLoadingView{
    [LoadingView Close];
}

-(void)getMovie:(NSString*)url{
    
    apiClass = [[API alloc] initWithUrl:url apiName:@"Movie" PostData:nil];
    apiClass.delegate = self;
    [apiClass accessAPI:@"GET" Synchronous:YES];
}



@end
