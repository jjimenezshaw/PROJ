
#include <errno.h>
#include <math.h>

#include "proj.h"
#include "proj_internal.h"
#include <math.h>

PROJ_HEAD(hg, "Snyder Hourglass") "\n\tSph";

namespace { // anonymous namespace
struct pj_hg_data {
    double m0;
    double invm0;
    double sqrtm0;
    double invsqrtm0;
    int outinvalid;
};
} // anonymous namespace

static PJ_XY hg_s_forward(PJ_LP lp, PJ *P) { /* Spheroidal, forward */
    PJ_XY xy = {0.0, 0.0};
    struct pj_hg_data *Q = static_cast<struct pj_hg_data *>(P->opaque);

    const double sqrtsinphi = sqrt(fabs(sin(lp.phi)));
    const double sign = lp.phi >= 0 ? 1.0 : -1.0;
    xy.y = 2 * sqrtsinphi * sign * Q->invsqrtm0;
    xy.x = lp.lam * sqrtsinphi * Q->sqrtm0;
    return (xy);
}

static PJ_LP hg_s_inverse(PJ_XY xy, PJ *P) { /* Spheroidal, inverse */
    PJ_LP lp = {0.0, 0.0};
    struct pj_hg_data *Q = static_cast<struct pj_hg_data *>(P->opaque);

    if (Q->outinvalid &&
        (fabs(xy.x) > Q->outinvalid * M_HALFPI * fabs(xy.y) * Q->m0 + 1.e-7)) {
        proj_errno_set(P, PROJ_ERR_COORD_TRANSFM_OUTSIDE_PROJECTION_DOMAIN);
        return lp;
    }

    double s = xy.y * Q->sqrtm0 / 2;
    s *= s;
    if (s > 1) {
        proj_errno_set(P, PROJ_ERR_COORD_TRANSFM_OUTSIDE_PROJECTION_DOMAIN);
        return lp;
    }

    const double sign = xy.y >= 0 ? 1.0 : -1.0;
    lp.phi = asin(s) * sign;
    lp.lam = 2 * Q->invm0 * xy.x / fabs(xy.y);
    return (lp);
}

PJ *PJ_PROJECTION(hg) {
    struct pj_hg_data *Q =
        static_cast<struct pj_hg_data *>(calloc(1, sizeof(struct pj_hg_data)));
    if (nullptr == Q)
        return pj_default_destructor(P, PROJ_ERR_OTHER /*ENOMEM*/);
    P->opaque = Q;
    Q->outinvalid = 1;
    if (pj_param(P->ctx, P->params, "toutinvalid").i) {
        Q->outinvalid = pj_param(P->ctx, P->params, "ioutinvalid").i;
    }
    double lat1 = M_FORTPI;
    if (pj_param(P->ctx, P->params, "tlat_1").i) {
        lat1 = pj_param(P->ctx, P->params, "rlat_1").f;
        if (lat1 <= 0 || lat1 >= M_HALFPI) {
            proj_log_error(
                P,
                _("Invalid value for lat_1: |lat_1| should be < 90° and > 0°"));
            return pj_default_destructor(P,
                                         PROJ_ERR_INVALID_OP_ILLEGAL_ARG_VALUE);
        }
    }
    const double cl1 = cos(lat1);
    Q->m0 = cl1 * cl1 / sin(lat1);
    Q->sqrtm0 = sqrt(Q->m0);
    Q->invm0 = 1 / Q->m0;
    Q->invsqrtm0 = 1 / Q->sqrtm0;
    P->inv = hg_s_inverse;
    P->fwd = hg_s_forward;
    P->es = 0.;
    return P;
}
