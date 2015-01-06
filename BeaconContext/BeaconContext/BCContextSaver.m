//
//  BCContextSaver.m
//  BeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BCContextSaver.h"

@interface BCContextSaver ()

@property (nonatomic, strong) NSMutableDictionary* context;
@property (nonatomic, strong) NSMutableArray* beacons;
@property (nonatomic, strong) NSMutableDictionary* user;

@end

@implementation BCContextSaver


- (instancetype)init
{
    self = [super init];
    if (self) {
        _beacons = [NSMutableArray new];
        _user = [NSMutableDictionary new];
        _context = [[NSMutableDictionary alloc] init];
        [_context setObject:_beacons forKey:@"beacons"];
        [_context setObject:_user forKey:@"user"];
    }
    return self;
}



-(void) foundBeacon:(BCBeacon *)beacon
{
    
    NSMutableDictionary* beaconDict = [NSMutableDictionary new];
    
    [beaconDict setObject:beacon.major forKey:@"major"];
    [beaconDict setObject:beacon.minor forKey:@"minor"];
    [beaconDict setObject:beacon.seen forKey:@"seen"];
    [beaconDict setObject:beacon.type forKey:@"type"];
    [beaconDict setObject:beacon.uuidNormalized forKey:@"uuid"];
    
    [self.beacons addObject:beaconDict];
}

-(void) foundUserInformation:(NSString*) name value:(NSString*) value
{
    [self.user setObject:value forKey:name];
}


-(NSString*) jsonString
{
    NSError* error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.context options:kNilOptions error:&error];
    
    if(jsonData)
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSLog(@"%@", error);
        return nil;
    }
}

@end
