#import <Foundation/Foundation.h>
#import "../utils.h"

void blockAppleOCSPServer(void) {
    NSString *hostsFile = [NSString stringWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:nil];
    if ([hostsFile rangeOfString:@"\n127.0.0.1    ocsp.apple.com\n"].location == NSNotFound){
        FILE *file = fopen("/etc/hosts","a");
        fprintf(file, "127.0.0.1    ocsp.apple.com\n");
        fclose(file);
        
        run("killall -9 mDNSResponder");
        
        NSLog(@"Apple OCSP server blocked successfully");
    }
}

int main(int argc, char **argv, char **envp) {
    blockAppleOCSPServer();
    return 0;
}

