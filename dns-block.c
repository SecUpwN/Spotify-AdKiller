#define _GNU_SOURCE

#include <stdio.h>
#include <netdb.h>
#include <dlfcn.h>
#include <fnmatch.h>

static const char *hostname_whitelist[] = {
    "*.cloudfront.net",
    "*.scdn.co",
    "*.spotify.com",
    "api.tunigo.com",
    "apic.musixmatch.com",
    "mxmscripts.s3.amazonaws.com"
};

static const char *hostname_blacklist[] = {
    "adeventtracker.spotify.com",
    "audio-sp-ash.spotify.com",
    "spclient.wg.spotify.com"
};

#define array_length(array) (sizeof(array) / sizeof(array[0]))

#define WHITELIST_LENGTH (array_length(hostname_whitelist))
#define BLACKLIST_LENGTH (array_length(hostname_blacklist))

int getaddrinfo(const char *hostname,
                const char *service,
                const struct addrinfo *hints,
                struct addrinfo **res)
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
