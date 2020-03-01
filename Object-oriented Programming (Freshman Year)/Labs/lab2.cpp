#include <iostream>
#include <cstdio>

using namespace std;

class nctuGrade{

private:
	int PhysicsGrade;
	int CalculusGrade;
	int OopGrade;


public:
	int ID, peraverage, pass[3];

	int getPhy(){
	  return PhysicsGrade;
	}
	int getCal(){
	  return CalculusGrade;
	}
	int getOop(){
	  return OopGrade;
	}


	void setPhy(){
	  cin >> PhysicsGrade;
	}
	void setCal(){
	  cin >> CalculusGrade;
	}
	void setOop(){
	  cin >> OopGrade;
	  }
};

int main()
{
	int k, a, t;  //number of people that passed for each sub
	double Phy=0, Cal=0, Oop=0, passPhy=0, passCal=0, passOop=0;
    nctuGrade data[100];
	
	for(k=0;k<100;k++){
	
	cout << "Please enter the ID: ";
	cin >> data[k].ID;
	
	if(data[k].ID==-1){
	break;
	}
	cout << "Physics:";
	data[k].setPhy();
	cout << "Calculus:";
	data[k].setCal();
	cout << "Oop:";
	data[k].setOop();

	

	data[k].peraverage=((data[k].getPhy()+data[k].getCal()+data[k].getOop()));  //personal average
	}
	data[k].peraverage= (data[k].peraverage/k);

	for(a=0; a<k; a++){			//see how many people passed for each subject

		Phy+=data[a].getPhy();
		Cal+=data[a].getCal();
		Oop+=data[a].getOop();

		if(data[a].getPhy()>=60){
		data[a].pass[0]=1;
		passPhy++;
		}
		if(data[a].getCal()>=60){
		data[a].pass[1]=1;
		passCal++;
		}
		if(data[a].getOop()>=60){
		data[a].pass[2]=1;
		passOop++;
		}
	}

	Phy=Phy/(k);
	Cal=Cal/(k);
	Oop=Oop/(k);
	passPhy=((passPhy/(k))*100);
	passCal=((passCal/(k))*100); 
	passOop=((passOop/(k))*100);

	cout << "number of students:" << k << endl;
	cout << "average grade of Physics: " << Phy << endl;
	cout << "average grade of Calculus: " << Cal << endl;
	cout << "average grade of Oop: " << Oop << endl;
	cout << "pass rate of Physics: " << passPhy << "%" << endl;
	cout << "pass rate of Calculus: " << passCal << "%" << endl;
	cout << "pass rate of Oop: " << passOop << "%" << endl;
	cout << endl;
	cout << "Student Grade:" << endl;
	
	for(t=0; t<k; t++){

	cout << "ID:" << data[t].ID << "Average:" << data[t].peraverage;

	cout << "\t Physics: ";
	if(data[t].pass[0]==1){
	cout << "Pass ";}
	else{
	cout << "Fail ";}

	cout << "Calculus: ";
	if(data[t].pass[1]==1){
	cout << "Pass ";}
	else{
	cout << "Fail ";}
	
	cout << "Oop: ";
	if(data[t].pass[2]==1){
	cout << "Pass ";}
	else{
	cout << "Fail ";}
	
	}

	return 0;
		}

