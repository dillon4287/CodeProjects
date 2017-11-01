#include "CreateSampleData.hpp"
#include "Dist.hpp"
#include "ark.hpp"
#include <Eigen/Dense>
#include <ctime>
#include <fstream>
#include <iostream>
#include <limits>
#include <math.h>

using namespace std;
using namespace Eigen;

int main() {

  VectorXd betas(3);
  betas << .98, 5.6, 3.2;

  CreateSampleData csd(1000, betas, 1);
  double a = 0.;
  double inf = numeric_limits<double>::max();

  VectorXd ll(4);
  VectorXd ul(4);
  ll << -inf, 0, -inf, -inf ;
  ul << inf, 1, inf, inf;

  Ark ark;
  cout << csd.maxLikeEsts << endl;
  ark.runSim(20, 3, csd.maxLikeEsts, csd.inverseFisher, csd.y, csd.X, ll, ul,
             1000, 5000);
}