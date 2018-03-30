

#ifndef TIMESERIES_H
#define TIMESERIES_H
#include <Eigen/Dense>
using namespace std;
using namespace Eigen;

class TimeSeries: public Dist{
	public:
	MatrixXd VAR(const MatrixXd &Yt, int lag);	
};

#endif

