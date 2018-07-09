#import <Foundation/Foundation.h>
#import "../utils.h"

void unblockAppleOCSPServer(void) {
    NSString *hostsFile = [NSString stringWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:nil];
    if ([hostsFile rangeOfString:@"\n127.0.0.1    ocsp.apple.com\n"].location != NSNotFound){
        FILE *file = fopen("/etc/hosts","w");
        fprintf(file, "%s", [[hostsFile stringByReplacingCharactersInRange:[hostsFile rangeOfString:@"127.0.0.1    ocsp.apple.com\n"] withString:@""] UTF8String]);
        fclose(file);
        
        run("killall -9 mDNSResponder");
        
        NSLog(@"Apple OCSP server unblocked successfully");
    }
}

int main(int argc, char **argv, char **envp) {
    unblockAppleOCSPServer();
    return 0;
}

