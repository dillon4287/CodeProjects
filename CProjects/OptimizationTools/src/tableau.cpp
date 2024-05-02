#include <Eigen/Dense>
#include <iostream>
#include <map>
#include "Simplex.hpp"
#include "SimplexCore.hpp"

using namespace std;
using namespace Eigen;

void swap_col(MatrixXd &A, MatrixXd &B, int a, int b)
{
    VectorXd t = A.col(a);
    A.col(a) = B.col(b);
    B.col(b) = t;
}

void swap_col(VectorXd &A, VectorXd &B, int a, int b)
{
    double t = A(a);
    A(a) = B(b);
    B(b) = t;
}

int main()
{
    Simplex S;
    // cout << "Problem" << endl;
    // cout << "min -x0 + x1" << endl;
    // cout << "s.t. x0 -x1 <= 2" << endl;
    // cout << "     x0 + x1 <= 6" << endl;
    // VectorXd c1(2);
    // c1 << -1, 1;
    // MatrixXd A1(2, 2);
    // A1 << 1, -1, 1, 1;
    // VectorXd b1(2);
    // b1 << 2, 6;
    // vector<string> constraint_type1 = { "leq", "leq"};

    // S.Simplex2(c1, A1, b1, constraint_type1);
    // cout << "Correct solution F-Val " << -2 << endl; 
    // MatrixXd T(5, 5);
    // T << 1, 0, 0, 4, 0,
    //     6, 7, 0, 9, 0,
    //     11, 0, 0, 14, 0,
    //     16, 0, 18, 19, 0,
    //     21, 0, 0, 24, 25;
    // VectorXd cs = VectorXd::Ones(T.rows());
    // S.current_solution = cs;

    // S.presolve_1pos_incol(T, 0, T.cols());

    // cout << T << endl;
    // cout << "Correct answer " << endl;
    // MatrixXd C(2, 2);
    // C << 1, 4, 11, 14;
    // cout << C << endl;

    // S.optimize(c, A, b);
    // for (auto it = S.Solution.begin(); it != S.Solution.end(); ++it)
    // {
    //     cout << it->first << " " << it->second << endl;
    // }

    // cout << "Problem 2" << endl;
    // cout << "min -10x1 - 12x2 -12x3" << endl;
    // cout << "s.t. x1 + 2x2 + 2x3 <= 20" << endl;
    // cout << "s.t. 2x1 + 1x2 + 2x3 <= 20" << endl;
    // cout << "s.t. 2x1 + 2x2 + 1x3 <= 20" << endl;

    // VectorXd c2(3);
    // c2 << -10, -12, -12;
    // MatrixXd A2(3, 3);
    // A2 << 1, 2, 2, 2, 1, 2, 2, 2, 1;
    // VectorXd b2(3);
    // b2 << 20, 20, 20;
    // vector<string> constraint_type = { "leq", "leq", "leq"};

    // S.Simplex2(c2, A2, b2, constraint_type);
    // cout << "Correct solution F-Val -136, x1,x2,x3 = (4,4,4)" << endl; 
    
    // cout << "Problem 3 Luenberger & Ye" << endl;
    // cout << "min 4x1 + x2 + x3" << endl;
    // cout << "s.t. 2x1 + 1x2 + 2x3 = 4" << endl;
    // cout << "s.t. 3x1 + 3x2 + 1x3 = 3" << endl;
    // VectorXd c3(3);
    // c3 << 4, 1, 1;
    // MatrixXd A3(2, 3);
    // A3 << 2, 1, 2,
    //       3, 3, 1;
    // VectorXd b3(2);
    // b3 << 4, 3;
    // vector<string> constraint_type3 = {"eq", "eq"};
    // S.Simplex2(c3, A3, b3, constraint_type3);
    
    

    // cout << "Problem 4 Chen Baston & Dang" << endl;
    // cout << "max 5x1 - 2x2" << endl;
    // cout << "-x1 + 2x2 <= 5" << endl;
    // cout << "3x1 + 2x2 <= 19" << endl;
    // cout << "x1 + 3x2 >= 9" << endl;

    // VectorXd c4(2);
    // c4 << -5, 2;
    // MatrixXd A4(3, 2);
    // A4 << -1,2,
    //     3, 2,
    //     1, 3;
    // VectorXd b4(3);
    // b4 <<  5, 19, 9;

    // vector<string> constraint_type4 = { "leq", "leq", "geq"};

    // S.Simplex2(c4, A4, b4, constraint_type4);

    // cout << "True solution to phase-I x0=5.571, x1=1.143" << endl;


    cout << "max x2" << endl;
    cout << "-x1 + x2 <= 0" << endl;
    cout << "x1 <= 2" << endl; 



    VectorXd c5(2);
    c5 << 0,-1;
    MatrixXd A5(2, 2);
    A5 << -1,1,
        1, 0;
    VectorXd b5(2);
    b5 <<  0, 2;

    

    vector<string> constraint_type5 = { "leq", "leq"};

    S.Simplex2(c5, A5, b5, constraint_type5);

    return 0;
}