
#include <errno.h>
#include <math.h>

#include "proj.h"
#include "proj_internal.h"
#include <iostream>
#include <math.h>

PROJ_HEAD(hourglass, "Extended Hourglass") "\n\tSph";

namespace { // anonymous namespace
struct pj_hourglass_data {
    int outinvalid;
    double n;
    double np1;
    double s;
    double sqrts;
    double L;
    double L_nm1_n;
    double L_1mn;
};
} // anonymous namespace

static PJ_XY hourglass_s_forward(PJ_LP lp, PJ *P) { /* Spheroidal, forward */
    PJ_XY xy = {0.0, 0.0};
    struct pj_hourglass_data *Q =
        static_cast<struct pj_hourglass_data *>(P->opaque);

    const double sign = lp.phi >= 0 ? 1.0 : -1.0;
    const double n = Q->n;
    const double np1 = Q->np1;
    const double sinphi = fabs(sin(lp.phi));
    xy.x = lp.lam / std::sqrt(Q->s) / M_PI *
           std::pow(M_PI * np1 / n * std::pow(Q->L, n - 1) * sinphi, 1 / np1);
    xy.y = sign * std::sqrt(Q->s) *
           std::pow(M_PI * np1 / n * std::pow(Q->L, (1 - n) / n) * sinphi,
                    n / np1);
    // std::cout << "lf " << lp.lam * 180 / M_PI << " " << lp.phi * 180 / M_PI
    //           << "  xy " << xy.x * P->a << " " << xy.y * P->a << std::endl;
    return xy;
}

static PJ_LP hourglass_s_inverse(PJ_XY xy, PJ *P) { /* Spheroidal, inverse */
    PJ_LP lp = {0.0, 0.0};

    if (std::fabs(xy.y) <= 1e-8){
        // singularity at 0
        return lp;
    }

    struct pj_hourglass_data *Q =
        static_cast<struct pj_hourglass_data *>(P->opaque);

    const double sign = xy.y >= 0 ? 1.0 : -1.0;
    double t = std::pow(std::fabs(xy.y) / Q->sqrts, Q->np1 / Q->n);
    t *= Q->n / Q->np1 / M_PI * Q->L_nm1_n;
    if (t > 1) {
        proj_errno_set(P, PROJ_ERR_COORD_TRANSFM_OUTSIDE_PROJECTION_DOMAIN);
        return lp;
    }

    double u = Q->n / Q->np1 / M_PI * Q->L_1mn / t;
    lp.lam = xy.x * M_PI * Q->sqrts * std::pow(u, 1 / Q->np1);
    lp.phi = asin(t) * sign;

    if (Q->outinvalid &&
        (fabs(lp.lam) > (Q->outinvalid * 2 - 1) * M_PI + 1.e-7)) {
        proj_errno_set(P, PROJ_ERR_COORD_TRANSFM_OUTSIDE_PROJECTION_DOMAIN);
        return lp;
    }

    return lp;
}

PJ *PJ_PROJECTION(hourglass) {
    struct pj_hourglass_data *Q = static_cast<struct pj_hourglass_data *>(
        calloc(1, sizeof(struct pj_hourglass_data)));
    if (nullptr == Q)
        return pj_default_destructor(P, PROJ_ERR_OTHER /*ENOMEM*/);
    P->opaque = Q;
    Q->outinvalid = 1;
    if (pj_param(P->ctx, P->params, "toutinvalid").i) {
        Q->outinvalid = pj_param(P->ctx, P->params, "ioutinvalid").i;
    }
    double s = 1;
    if (pj_param(P->ctx, P->params, "ts").i) {
        s = pj_param(P->ctx, P->params, "ds").f;
        if (s <= 0) {
            proj_log_error(P, _("Invalid value for ratio s should be > 0"));
            return pj_default_destructor(P,
                                         PROJ_ERR_INVALID_OP_ILLEGAL_ARG_VALUE);
        }
    }
    double n = 1;
    if (pj_param(P->ctx, P->params, "tn").i) {
        n = pj_param(P->ctx, P->params, "dn").f;
        if (n <= 0) {
            proj_log_error(P, _("Invalid value for n: it should be > 0"));
            return pj_default_destructor(P,
                                         PROJ_ERR_INVALID_OP_ILLEGAL_ARG_VALUE);
        }
    }
    P->es = 0;
    P->e = 0;
    Q->n = n;
    Q->np1 = n + 1;
    Q->L = std::sqrt(M_PI * Q->np1 / Q->n);
    Q->L_nm1_n = std::pow(Q->L, (n - 1) / n);
    Q->L_1mn = std::pow(Q->L, 1 - n);
    Q->s = s;
    Q->sqrts = std::sqrt(s);
    P->inv = hourglass_s_inverse;
    P->fwd = hourglass_s_forward;
    return P;
}
