//
//  MPNetworkHelper.m
//  mach_portal
//
//  Created by Mitch Treece on 12/17/16.
//  Copyright © 2016 Ian Beer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#include "MPNetworkHelper.h"

@implementation MPNetworkHelper

+ (NSString *)ip_address {
    
    NSString *address = @"<unknown_ip_address>";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *addr = NULL;
    
    int addrs = getifaddrs(&interfaces);
    
    if (addrs == 0) {
        
        addr = interfaces;
        
        while (addr != NULL) {
            
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                }
            }
            
            addr = addr->ifa_next;
            
        }
        
    }
    
    freeifaddrs(interfaces);
    return address;
    
}

@end
