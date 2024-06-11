#include "Distributions.hpp"
#include "EigenTools.hpp"
#include <Eigen/Dense>

using namespace Eigen;
using namespace std;

MatrixXd TriangularSolver(const MatrixXd &AAT, int cols) {
  MatrixXd B= MatrixXd::Zero(AAT.rows(), cols);
  for (int j = 0; j < cols; ++j) {
    RowVectorXd r1 = B.row(j).segment(0, j);
    for (int i = j; i < AAT.rows(); ++i) {
      RowVectorXd r2 = B.row(i).segment(0, j);
      double inner_prod = (r1.array() * r2.array()).sum();
      if (i == j) {
        B(i, j) = sqrt(AAT(i, j) - inner_prod);
      } else {
        B(i, j) = (AAT(i, j) - inner_prod)/B(j,j);
      }
    }
  }
  return B; 
}

int main() {
  cout << "scratch" << endl;


  MatrixXd Sigma = .5*MatrixXd::Identity(4,4);
  MatrixXd A = .25*MatrixXd::Ones(4, 2);
  A.col(1) = .5 * A.col(0);
  for (int i = 0; i < A.rows(); ++i) {
    for (int j = 0; j < A.cols(); ++j) {
      if(j==i){
        A(i,j) = sqrt(1./2.0); 
      }
      if (j > i) {
        A(i, j) = 0;
      }
    }
  }
  cout << A << endl; 
  MatrixXd C = A*A.transpose() + Sigma; 
  MatrixXd D = C.diagonal().array().pow(-.5);
  MatrixXd Z = D.asDiagonal(); 
  C = Z*C*Z; 
  C = C - Sigma; 
  MatrixXd AAT = A*A.transpose(); 
  MatrixXd Y = TriangularSolver(C, A.cols());
  MatrixXd U = Z*Y; 
  cout << U*U.transpose() + Sigma << endl; 

}