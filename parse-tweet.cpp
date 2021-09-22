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

int nDash(const std::string & token) {
    int result = 0;
    for (const auto & c : token) {
        if (c == '-') ++result;
    }

    return result;
}

bool isValidRepeat(const std::string & token) {
    auto ipos = token.find('-');
    if (ipos <= 0 || ipos > 2) {
        return false;
    }

    for (int i = 0; i < ipos; ++i) {
        if (std::isdigit(token[i]) == false) {
            return false;
        }
    }

    return true;
}

int getNRepeat(const std::string & token) {
    int result = 0;
    auto ipos = token.find('-');
    for (int i = 0; i < ipos; ++i) {
        result *= 10;
        result += token[i] - '0';
    }

    return result;
}

std::string removeRepeat(const std::string & token) {
    return token.substr(token.find('-') + 1);
}

std::string dedup(const std::string & token) {
    std::string result;

    for (const auto & c : token) {
        bool use = true;
        for (const auto & cc : result) {
            if (c == cc) {
                use = false;
                break;
            }
        }
        if (use) {
            result += c;
        }
    }

    return result;
}

std::string expand(const std::string & token) {
    std::string result;

    for (const auto & c : token) {
        if (c == 'L') result += "sl"; else
        if (c == 'R') result += "sr"; else
        if (c == 'U') result += "su"; else
        if (c == 'D') result += "sd"; else
        result += c;
    }

    return result;
}

int main(int argc, char ** argv) {
    if (argc < 5) {
        printf("Usage: %s input.txt prefix output.txt frames\n", argv[0]);
        return 1;
    }

    constexpr int kMinFrames = 18;
    constexpr int kMaxFrames = 350;

    auto text = readFile(argv[1]);
    const std::string prefix = argv[2];
    const std::string ofname = argv[3];
    const std::string ffname = argv[4];

    replaceAll(text, "&lt;", "<");
    replaceAll(text, "&gt;", ">");

    printf("text = '%s'\n", text.c_str());
    printf("prefix = '%s'\n", prefix.c_str());
    printf("prefix len = %d\n", (int) prefix.length());

    std::vector<char> allowed = {
        'x', 'e', 'l', 'r', 'u', 'd', 'f', 't', 'a', 's', 'p', ',', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-',
        'L', 'R', 'U', 'D', '<', '>', 'y', 'n',
    };

    auto ipos = text.find(prefix);
    if (ipos == std::string::npos) {
        return 2;
    }

    auto istart = ipos + prefix.length();
    while (istart < text.length() && text[istart] == ' ') ++istart;

    auto iend = istart;
    while (iend < text.length()) {
        bool isAllowed = false;
        for (const auto & c : allowed) {
            if (c == text[iend]) {
                isAllowed = true;
                break;
            }
        }

        if (isAllowed == false) {
            break;
        }

        ++iend;
    }

    if (iend == istart) {
        return 3;
    }

    printf("istart = %d\n", (int) istart);
    printf("iend   = %d\n", (int) iend);

    auto payload = text.substr(istart, iend - istart);

    printf("payload = '%s'\n", payload.c_str());

    auto tokens = tokenize(payload, ',');

    for (const auto & t : tokens) {
        printf(" - token: '%s'\n", t.c_str());
    }
    printf("\n----------------\n\n");

    int nFrames = 0;
    std::string result;

    for (const auto & t : tokens) {
        if (nDash(t) > 1) {
            printf("error : invalid token '%s'\n", t.c_str());
            return 4;
        }

        if (nDash(t) == 1) {
            if (isValidRepeat(t) == false) {
                printf("error : invalid token '%s'\n", t.c_str());
                return 5;
            }

            const auto nRepeat = getNRepeat(t);
            const auto tt = dedup(expand(removeRepeat(t)));
            for (int i = 0; i < nRepeat; ++i) {
                result += tt + ",";
                nFrames++;
                if (nFrames >= kMaxFrames) break;
            }
            if (nFrames >= kMaxFrames) break;

            continue;
        }

        result += dedup(expand(t)) + ",";
        nFrames++;
        if (nFrames >= kMaxFrames) break;
    }

    if (nFrames < kMinFrames) {
        return 6;
    }

    if (result.size() == 0) {
        return 7;
    }

    result.erase(result.size() - 1);

    printf("%s\n", result.c_str());

    printf("nFrames = %d\n", nFrames);

    {
        std::ofstream fout(ofname);
        fout << result << std::endl;
        fout.close();
    }

    {
        std::ofstream fout(ffname);
        fout << nFrames << std::endl;
        fout.close();
    }

    return 0;
}
