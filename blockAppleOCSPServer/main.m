#import <Foundation/Foundation.h>
#import "../utils.h"

void blockAppleOCSPServer(void) {
    NSString *hostsFile = [NSString stringWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:nil];

    NSRegularExpression *ipv4RegExp = [NSRegularExpression regularExpressionWithPattern:@"^127.0.0.1[\\s|\t]+ocsp.apple.com$" options:0 error:nil];
    NSRegularExpression *ipv6RegExp = [NSRegularExpression regularExpressionWithPattern:@"^::1[\\s|\t]+ocsp.apple.com$" options:0 error:nil];

    NSTextCheckingResult *ipv4IsMatched = [ipv4RegExp firstMatchInString:hostsFile options:0 range:NSMakeRange(0, hostsFile.length)];
    NSTextCheckingResult *ipv6IsMatched = [ipv6RegExp firstMatchInString:hostsFile options:0 range:NSMakeRange(0, hostsFile.length)];

    // already blocked
    if (ipv4IsMatched && ipv6IsMatched) {
        return;
    }

    FILE *file = fopen("/etc/hosts","a");

    if (!ipv4IsMatched) {
        fprintf(file, "127.0.0.1    ocsp.apple.com\n");
    }

    if (!ipv6IsMatched){
        fprintf(file, "::1    ocsp.apple.com\n");
    }

    fclose(file);
    run("killall -9 mDNSResponder");
    NSLog(@"Apple OCSP server blocked successfully");
}

int main(int argc, char **argv, char **envp) {
    blockAppleOCSPServer();
    return 0;
}

