#include <stdio.h>
#include <CoreFoundation/CoreFoundation.h>

bool SBSOpenSensitiveURLAndUnlock(CFURLRef url, char flags);

__attribute__((constructor))
static int dylibMain() {
    // https://github.com/comex/sbsutils/blob/master/sbopenurl.c
    CFURLRef cu = CFURLCreateWithBytes(NULL, "diagnostics://", 14, kCFStringEncodingUTF8, NULL);
    if (!cu) {
        fprintf(stderr, "Invalid URL\n");
    }
    bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
    if (!ret) {
        fprintf(stderr, "SBSOpenSensitiveURLAndUnlock failed\n");
    }
    
    return 0;
}
