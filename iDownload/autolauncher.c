#include <stdio.h>
#include <CoreFoundation/CoreFoundation.h>
#include <sys/sysctl.h>

bool SBSOpenSensitiveURLAndUnlock(CFURLRef url, char flags);

// https://stackoverflow.com/a/36204023
int uptime() {
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;

    (void)time(&now);

    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - boottime.tv_sec;
    }
    return uptime;
}

__attribute__((constructor))
static int dylibMain() {
    if (uptime() >= 120) return 1;
    
    // https://github.com/comex/sbsutils/blob/master/sbopenurl.c
    CFURLRef cu = CFURLCreateWithBytes(NULL, "diagnostics://boot", 18, kCFStringEncodingUTF8, NULL);
    if (!cu) {
        fprintf(stderr, "Invalid URL\n");
    }
    bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
    if (!ret) {
        fprintf(stderr, "SBSOpenSensitiveURLAndUnlock failed\n");
    }
    
    return 0;
}
