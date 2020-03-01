#include <iostream>
using namespace std;

class Complex {
private:
	double re;
	double im;

public:
	double Real() const { return re; }
	double Imag() const { return im; }

	Complex(double r=0, double i=0):re(r), im(i){}

    friend const Complex operator+(const Complex& lhs, const Complex& rhs);
    friend const Complex operator-(const Complex& lhs, const Complex& rhs);
    friend const Complex operator*(const Complex& lhs, const Complex& rhs);
    friend Complex& operator+=(Complex& lhs, const Complex& rhs);
    friend bool operator==(const Complex& lhs, const Complex& rhs);
    friend bool operator!=(const Complex& lhs, const Complex& rhs);
    friend const Complex operator-(const Complex& rhs);
    friend ostream& operator<<(ostream& os, const Complex& rhs);
    friend istream& operator>>(istream& is, Complex& rhs);

//finish your code
};

const Complex operator+(const Complex& lhs, const Complex& rhs){
    double real, image;
    real = lhs.re + rhs.re;
    image = lhs.im + rhs.im;
    return Complex(real, image);}

const Complex operator-(const Complex& lhs, const Complex& rhs){
    double real, image;
    real = lhs.re - rhs.re;
    image = lhs.im - rhs.im;
    return Complex(real, image);}

const Complex operator*(const Complex& lhs, const Complex& rhs){
    double real, image;
    real = lhs.re * rhs.re - lhs.im * rhs.im;
    image = lhs.re * rhs.im + lhs.im * rhs.re;
    return Complex(real, image);}

Complex& operator+=(Complex& lhs, const Complex& rhs){
    double real, image;
    lhs.re = lhs.re + rhs.re;
    lhs.im = lhs.im + rhs.im;
    return lhs;}

const Complex operator-(const Complex& rhs){
    double real, image;
    real = -(rhs.re);
    image = -(rhs.im);
    return Complex(real, image);}

bool operator==(const Complex& lhs, const Complex& rhs){
    if((lhs.re==rhs.re)&&(lhs.im==rhs.im))
       return true;
    else
        return false;
    }

bool operator!=(const Complex& lhs, const Complex& rhs){
    if((lhs.re!=rhs.re)&&(lhs.im!=rhs.im))
       return true;
    else
        return false;
    }

ostream& operator<<(ostream& os, const Complex& rhs){
    os << "(" << rhs.re << "," << " " << rhs.im << ")";
    return os;}

istream& operator>>(istream& is, Complex& rhs){
    is >> rhs.re;
    is >> rhs.im;
    return is;}





//finish your code

int main()
{
	double re, im;
	Complex a, b, c ,d ,e, f, g;
	cout << "input a (re/im): ";
	cin >> a;
	cout << "input b (re/im): ";
	cin >> b;
	c = a+b;
	d = a-b;
	e = a+3;
	f = a*b;
	g = -a;
	Complex h(a.Imag(), b.Real());

	cout << "a = " << a << endl;
	cout << "b = " << b << endl;
	cout << "c = a+b = " << c << endl;
	cout << "d = a-b = " << d << endl;
	cout << "e = a+3 = " << e << endl;
	cout << "f = a*b = " << f << endl;
	cout << "g = -a = " << g << endl;
	cout << "h(a.im, b.re) = " << h << endl;
	if(a==b)
		cout << "a==b" << endl;
	if(a!=b)
		cout << "a!=b" << endl;
	a += f;
	cout << "a+=f >> a = " << a << endl;

	return 0;
}
