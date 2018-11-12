#import <Foundation/Foundation.h>
#import "../utils.h"

void unblockAppleOCSPServer(void) {
    NSMutableString *hostsFile = [NSMutableString stringWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:nil];

    NSRegularExpression *ipv4RegExp = [NSRegularExpression regularExpressionWithPattern:@"^127.0.0.1[\\s|\t]+ocsp.apple.com$" options:0 error:nil];
    NSRegularExpression *ipv6RegExp = [NSRegularExpression regularExpressionWithPattern:@"^::1[\\s|\t]+ocsp.apple.com$" options:0 error:nil];

    NSTextCheckingResult *ipv4IsMatched = [ipv4RegExp firstMatchInString:hostsFile options:0 range:NSMakeRange(0, hostsFile.length)];
    NSTextCheckingResult *ipv6IsMatched = [ipv6RegExp firstMatchInString:hostsFile options:0 range:NSMakeRange(0, hostsFile.length)];

    // non blocked
    if (!ipv4IsMatched && !ipv6IsMatched) {
        return;
    }

    NSMutableArray *matches = [NSMutableArray array];

    if (ipv4IsMatched) {
        [matches addObjectsFromArray: [ipv4RegExp matchesInString:hostsFile options:0 range:NSMakeRange(0, hostsFile.length)]];
    }

    if (ipv6IsMatched){
        [matches addObjectsFromArray: [ipv6RegExp matchesInString:hostsFile options:0 range:NSMakeRange(0, hostsFile.length)]];
    }

    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult* match, NSUInteger idx, BOOL *stop) {
            [hostsFile deleteCharactersInRange:match.range];
    }];

    FILE *file = fopen("/etc/hosts","w");
    fprintf(file, "%s", [hostsFile UTF8String]);
    fclose(file);
    run("killall -9 mDNSResponder");
    NSLog(@"Apple OCSP server unblocked successfully");
}

int main(int argc, char **argv, char **envp) {
    unblockAppleOCSPServer();
    return 0;
}

