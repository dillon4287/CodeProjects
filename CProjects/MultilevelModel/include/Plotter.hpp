#ifndef PLOT_H
#define PLOT_H
#include <iostream>
#include <fstream>
#include <string> 
#include <boost/format.hpp>


#include <eigen-3.3.9/Eigen/Dense>

using namespace std; 
using namespace Eigen; 
using namespace boost;

void writeToCSVfile(string name, MatrixXd matrix);

int plotter(string filename, const VectorXd &A, const VectorXd &B);

int plotter(string filename, const VectorXd &A, const VectorXd &B, string labelA, string labelB);

#endif 