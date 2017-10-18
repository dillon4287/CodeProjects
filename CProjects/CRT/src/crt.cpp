#include <Eigen/Dense>
#include <iostream>
#include <math.h>
#include "CRT.hpp"
#include "Dist.hpp"
#include "ProbabilitySimulator.hpp"

using namespace Eigen;
using namespace std;

CRT::CRT(VectorXd& lowerlim, VectorXd& upperlim, VectorXd& theta, MatrixXd& sigma, int sims,
		int burnin){
	cout << "\n\tCRT Begin\n" << endl;
	ll = lowerlim;
	ul = upperlim;
	mu = theta;
	Sigma = sigma;
	J = sigma.cols();
	Rows = sims-burnin;
	Jminus1 = J -1 ;
	MatrixXd tempsample(sims, 2*J);
	truncatedSample = MatrixXd::Zero(sims, 2*J);
	sigmaVector = MatrixXd::Zero(sigma.cols(), 1);
	tmvnrand(lowerlim, upperlim, mu, sigma, tempsample, sigmaVector);
	truncatedSample = tempsample.bottomRows(sims-burnin); 
	zStar = truncatedSample.leftCols(J).colwise().mean();
	Kernel = MatrixXd::Zero(Rows, J);
	xNotj = MatrixXd::Zero(Rows,Jminus1);
	xNotj.rightCols(Jminus1-1) = truncatedSample.middleCols(2, J-2);
	muNotj = MatrixXd::Zero(Jminus1, 1);
	Hxy = MatrixXd::Zero(Jminus1, 1);
	precision = sigma.inverse();
	Hxx = precision.diagonal();
	xnotJ = zStar.head(Jminus1);
}

void CRT::gibbsKernel(){
	
	VectorXd tempk(Rows);
	VectorXd cmeanVect(Rows);
	cmeanVect = truncatedSample.col(J);
	tnormpdf(ll(0),ul(0), cmeanVect, sigmaVector(0), zStar(0), tempk); 
	Kernel.col(0) = tempk;
	for(int j = 1; j < Jminus1; j++){
		muNotj << mu.head(j), mu.tail(Jminus1-j);
		Hxy << precision.row(j).head(j).transpose(), precision.row(j).tail(Jminus1-j).transpose(); 
		xNotj.col(j-1).fill(zStar(j-1));
		conditionalMean(Hxx(j), Hxy, muNotj, xNotj, mu(j), cmeanVect);
		tnormpdf(ll(j), ul(j), cmeanVect, sigmaVector(j), zStar(j), tempk);
		Kernel.col(j) = tempk;
	}
	Hxy << precision.row(Jminus1).head(Jminus1).transpose(); 
	muNotj = mu.head(Jminus1);
	double y = Dist::tnormpdf(ll(Jminus1), ul(Jminus1), Dist::conditionalMean(Hxx(Jminus1), Hxy, muNotj, 
			xnotJ, mu(Jminus1)), sigmaVector(Jminus1), zStar(Jminus1));
	Kernel.col(Jminus1).fill(y);
}


void CRT::conditionalMean(double Hxx, VectorXd& Hxy, VectorXd& muNotj, MatrixXd& xNotj, 
        double muxx, VectorXd& conditionalMeanVector){
	xNotj.rowwise() -= muNotj.transpose(); 
	conditionalMeanVector = muxx - ((1/Hxx)*xNotj*Hxy).array(); 
} 

void CRT::tnormpdf(double a, double b, VectorXd& mu, double sigma, double x, 
		VectorXd& k){
	boost::math::normal normalDist;
	double Fa, Fb;
	for(int i = 0;i < mu.size(); i++){
		Fa = cdf(normalDist, (a-mu(i))/sigma);
		Fb = cdf(normalDist, (b-mu(i))/sigma);
		double sigmaZ = sigma * (Fb - Fa);
		k(i) = pdf(normalDist, (x - mu(i))/sigma)/sigmaZ;
	}
} 