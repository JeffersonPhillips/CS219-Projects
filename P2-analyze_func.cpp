// C++ Program

// A polynomial analyzer program ...
// Takes a quadratic polynomial ...
// For example:  f(x) = a*x^2 + b*x + c
// Data Entry:   a, b, c, and x
// Output:       f(x), the value of the polynomial at x
// Output:       f'(x), the value of the derivative at x

#include <iostream>

using namespace std;

void get_input(int[], int &);
void display_f_of_x(const int[]);
void display_fp_of_x(int [], int []);
void eval_f_of_x(const int[], const int);
void eval_fp_of_x(const int fp_coef[], const int x);

int main()
{
    int x,y;
    int f_coef[3], fp_coef[2];              // f(x) and f'(x) coefficients

    cout << endl << "f(x) = a*x^2 + b*x + c" << endl << endl;

    get_input(f_coef, x);
    cout << endl;
    display_f_of_x(f_coef);           	    // Display f(x)
    display_fp_of_x(f_coef, fp_coef);       // Display f'(x)
    cout << endl;
    eval_f_of_x(f_coef, x);                 // Calculate f(x)
    eval_fp_of_x(fp_coef, x);               // Calculate f'(x)

    cout << endl;

    return 0;
}

void display_f_of_x(const int f_coef[])
{
    cout << "f(x)  = "
         << f_coef[0] << "*x^2 + "
         << f_coef[1] << "*x + "
         << f_coef[2] << endl;
}

void display_fp_of_x(int f_coef[], int fp_coef[])
{
    fp_coef[0] = f_coef[0]*2;			// Calculate the derivative
    fp_coef[1] = f_coef[1];			// f'(x) = 2a*x + b

    cout << "f'(x) = "
         << fp_coef[0] << "*x + "
         << fp_coef[1] << endl;
}

void get_input(int f_coef[], int & x)
{
    char a;
    for (int i = 0; i < 3; ++i)
    {
        a = 'a'+i;
        cout << "Enter coefficient ["<< a <<"]: ";
        cin >> f_coef[i];
    }
    cout << "Enter input value [x]: ";
    cin >> x;
}

void eval_f_of_x(const int f_coef[], const int x)
{
    int y;

    y = f_coef[0]*x*x + f_coef[1]*x + f_coef[2];    // Calculate f(x)

    cout << "f(" << x << ")  = "
         << f_coef[0] << "*(" << x << ")^2 + "
         << f_coef[1] << "*(" << x << ") + "
         << f_coef[2] << " = " << y << endl;
}

void eval_fp_of_x(const int fp_coef[], const int x)
{
    int y;

    y = fp_coef[0]*x + fp_coef[1];		   // Calculate f'(x)

    cout << "f'(" << x << ") = "
         << fp_coef[0] << "*(" << x << ") + "
         << fp_coef[1] << " = " << y << endl;
}
