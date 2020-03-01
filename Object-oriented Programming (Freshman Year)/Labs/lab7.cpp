#include<iostream>
#include<string>
#include<cstddef>
#include<iosfwd>
#include <fstream>
#include<stdlib.h>
using namespace std;

class Vector
{
        string *begin;	//begin of array
        int capacity;	//length of array
        int size;	//length of current element
        
 public:
        Vector();
		~Vector();
		void push_back(string);
        int get_size(){	return size;};
        int get_capacity(){	return capacity;};
        void show(ofstream& ofs);
};

//compelete constructor and destructor
	Vector::Vector():begin(NULL),capacity(0),size(0){
	}
	Vector::~Vector(){
	delete[] begin;
	}

void Vector::show(ofstream& ofs){
    for(int i=0;i<size;i++){
        ofs << begin[i] << " ";
    }
    ofs << endl;
}

void Vector::push_back(string val)
{
	if(size==capacity){
	if(capacity==0)
	capacity = capacity+1;
	else {
	capacity = capacity*3;
	}
	}
	string *temp_array = new string[capacity];

	for(int i=0; i<size; i++){
	temp_array[i]= begin[i];
	}
	delete []begin;
	begin = temp_array;
	begin[size] = val;
	size++;
	
    //compelete your code
}

int main(int argc, char *argv[])
{
	ifstream ifs;
	ofstream ofs;

	string input;
	
	//compelete your code
	ifs.open(argv[1]);
	ofs.open(argv[2]);


    Vector *v = NULL;
	while(!ifs.eof()){
		v = new Vector();
		//compelete your code)
		
		ifs >> input;
		while(input!=";"){
			v->push_back(input);
			ifs >> input;
		}
		
        ofs << "size: " << v->get_size() << endl;
        ofs << "capacity: "<< v->get_capacity() << endl;
        v->show(ofs);
        ofs << endl;
	}
	ifs.close();
	ofs.close();
	return 0;
}
