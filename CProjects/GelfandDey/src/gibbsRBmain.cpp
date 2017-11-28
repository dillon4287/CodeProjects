#include "CreateSampleData.hpp"
#include "Dist.hpp"
#include "GelfandDey.hpp"
#include "LinRegGibbs.hpp"
#include "Importance.hpp"
#include <Eigen/Dense>
#include <iostream>

using namespace std;
using namespace Eigen;
int main() {
  double inf = numeric_limits<double>::max();
  int dim = 4;
  int gs = 120;
  int sSize = 5000;
  int burnin = 20;
  VectorXd betas(dim);
  VectorXd rll(dim + 1);
  VectorXd rul(dim + 1);
  betas << .99, .99, 5.6, 3.2;
  rll << 0., 0., 0., -inf, -inf;
  rul << inf, 1, 1, inf, inf;
  CreateSampleData csd(sSize, betas, 100);
  LinRegGibbs lrg;
  cout << "MLE's" << endl;
  cout << csd.maxLikeEsts.transpose() << endl;

  MatrixXd b0 = MatrixXd::Zero(dim,1);
  MatrixXd B0 = MatrixXd::Identity(dim,dim);
  double a0 = 6;
  double d0 = 12;
  /*lrg.runSim(50, 5, rll, rul, csd.maxLikeEsts, csd.inverseFisher, csd.y, csd.X,
             b0, B0, a0, d0, gs, burnin);
  cout << endl;
  lrg.runSimModified(50, 5, rll, rul, csd.maxLikeEsts, csd.inverseFisher, csd.y, csd.X,
             b0, B0, a0, d0, gs, burnin);
*/

  MatrixXd I = MatrixXd::Identity(3, 3);
  MatrixXd i = MatrixXd::Identity(2, 2);

  MatrixXd K(3,3);
  MatrixXd G =  MatrixXd::Identity(3, 3);

  K << 1, -.7, .49, -.7, 1, -.7, .49, -.7, 1;
  G << 1, 2, 3, 4, 5, 6, 7, 8, 9;
  VectorXd a(3);
  VectorXd b(3);
  a << 0, 0, 0;
  b << 1, 1, 1;
  VectorXd mu(3);
  mu << 0, 0, 0;
  cout << endl;
  cout << lrg.tmultnorm(a, b, mu, K, 25) << endl;
  cout << endl;
  cout << "MV t" << endl;
  cout << lrg.mvttgeweke91(a, b, I, mu, K, 5.0, 100, 80) << endl;
  cout << "GHK t" << endl;
  cout << lrg.ghkT(a, b, I, mu, K, 5.0, 100, 80) << endl;
  MatrixXd X = lrg.ghkT(a, b, I, mu, K, 5.0, 100, 80);
  cout << X << endl;
  cout << endl;
  Importance imp;

  // cout << imp.logtLike(10, mu.tail(2), X.col(0), X.rightCols(2) ) << endl;
  cout << "log mvt pdf" << endl;
  cout << imp.logmvtpdf(1000, mu.tail(2), i, X.rightCols(2)) << endl;
  VectorXd m = mu.tail(2);
  MatrixXd x = X.rightCols(2);  
  cout << "test vals for t pdf" << endl;
  cout << x << endl;
  cout << endl;
  cout << lrg.logmvnpdf(m, i,x ) << endl;
  MatrixXd Y = MatrixXd::Identity(5,5);
  imp.mlT(rll, rul, Y, csd.maxLikeEsts, csd.inverseFisher, csd.y, csd.X, 5, 10, 1);

  return 0;
}
