#include <iostream>
#include <sstream>
#include <regex>
#include <algorithm>
#include <cctype>
#include <set>

#include "StringUtil.h"

namespace stark
{
    std::vector<std::string> split(const std::string &s, char delimiter)
    {
        std::vector<std::string> tokens;
        std::string token;
        std::istringstream tokenStream(s);
        while (std::getline(tokenStream, token, delimiter))
        {
            tokens.push_back(token);
        }
        return tokens;
    }

    bool endsWith(std::string const &value, std::string const &ending)
    {
        if (ending.size() > value.size())
            return false;
        return std::equal(ending.rbegin(), ending.rend(), value.rbegin());
    }

    std::string ltrim(std::string s)
    {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch)
                                        { return !std::isspace(ch); }));
        return s;
    }

    std::string rtrim(std::string s)
    {
        s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch)
                             { return !std::isspace(ch); })
                    .base(),
                s.end());
        return s;
    }

    std::string trim(std::string s)
    {
        return ltrim(rtrim(s));
    }

    std::string unescape(std::string s)
    {
        std::string result;

        result = std::regex_replace(s, std::regex("\\\\'"), "\'");
        result = std::regex_replace(result, std::regex("\\\\a"), "\a");
        result = std::regex_replace(result, std::regex("\\\\b"), "\b");
        result = std::regex_replace(result, std::regex("\\\\f"), "\f");
        result = std::regex_replace(result, std::regex("\\\\n"), "\n");
        result = std::regex_replace(result, std::regex("\\\\r"), "\r");
        result = std::regex_replace(result, std::regex("\\\\t"), "\t");
        result = std::regex_replace(result, std::regex("\\\\v"), "\v");
        result = std::regex_replace(result, std::regex("\\\\\\\\"), "\\");
        result = std::regex_replace(result, std::regex("\\\\\""), "\"");
        return result;
    }

    std::string removeDuplicatedLines(std::string s)
    {
        std::string result = "";
        std::vector<std::string> lines = split(s, '\n');
        std::vector<std::string> deduplicated;
        for (auto it = lines.begin(); it != lines.end(); it++)
        {
            // Add line only if not already present
            if (std::find(deduplicated.begin(), deduplicated.end(), *it) == deduplicated.end())
            {
                deduplicated.push_back(*it);
                result.append(*it);
                result.append("\n");
            }
        }

        return result;
    }

} // namespace stark