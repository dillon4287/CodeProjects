#include <Eigen/Dense>
#include <ctime>
#include <iostream>

#include "EigenTools.hpp"
#include "FullConditionals.hpp"
#include "GenerateFactorData.hpp"
#include "IntegratedLikelihood.hpp"
#include "MultilevelModelFunctions.hpp"
#include "Plotter.hpp"

using namespace std;
using namespace Eigen;

int main() { /* Run the standard otrok whiteman model, 1 factor*/
  int T = 100;
  int K = 20;
  int sims = 10;
  int burnin = 2;
  VectorXd betas = .5 * VectorXd::Ones(1, 1);
  int nXs = betas.size();
  Matrix<int, Dynamic, 2> InfoMat(7, 2);
  InfoMat << 0, K - 1, 0, 9, 10, K - 1, 0, 4, 5, 9, 10, 14, 15, 19;

  int nFactors = InfoMat.rows();
  VectorXd factorVariances = VectorXd::Ones(nFactors, 1);
  RowVectorXd phi(2);
  phi << .25, .05;
  RowVectorXd del(2);
  del << .25, .05;
  GenerateFactorData mldata;
  double betaVal = 1;
  mldata.genDataArErrors(T, K, nXs, betaVal, InfoMat, phi, del, 1);
  FullConditionals mlotrok;
  double r0 = 6;
  double R0 = 10;
  double d0 = 6;
  double D0 = d0;

  int id = 1;
  RowVectorXd g0;
  MatrixXd G0;
  g0.setZero(phi.cols());
  G0 = MatrixXd::Identity(phi.cols(), phi.cols());
  MatrixXd Xt = mldata.Xt;
  int levels = calcLevels(InfoMat, K);
  RowVectorXd otrokb0 = RowVectorXd::Zero(nXs + nFactors);
  MatrixXd otrokB0 = MatrixXd::Identity(nXs + nFactors, nXs + nFactors);
  RowVectorXd del0(del.size());
  del0.setZero();
  MatrixXd Del0 = MatrixXd::Identity(del.size(), del.size());

  mlotrok.easySetModel(mldata.yt, mldata.Xt, phi, del, InfoMat);

  mlotrok.runModel(sims, burnin);

  MatrixXd Factorbar = mean(mlotrok.FactorPosteriorDraws);
  plotter("plot.p", Factorbar.row(0).transpose(),
          mldata.Factors.row(0).transpose(), "fest", "ftrue");
  mlotrok.ml();
  mlotrok.summary();

}
