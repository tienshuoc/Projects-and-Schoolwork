#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
#include <vector>
#include<assert.h>
#include<string.h>
#include<stdlib.h>
//#include <vector>

using namespace std;

class Student{
		string name;
		int numClasses;
		string *classList;
	public:
		Student(string n, int num);
		~Student();//dtor
		void input(string c, int i);
		void output(ofstream& ofs);
		bool is_in(string claname);
		string get_name();
};

//----------------------------------------------------------//
Student::Student(string n, int num):numClasses(num), name(n), classList(NULL)//need to finish!!
{
	//ctor, use dynamic array
	//...
	string *temp_classlist = new string[numClasses];
	classList = temp_classlist;
}
//----------------------------------------------------------//
Student::~Student()//need to finish!!
{
	//dealloc dynamic memory
	//...
	delete[] classList;
}
//----------------------------------------------------------//
void Student::input(string c, int i)
{
	//this student's i-th class is c
	classList[i] = c;

}
//----------------------------------------------------------//
void Student::output(ofstream& ofs)
{
	ofs<<setw(8)<<name<<setw(4)<<numClasses<<"  ";
	for(int i=0;i<numClasses;++i){
		ofs<<classList[i]<<", ";
	}
	ofs<<endl;
}
//----------------------------------------------------------//
bool Student::is_in(string claname)//need to finish!!
{
	//if the student is taken <claname> class
	//	return true
	//else
	//	return false
	//...
	for(int i=0; i<numClasses; i++){
        if(classList[i]==claname)
            return true;
        else if(i==numClasses-1)
            return false;
	}
}
//----------------------------------------------------------//
string Student::get_name()
{return name;}
//----------------------------------------------------------//
//----------------------------------------------------------//
int main(int argc, char* argv[])//need to finish!!
{
	ifstream ifs;
    ofstream ofs;
	const char* infile = argv[1];
	const char* outfile = argv[2];
    ifs.open(infile);
	ofs.open(outfile);

    if(!ifs)
		cout<<"input file open fail\n";
	if(!ofs)
		cout<<"output file open fail\n";

    int num_of_students, temp_numclass, clalist_size;
    string in, temp_name, ignore;
    vector<Student*> stulist;
    vector<string> clalist;

	ifs >> ignore;
	ifs >> num_of_students;


	while(!ifs.eof()){
		//read file here
		//...
		ifs >> ignore;
		ifs >> temp_name;
	
		ifs >> ignore;
		ifs >> temp_numclass;
		//string *temp_classlist = new string[temp_numclass];


		Student* s = new Student(temp_name, temp_numclass);  //declare new temp_student of Student type

		ifs >> ignore;

		for(int i=0; i<temp_numclass; i++){
        getline(ifs, in, ',');
        s->input(in, i);

		if(clalist.size()==0){
			clalist.push_back(in);
			clalist_size=1;
			}

  	
		for(int k=0;k<clalist_size;k++){    //add new class into clalist if new type of class is encountered

            if(clalist[k]==in)
                break;
            else if(k==(clalist_size-1)){
				clalist.push_back(in);
				clalist_size+=1;
				}

        }		
					
		}
        //finished reading one student's data

        stulist.push_back(s);   //store it along with previous read data, creating a list of students and their classes



	}


	for(int i=0;i<clalist.size();++i){
		ofs<<"Class: "<<clalist[i]<<endl<<"\t";
		for(int j=0;j<stulist.size()-1;++j){
			if(stulist[j]->is_in(clalist[i]) == true){
				ofs<<stulist[j]->get_name()<<", ";
			}
		}
		ofs<<endl;
	}

	ofs<<"\n#students: "<<stulist.size()-1<<endl;
	ofs<<"Name "<<"  #  "<<"Classes"<<endl;
	for(int i=0;i<stulist.size()-1;++i){
		stulist[i]->output(ofs);
	}
    ifs.close();
    ofs.close();
    return 0;
}

