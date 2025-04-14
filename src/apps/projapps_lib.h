#if !defined(PROJAPPS_LIB_H)
#define PROJAPPS_LIB_H

#include "proj.h"

#ifdef __cplusplus
extern "C" {
#endif

struct PROJInfoOptions;

PROJInfoOptions PROJ_DLL *PROJInfoOptionsNew(int argc, char **argv);

void PROJ_DLL PROJInfoOptionsFree(PROJInfoOptions *psOptions);

int PROJ_DLL PROJInfo(PROJInfoOptions *opts,
                                  void (*fout)(const char *),
                                  void (*ferr)(const char *),
                                  void (*fwarn)(const char *));

#ifdef __cplusplus
}
#endif

#endif
