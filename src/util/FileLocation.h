#ifndef UTIL_FILELOCATION_H
#define UTIL_FILELOCATION_H

#include <string>

namespace stark
{

   /** 
   * Represent a location in a file.
   */
    class FileLocation
    {
    public:
        int line = 0;
        int column = 0;
        FileLocation() {}
        FileLocation(int line, int column) : line(line), column(column) {}
    };

} // namespace stark

#endif