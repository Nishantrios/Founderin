//
//  MySingleton.m
//  Founderin
//
//  Created by Neuron on 11/27/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton

static MySingleton* _sharedMySingleton = nil;

+(MySingleton*)sharedMySingleton
{
    @synchronized([MySingleton class])
    {
        if (!_sharedMySingleton)
            //[[self alloc] init];
        
        return _sharedMySingleton;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([MySingleton class])
    {
        NSAssert(_sharedMySingleton == nil,
                 @"Attempted to allocate a second instance of a singleton.");
        _sharedMySingleton = [super alloc];
        return _sharedMySingleton;
    }
    
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        // initialize stuff here
    }
    
    return self;
}

@end