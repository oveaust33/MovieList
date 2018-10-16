

#import "API.h"


@interface API() {
    
    NSURL* url;
    NSData* postdata;
    NSMutableArray *apiDataArray;
    NSDictionary* headers;
    NSString* api_Name;

}

@end



@implementation API


-(id)initWithUrl:(NSString*)urlString apiName:(NSString*)apiName PostData:(NSData*)data{
    self=[super init];
    
    url = [NSURL URLWithString:urlString];
    postdata = data;
    api_Name = apiName;
    return self;
}


-(void)accessAPI:(NSString*)accessType Synchronous:(BOOL)synchronous {
    
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:0 timeoutInterval:10];
    [request setTimeoutInterval:20];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    
    
    [request setHTTPMethod: accessType];
    [request setHTTPBody:postdata];
    
    for(NSString*key in headers.allKeys){
        NSString* value=[NSString stringWithFormat:@"%@",headers[key]];
        [request addValue:value forHTTPHeaderField:key];
    }
    
    
    if(synchronous){
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block NSData *data = nil;
        __block  NSURLResponse  *response=nil;
        __block NSError   *error=nil;
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *taskResponse, NSError *taskError) {
            
            data = taskData;
            
            if (taskResponse) {
                response = taskResponse;
            }
            if (error) {
                error = taskError;
            }
            
            dispatch_semaphore_signal(semaphore);
            
        }] resume];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSHTTPURLResponse *httpRespons=(NSHTTPURLResponse*)response;
        
        [self procesServiceResponse:httpRespons withReturnedData:data];
    }
    
    else{
        
        NSURLSessionDataTask * dataTask =[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(error == nil){
            }
            
            [self procesServiceResponse:(NSHTTPURLResponse*)response withReturnedData:data];
            
        }];
        
        [dataTask resume];
        
    }
    
}

-(void)procesServiceResponse:(NSHTTPURLResponse*)response withReturnedData:(NSData *)returnData{
   
    
    id jsonData;
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        long status = [httpResponse statusCode];
        
        if (!((status >= 200) && (status < 300))){
            NSLog(@"Connection failed with status %ld", status);
        }
        
        else{
            NSLog(@"<Responsed>");
        }
        
        jsonData=[NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];

    }
    else{
        NSLog(@"<Respons Error>");
      
    }

    
    if(_delegate){
        
        if([_delegate respondsToSelector:@selector(apiDidExecute:apiName:data:)]){
            [self.delegate apiDidExecute:self apiName:api_Name data:jsonData];
        }
    }
   
}





@end
