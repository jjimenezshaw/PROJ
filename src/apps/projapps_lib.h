/******************************************************************************
 *
 * Project:  PROJ
 * Purpose:  projinfo C API
 * Author:   Javier Jimenez Shaw
 *
 ******************************************************************************
 * Copyright (c) 2025  Javier Jimenez Shaw
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

#if !defined(PROJAPPS_LIB_H)
#define PROJAPPS_LIB_H

#include "proj.h"

#ifdef __cplusplus
extern "C" {
#endif

struct PROJInfoOptions;

PROJInfoOptions PROJ_DLL *PROJInfoOptionsNew(int argc, char **argv);

void PROJ_DLL PROJInfoOptionsFree(PROJInfoOptions *psOptions);

/*
 * Internal C implementation of projinfo
 */
int PROJ_DLL PROJInfo(PROJInfoOptions *opts, void (*fout)(const char *),
                      void (*ferr)(const char *), void (*fwarn)(const char *));

#ifdef __cplusplus
}
#endif

#endif
