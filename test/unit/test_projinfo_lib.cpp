/******************************************************************************
 *
 * Project:  PROJ
 * Purpose:  Test projinfo_lib API
 * Author:   Javier Jimenez Shaw
 *
 ******************************************************************************
 * Copyright (c) 2025, Javier Jimenez Shaw
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ****************************************************************************/

#include "gtest_include.h"

#include "apps/projapps_lib.h"

#include <iostream>

// ---------------------------------------------------------------------------

TEST(projinfo_lib, simple) {
    auto dump = [](const char *s) {
        std::cout << s;
        std::string str(s);
        if (str.find("PROJCS[\"ETRS89 / UTM zone 32N\"") != std::string::npos) {
            //found = true;
        }
    };
    auto dump_err = [](const char *s) {
        std::cerr << s;
        //some_err = true;
    };

    const char *argv[] = {"testing", "EPSG:25832", "-o", "WKT1_GDAL", nullptr};
    int argc = 4;

    std::unique_ptr<PROJInfoOptions, decltype(&PROJInfoOptionsFree)> options(
        PROJInfoOptionsNew(argc, (char **)argv), PROJInfoOptionsFree);

    int res = PROJInfo(options.get(), dump, dump_err, dump_err);
    EXPECT_EQ(res, 0);
}
