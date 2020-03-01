#include <iostream>
#include <fstream>
#include <list>


using namespace std;

struct term {
	long coef;
	long exp;
	term set(long c, long e){coef = c; exp = e; return *this;}
};

class polynomial{
	friend polynomial operator+(const polynomial&, const polynomial&);
	friend polynomial operator-(const polynomial&, const polynomial&);
	friend polynomial operator*(const polynomial&, const polynomial&);
	public: list<term> poly;
};

polynomial operator+(const polynomial& a, const polynomial& b){	//adding two polynomials
	list<term>::const_iterator ai = a.poly.begin();
	list<term>::const_iterator bi = b.poly.begin();
	polynomial ans;
	term temp_term;
	
	while((ai!=a.poly.end()) && (bi!=b.poly.end())){	//neither polynomial has reached its end
		if(ai->exp == bi->exp){
			long coef_sum = ai->coef + bi->coef;
			if(coef_sum){				//coef_sum is not zero
			ans.poly.push_back(temp_term.set(coef_sum, ai->exp));	
			}
			ai++;
			bi++;
		}
		else if(ai->exp > bi->exp){
			ans.poly.push_back(temp_term.set(ai->coef, ai->exp));
			ai++;
		}
		else{
			ans.poly.push_back(temp_term.set(bi->coef, bi->exp));
			bi++;
		}
	}
	while(ai!=a.poly.end()){		//finish reading a if its not finished when b is
		if(!(ai->coef == 0))	// the term has a zero coefficient
			ans.poly.push_back(temp_term.set(ai->coef, ai->exp));
		ai++;
	}
	while(bi!=b.poly.end()){		//finish reading b if its not finished when a is
		if(!(bi->coef == 0))	// the term has a zero coefficient
			ans.poly.push_back(temp_term.set(bi->coef, bi->exp));
		bi++;
	}
	if(ans.poly.size()==0) ans.poly.push_back(temp_term.set(0, 0));	//if the answer is a zero exponential
	
	return ans;
}

polynomial operator-(const polynomial& a, const polynomial& b){	//adding two polynomials
	list<term>::const_iterator ai = a.poly.begin();
	list<term>::const_iterator bi = b.poly.begin();
	polynomial ans;
	term temp_term;
	
	while((ai!=a.poly.end()) && (bi!=b.poly.end())){	//neither polynomial has reached its end
		if(ai->exp == bi->exp){
			long coef_sum = ai->coef - bi->coef;
			if(coef_sum){				//coef_sum is not zero
			ans.poly.push_back(temp_term.set(coef_sum, ai->exp));
			}
			ai++;
			bi++;
		}
		else if(ai->exp > bi->exp){
			ans.poly.push_back(temp_term.set(ai->coef, ai->exp));
			ai++;
		}
		else{
			ans.poly.push_back(temp_term.set(-(bi->coef), bi->exp));
			bi++;
		}
	}
	while(ai!=a.poly.end()){		//finish reading a if its not finished when b is
		if(!(ai->coef == 0))	// the term has a zero coefficient
			ans.poly.push_back(temp_term.set(ai->coef, ai->exp));
		ai++;
	}
	while(bi!=b.poly.end()){		//finish reading b if its not finished when a is
		if(!(bi->coef == 0))	// the term has a zero coefficient
			ans.poly.push_back(temp_term.set(-(bi->coef), -(bi->exp)));
		bi++;
	}
	if(ans.poly.size()==0) ans.poly.push_back(temp_term.set(0, 0));	//if the answer is a zero exponential
	
	return ans;
}

polynomial operator*(const polynomial& a, const polynomial& b){ //multiplying two polynomials
	polynomial ans;
	term temp_term;

	for(list<term>::const_iterator ai = a.poly.begin(); ai!=a.poly.end(); ai++){
		polynomial temp_ans;
		
		for(list<term>::const_iterator bi = b.poly.begin(); bi!=b.poly.end(); bi++){
			long coef_mul = ai->coef * bi->coef;
			long temp_exp = ai->exp + bi->exp;
			temp_ans.poly.push_back(temp_term.set(coef_mul, temp_exp));
		}
		ans = ans + temp_ans;
	}
	return ans;
}

int main(int argc, char** argv){
	ifstream in_file;
	ofstream out_file;
	in_file.open(argv[1]);
	out_file.open(argv[2]);
	
	polynomial left;
	term temp_term;
	int num_terms = 0;
	long temp_coef = 0, temp_exp = 0;
//scan the first polynomial, initialise left
	in_file >> num_terms;
	for(int q =0; q<num_terms; q++){
		in_file >> temp_coef >> temp_exp;
		left.poly.push_back(temp_term.set(temp_coef, temp_exp));
	}
	
	while(!in_file.eof()){		
		polynomial right;	//declare right here so it will clear everytime
		char temp_operator = '0';
		in_file >> temp_operator;

		num_terms = 0;
		temp_coef = 0;
		temp_exp = 0;

		in_file >> num_terms;
		
		for(int q=0; q<num_terms; q++){	//read next polynomial
			in_file >> temp_coef >> temp_exp;
			right.poly.push_back(temp_term.set(temp_coef, temp_exp));
		}

		switch(temp_operator){
			case '+':
				left = left + right;
				break;
			case '-':
				left = left - right;
				break;
			case '*':
				left = left * right;
				break;
		}
	}
	
	out_file << left.poly.size() << endl;		//working on output file
	for(list<term>::const_iterator i=left.poly.begin(); i!=left.poly.end(); i++){
		out_file << i->coef << " " << i->exp << endl;
	}
	
	in_file.close();
	out_file.close();
	
	return 0;
}
