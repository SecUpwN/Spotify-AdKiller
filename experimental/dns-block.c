#define _GNU_SOURCE

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <string.h>

#include <dlfcn.h>
//#include <stdlib.h>
//#include <stdarg.h>

#include <fnmatch.h>

#define WHITELIST_LENGTH   9
#define BLACKLIST_LENGTH   3

const char *hostname_whitelist[WHITELIST_LENGTH] =
    { "*.spotify.com", "*.cloudfront.net", "api.tunigo.com", "apic.musixmatch.com", "scontent.xx.fbcdn.net", "mxmscripts.s3.amazonaws.com", "artistheader.scdn.co", "profile-images.scdn.co", "i.scdn.co" };
    
const char *hostname_blacklist[BLACKLIST_LENGTH] =
    { "adeventtracker.spotify.com", "audio-sp-ash.spotify.com", "spclient.wg.spotify.com" };
 
int getaddrinfo(const char *hostname, const char *service,
                const struct addrinfo *hints, struct addrinfo **res)
{
    printf("getaddrinfo request: '%s' '%s' ", hostname, service);
    
    int block = 1;
    
    int i;
    for (i = 0; i < WHITELIST_LENGTH; i++) {
        if (fnmatch(hostname_whitelist[i], hostname, FNM_NOESCAPE) == 0) {
            block = 0;
            break;
        }
    }
    
    for (i = 0; i < BLACKLIST_LENGTH; i++) {
        if (fnmatch(hostname_blacklist[i], hostname, FNM_NOESCAPE) == 0) {
            block = 1;
            break;
        }
    }
    
    if (block) {
        printf("BLOCKED\n");
        return -1;
    } else {
        printf("ALLOWED\n");
    }
    
    static typeof(getaddrinfo) *old_getaddrinfo = NULL;
    
    if (!old_getaddrinfo) {
        old_getaddrinfo = dlsym(RTLD_NEXT, "getaddrinfo");
    }
    
    if (!old_getaddrinfo) {
        printf("can't find regular getaddrinfo function\n");
        return -1;
    }
    
    return old_getaddrinfo(hostname, service, hints, res);
}
