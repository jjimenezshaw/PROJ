#define FROM_PROJ_CPP

#include <cmath>
#include <cstdlib>
#include <fstream> // std::ifstream
#include <iostream>
#include <set>
#include <sstream>
#include <tuple>
#include <utility>
#include <vector>

#include "proj_internal.h"

#include <proj/common.hpp>
#include <proj/coordinateoperation.hpp>
#include <proj/coordinates.hpp>
#include <proj/crs.hpp>
#include <proj/io.hpp>
#include <proj/metadata.hpp>
#include <proj/util.hpp>

#include "proj/internal/internal.hpp" // for split

#include "projapps_lib.h"

struct PROJInfoOptions {
    std::vector<std::string> argv{};
};

PROJInfoOptions *PROJInfoOptionsNew(int argc, char **argv) {

    auto psOptions = std::make_unique<PROJInfoOptions>();

    for (int i = 0; i < argc; i++) {
        psOptions->argv.push_back(argv[i]);
    }

    return psOptions.release();
}

void PROJInfoOptionsFree(PROJInfoOptions *psOptions) { delete psOptions; }

struct Streamer {
  public:
    class Stream {
      private:
        std::stringstream ss{};
        void (*f)(const char *);
        template <typename T> inline void doit(const T &t) {
            if (f) {
                ss.str("");
                ss.clear();
                ss << t;
                f(ss.str().c_str());
            }
        }

      public:
        Stream(void (*f_in)(const char *)) : f{f_in} {}

        /* for std::endl */
        inline Stream &operator<<(std::ostream &(*func)(std::ostream &)) {
            doit(func);
            return *this;
        }

        /* should handle everything else */
        template <typename T> inline Stream &operator<<(const T &t) {
            doit(t);
            return *this;
        }
    };

    Streamer(void (*fout)(const char *), void (*ferr)(const char *),
             void (*fwarn)(const char *))
        : cout(fout), cerr(ferr), cwarn(fwarn) {}

    Stream cout;
    Stream cerr;
    Stream cwarn;
};

int PROJInfo(PROJInfoOptions *opts, void (*fout)(const char *),
             void (*ferr)(const char *), void (*fwarn)(const char *)) {

    Streamer strm(fout, ferr, fwarn);
    if (opts) {
        for (const auto &arg : opts->argv)
            strm.cout << arg << std::endl;
    }
    strm.cout << "hola"
              << " caracola" << std::endl
              << " y algo más " << std::endl;
    strm.cout << "ahora "
              << "dos\n";
    strm.cerr << 6;
    strm.cout << std::endl;
    strm.cerr << std::endl;
    return 0;
}
