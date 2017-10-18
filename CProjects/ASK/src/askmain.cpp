#include <Eigen/Dense>
#include <iostream>
#include <fstream>
#include <math.h>
#include <limits> 
#include <ctime>
#include "Dist.hpp"
#include "CreateSampleData.hpp"
#include "ask.hpp"

using namespace std;
using namespace Eigen;

int main(){
	double a = 0.;
	double inf = numeric_limits<double>::max();
	VectorXd mu(3);
	MatrixXd sig(3,3);
   
   	mu << 0., .5, 1.;
    sig << 1, -.7, .49, 
	 		-.7, 1, -.7,
			 .49, -.7, 1;	

	VectorXd ll(3);
	VectorXd ul(3);
	ll.fill(a);	
	ul.fill(inf);

	Ask ask(ll, ul, mu, sig, 11, 1);
	/*
	double num = ask.mvnpdf( mu, sig, ask.zStar); 
	cout << num << endl;
    double den = ask.Kernel.rowwise().prod().mean(); 
	cout << num/den << endl;
	cout << den << endl;
	double ans = log(num/den); 
	double testval = abs(ans - (-1.55)) ;	
	if(testval < .01){
		cout << "ASK Test PASSED" << endl;
		cout << ans << " " << testval << " " << endl;
	}
	else{
		cout << "ASK Test FAILED" << endl;
		cout << ans << " " << testval << " " << endl;
	}
	*/

}