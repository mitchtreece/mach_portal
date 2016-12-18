#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <sys/utsname.h>

#include "offsets.h"

#import <Foundation/Foundation.h>

// offsets from the main kernel 0xfeedfacf
uint64_t allproc_offset;
uint64_t kernproc_offset;

// offsets in struct proc
uint64_t struct_proc_p_pid_offset;
uint64_t struct_proc_task_offset;
uint64_t struct_proc_p_uthlist_offset;
uint64_t struct_proc_p_ucred_offset;
uint64_t struct_proc_p_comm_offset;

// offsets in struct kauth_cred
uint64_t struct_kauth_cred_cr_ref_offset;

// offsets in struct uthread
uint64_t struct_uthread_uu_ucred_offset;
uint64_t struct_uthread_uu_list_offset;

// offsets in struct task
uint64_t struct_task_ref_count_offset;
uint64_t struct_task_itk_space_offset;

// offsets in struct ipc_space
uint64_t struct_ipc_space_is_table_offset;

// offsets in struct ipc_port
uint64_t struct_ipc_port_ip_kobject_offset;

void init_macos_10_12_1() {
    
    printf("Setting offsets for macOS 10.12.1\n");
    
    allproc_offset = 0x8bb490;
    kernproc_offset = 0x8BA7D8;
    
    struct_proc_task_offset = 0x18;
    struct_proc_p_uthlist_offset = 0x98;
    struct_proc_p_ucred_offset = 0xe8;
    struct_proc_p_comm_offset = 0x2e4;
    
    struct_kauth_cred_cr_ref_offset = 0x10;
    
    struct_uthread_uu_ucred_offset = 0x168;
    struct_uthread_uu_list_offset = 0x170;
    
    struct_task_ref_count_offset = 0x10;
    struct_task_itk_space_offset = 0x300;
    
    struct_ipc_space_is_table_offset = 0x18;
    struct_ipc_port_ip_kobject_offset = 0x68;
    
}

void unknown_build() {
    
    printf("This is an unknown kernel build - the offsets are likely incorrect.\n");
    printf("You need to find these two kernel symbols:\n");
    printf("\tallproc\n");
    printf("\tkernproc\n\n");
    printf("and add them to the devices plist.\n\n");
    
}

void init_offsets_from_plist() {
    
    struct utsname u = {0};
    int err = uname(&u);
    if (err == -1) {
        printf("uname failed - what platform is this?\n\n");
        return;
    }
    
    printf("sysname:  %s\n", u.sysname);
    printf("nodename: %s\n", u.nodename);
    printf("release:  %s\n", u.release);
    printf("version:  %s\n", u.version);
    printf("machine:  %s\n\n", u.machine);
    
    NSURL *devicesUrl = [[NSBundle mainBundle] URLForResource:@"Devices" withExtension:@"plist"];
    NSArray *devices = [NSArray arrayWithContentsOfURL:devicesUrl];
    
    for (NSDictionary *device in devices) {
        
        NSString *name = device[@"name"];
        NSString *identifier = device[@"identifier"];
        NSString *version = device[@"version"];
        NSString *build = device[@"build"];
        NSString *kernel = device[@"kernel"];
        NSString *allproc = device[@"offsets"][@"allproc"];
        NSString *kernproc = device[@"offsets"][@"kernproc"];
        
        if(strstr(u.machine, [identifier cStringUsingEncoding:NSUTF8StringEncoding])) {
            
            if (!strstr(u.version, [kernel UTF8String])) {
                unknown_build();
                return;
            }
            
            printf("** Setting device offsets for %s: iOS %s (%s) **\n\n", [name UTF8String], [version UTF8String], [build UTF8String]);
            
            uint64_t _allproc;
            uint64_t _kernproc;
            
            NSScanner *allproc_scanner = [NSScanner scannerWithString:allproc];
            BOOL allproc_success = [allproc_scanner scanHexLongLong:&_allproc];
            
            NSScanner *kernproc_scanner = [NSScanner scannerWithString:kernproc];
            BOOL kernproc_success = [kernproc_scanner scanHexLongLong:&_kernproc];
            
            if (!allproc_success || !kernproc_success) {
                printf("Failed to get device offsets");
                return;
            }
            
            allproc_offset = _allproc;
            kernproc_offset = _kernproc;
            
            struct_proc_p_pid_offset = 0x10;
            struct_proc_task_offset = 0x18;
            struct_proc_p_uthlist_offset = 0x98;
            struct_proc_p_ucred_offset = 0x100;
            struct_proc_p_comm_offset = 0x26c;
            
            struct_kauth_cred_cr_ref_offset = 0x10;
            
            struct_uthread_uu_ucred_offset = 0x168;
            struct_uthread_uu_list_offset = 0x170;
            
            struct_task_ref_count_offset = 0x10;
            struct_task_itk_space_offset = 0x300;
            
            struct_ipc_space_is_table_offset = 0x20;
            struct_ipc_port_ip_kobject_offset = 0x68;
            
            return;
            
        }
        
    }
    
    printf("Platform not recognized\n\n");
    unknown_build();
    
}

void init_offsets() {
    
    init_offsets_from_plist();
    
}
