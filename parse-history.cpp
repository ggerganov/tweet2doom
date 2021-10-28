#include <cstdio>
#include <string>
#include <fstream>
#include <vector>
#include <sstream>

std::string readFile(const char * fname) {
    std::ifstream t(fname);
    t.seekg(0, std::ios::end);
    size_t size = t.tellg();
    std::string buffer(size, ' ');
    t.seekg(0);
    t.read(&buffer[0], size);

    return buffer;
}

// ref : https://stackoverflow.com/a/3418285/4039976
void replaceAll(std::string& str, const std::string& from, const std::string& to) {
    if (from.empty()) return;
    size_t start_pos = 0;
    while ((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // In case 'to' contains 'from', like replacing 'x' with 'yx'
    }
}

std::vector<std::string> tokenize(const std::string & text, char sep) {
    std::vector<std::string> tokens;

    std::stringstream ss(text);
    std::string s;

    while (getline(ss, s, sep)) {
        tokens.push_back(s);
    }

    return tokens;
}

std::string removeUsernames(const std::string & text) {
    std::string result;
    bool isUsername = false;
    for (const auto & c : text) {
        if (c == '#') {
            isUsername = !isUsername;
            continue;
        }
        if (!isUsername) result.push_back(c);
    }
    return result;
}

std::string compress(const std::string & token) {
    bool hasShift = false;
    bool hasArrow = false;
    for (const auto & c : token) {
        if (c == 's') {
            hasShift = true;
        }
        if (c == 'l' || c == 'r' || c == 'u' || c == 'd' ||
            c == 'L' || c == 'R' || c == 'U' || c == 'D') {
            hasArrow = true;
        }
    }

    if (hasShift == false || hasArrow == false) return token;

    std::string result;
    for (const auto & c : token) {
        if (c == 's') continue;
        if (c == 'l' || c == 'L') { result += "L"; continue; }
        if (c == 'r' || c == 'R') { result += "R"; continue; }
        if (c == 'u' || c == 'U') { result += "U"; continue; }
        if (c == 'd' || c == 'D') { result += "D"; continue; }
        result += c;
    }
    return result;
}

int main(int argc, char ** argv) {
    if (argc < 6) {
        printf("Usage: %s history.txt nframes nperseg output.txt maxlen\n", argv[0]);
        return 1;
    }

    int nFrames = atoi(argv[2]);
    int nPerSeg = atoi(argv[3]);
    int maxlen = atoi(argv[5]);
    if (maxlen <= 0) maxlen = 100000;

    printf("Parsing last %d frames using %d frames per segment. maxlen = %d\n", nFrames, nPerSeg, maxlen);

    auto history = readFile(argv[1]);
    history = removeUsernames(history);
    replaceAll(history, "\n", "");
    auto tokens = tokenize(history, ',');

    //for (const auto & t : tokens) {
    //    printf(" - token: '%s'\n", t.c_str());
    //}
    //printf("\n----------------\n\n");

    int nTokens = tokens.size();
    int nStart = std::max(0, nTokens - nFrames);

    std::string result;

    int nSeg = 0;
    for (int i = nStart; i < nTokens; ++i) {
        auto curToken = tokens[i];
        int nr = 1;
        ++nSeg;
        for (int j = 1; (i + j < nTokens) && (tokens[i + j] == curToken) && (nSeg < nPerSeg); ) {
            ++j;
            ++nr;
            ++nSeg;
        }
        i += nr - 1;

        curToken = compress(curToken);
        if (nr > 1) {
            result += std::to_string(nr) + "-" + curToken + ",";
        } else {
            result += curToken + ",";
        }
        if (nSeg == nPerSeg) {
            result.pop_back();
            result += "\n";
            nSeg = 0;
        }

        if (result.size() >= maxlen) break;
    }

    replaceAll(result, "<", "&lt;");
    replaceAll(result, ">", "&gt;");

    auto fout = std::ofstream(argv[4]);
    fout << result;
    fout.close();

    return 0;
}
