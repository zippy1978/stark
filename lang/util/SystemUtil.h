#ifndef UTIL_SYSTEMUTIL_H
#define UTIL_SYSTEMUTIL_H

#include <string>

namespace stark
{
    /**
     * Executes a system command.
     */
    class Command
    {
        int exitStatus = 0;
        std::string command;
        std::string stdIn;
        std::string stdOut;
        std::string stdErr;

    public:
        Command(std::string command) : command(command) {}
        void execute();
        void setStdIn(std::string in) { stdIn = in; }
        std::string getStdOut() { return stdOut; }
        std::string getStdErr() { return stdErr; }
        int getExitStatus() { return exitStatus; }
    };

    /**
     * Checks if the file pointed by the provided file name exists
     */
    bool fileExists(std::string filename);
}

#endif