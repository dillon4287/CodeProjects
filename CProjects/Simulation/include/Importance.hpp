#ifndef IMP_H
#define IMP_H

#include "Dist.hpp"
#include <Eigen/Dense>
#include <string.h>

using namespace Eigen;

class Importance : public Dist {
private:
  string beginString = "\n\n\tBegin Importance\n";
  string mlEst = "Marginal Likelihood Estimate:    ";
  string newLines = "\n\n";
  VectorXd lowerLim;
  VectorXd upperLim;
  VectorXd y;
  MatrixXd X;
  int J;
  VectorXd diagInverseFish;
  MatrixXd lsEsts;
  VectorXd sigSqd;
  VectorXd betaInit;
  MatrixXd sigmaInit;
  int igamParamA, igamParamB, Jminus1;

public:
  Importance();

  double importanceSampling(VectorXd &, VectorXd &, VectorXd &, MatrixXd &,
                            VectorXd &, MatrixXd &, int, int, VectorXd &,
                            MatrixXd &, int, int);

  double ml(VectorXd &, MatrixXd &);

  double mlT(const VectorXd &a, const VectorXd &b,
             const MatrixXd &LinearConstraints, const VectorXd &mu,
             const MatrixXd &Sigma, const MatrixXd &y, const MatrixXd &X,
             double df, int sims, int burnin, const VectorXd &b0,
             const MatrixXd &B0, double a0, double d0);

  double mlGeweke91(const VectorXd &a, const VectorXd &b,
                    const MatrixXd &LinearConstraints, const VectorXd &mu,
                    const MatrixXd &Sigma, const MatrixXd &y, const MatrixXd &X,
                    int sims, int burnin, const VectorXd &b0,
                    const MatrixXd &B0, double a0, double d0);

  double mlGeweke91T(const VectorXd &a, const VectorXd &b,
                     const MatrixXd &LinearConstraints, const VectorXd &mu,
                     const MatrixXd &Sigma, double df, const MatrixXd &y,
                     const MatrixXd &X, double df, int sims, int burnin,
                     const VectorXd &b0, const MatrixXd &B0, double a0,
                     double d0);

  MatrixXd sample;

  VectorXd tnormpdf(double, double, double, double, VectorXd &);

  MatrixXd tnormpdf(VectorXd &, VectorXd &, VectorXd &, VectorXd &, MatrixXd &);

  MatrixXd importanceDensity;

  VectorXd logtLike(double df, const Ref<const VectorXd> &mu,
                    const VectorXd &sigmaSqd, MatrixXd X);

  VectorXd logmvtpdf(double df, const Ref<const VectorXd> &mu,
                     const MatrixXd &Sigma, MatrixXd X);

  void runSim(int, int, VectorXd &, MatrixXd &, VectorXd &, MatrixXd &,
              VectorXd &, VectorXd &, int, int, VectorXd &, MatrixXd &, double,
              double);

  void runTsim(int nSims, int batches, const VectorXd &theta,
               const MatrixXd &sigma, const VectorXd &y, const MatrixXd &X,
               const VectorXd &a, const VectorXd &b,
               const MatrixXd &LinearConstraints, double df, int sampleSize,
               int burnin, const VectorXd &b0, const MatrixXd &B0, double a0, double d0);

  void runSimNew(int nSims, int batches, const VectorXd &theta,
                 const MatrixXd &sigma, const VectorXd &y, const MatrixXd &X,
                 const VectorXd &ll, const VectorXd &ul,
                 const MatrixXd &LinearConstraints, double df, int sampleSize,
                 int burnin, const VectorXd &b0, const MatrixXd &S0, double a0,
                 double d0)
};
#endif

