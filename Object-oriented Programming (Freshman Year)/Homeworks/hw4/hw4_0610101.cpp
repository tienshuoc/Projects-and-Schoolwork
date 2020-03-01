#include<iostream>
#include<cstdlib>
#include<algorithm>

using namespace std;

	int gcd(int a, int b){
	    int r;
	    if(a==0){
            return b;
	    }
        else{
        while(b!=0){
        r = (a % b);
        a = b;
        b = r;
            }
            return a;
        }

	}


class fraction_t{
private:
	int numerator;
	int denominator;
public:
	fraction_t()            { numerator=0; denominator=1;}
	fraction_t(int i)       { numerator=i; denominator=1;}
    fraction_t(int n, int d){
		numerator= n/(gcd(n,d));
		denominator = d/(gcd(n,d));
		//hint : gcd
	}

	friend const fraction_t operator+(const fraction_t& lhs, const fraction_t& rhs);
	friend const fraction_t operator-(const fraction_t& lhs, const fraction_t& rhs);
	friend const fraction_t operator*(const fraction_t& lhs, const fraction_t& rhs);
	friend const fraction_t operator/(fraction_t& lhs, fraction_t& rhs);

	friend ostream& operator<<(ostream& os, fraction_t& rhs);
	friend istream& operator>>(istream& os, fraction_t& rhs);
//finish your code

};

//finish your code
const fraction_t operator+(const fraction_t& lhs, const fraction_t& rhs){
    int numer, denom;
    numer = lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator;
    denom = lhs.denominator * rhs.denominator;
    return fraction_t(numer, denom);
    }
const fraction_t operator-(const fraction_t& lhs, const fraction_t& rhs){
    int numer, denom;
    numer = lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator;
    denom = lhs.denominator * rhs.denominator;
    return fraction_t(numer, denom);
    }
const fraction_t operator*(const fraction_t& lhs, const fraction_t& rhs){
    int numer, denom;
	numer = lhs.numerator * rhs.numerator;
	denom = lhs.denominator * rhs.denominator;
	return fraction_t(numer, denom);
	}
const fraction_t operator/(fraction_t& lhs, fraction_t& rhs){
    int temp_number = rhs.numerator;
    rhs.numerator = rhs.denominator;
    rhs.denominator = temp_number;
    return lhs * rhs;
	}
ostream& operator<<(ostream& os, fraction_t& rhs){
    os << rhs.numerator << "/" << rhs.denominator;
    return os;
	}
istream& operator>>(istream& is, fraction_t& rhs){
    is >> rhs.numerator;
    is >> rhs.denominator;
    return is;
	}


int main(){
	fraction_t v,t,w;
	char op;
	while(1){
        cout<<endl<<v<<' ';

		cin>>op;
		if( op!='+' && op!='-' && op!='*' && op!='/' ) break;

		cin>>t;
		if(cin.fail()) break;

		switch(op){
			case '+':  w = v+t; break;
			case '-':  w = v-t; break;
			case '*':  w = v*t; break;
			case '/':  w = v/t; break;
		}
		cout<<"Ans = "<<w<<endl;
		v = w;
	}
	return 0;
}
