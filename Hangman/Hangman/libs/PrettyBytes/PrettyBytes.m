//
// From Jody Hagins
// http://stackoverflow.com/questions/10091816/nsfilesystemfreesize-translating-result-into-user-friendly-display-of-mb-gb
//

#import "PrettyBytes.h"

NSString* prettyBytes(uint64_t numBytes)
{
    uint64_t const scale = 1024;
    char const * abbrevs[] = { "EB", "PB", "TB", "GB", "MB", "KB", "Bytes" };
    size_t numAbbrevs = sizeof(abbrevs) / sizeof(abbrevs[0]);
    uint64_t maximum = powl(scale, numAbbrevs-1);
    for (size_t i = 0; i < numAbbrevs-1; ++i) {
        if (numBytes > maximum) {
            return [NSString stringWithFormat:@"%.2f %s", numBytes / (double)maximum, abbrevs[i]];
        }
        maximum /= scale;
    }
    return [NSString stringWithFormat:@"%u Bytes", (unsigned)numBytes];
}
