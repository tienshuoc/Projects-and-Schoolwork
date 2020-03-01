#include <iostream>
#include<istream>
#include<fstream>
using namespace std;

int main(int argc, char *argv[]){
	ifstream input;
	ofstream output;
	
	input.open(argv[1]);
	output.open(argv[2]);
	
	while(!input.eof()){
		int number;
		input >> number;

		if(number==2 || number==3)
			output << "1" << endl;		
		else{
		for(int i=2; i<((number/2) + 1); i++){
	
		if(number%i == 0){
			output << "0" << endl;	
			break;
		}
		else if(i==(number/2))
			output << "1" << endl;
		}
		}
		number = 1;
	}

	input.close();
	output.close();
	return 0;
}
