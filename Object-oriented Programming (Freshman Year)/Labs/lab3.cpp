#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

bool myfunc(int a, int b){
	if(a<b) return false;
	else return true;
}
int main(){

	//i: push the number to last
	//d: delete last number
	//c: clear the sequence
	//s: sort the sequence (input number: 0-ascend, 1-descend)
	//r: resize the sequence(input size number)
	//z: stop

	char input;
	int number=0, size=0;
	vector<int> v;

	while(1){

		cout << "Input your command:";
		cin >> input;

		if(input=='i'){
			int pushnum;
			cout << "Input the number you want to push:";
			cin >> pushnum;
			v.push_back(pushnum);
		}
		else if(input=='d'){
			v.pop_back();
		}
		else if(input=='c'){
			v.clear();
		}
		else if(input=='s'){
			unsigned int order;
			cout << "\"0:ascending order, 1:descending order\":";
			cin >> order;
			if(order==0){
				sort(v.begin(), v.end());
			}
			else if(order==1){
				sort(v.begin(), v.end(), myfunc);
			}
		}
		else if(input=='r'){
			unsigned int size;
			cout << "input what size do you want to resize:";
			cin >> size;
			v.resize(size);
		}
		else if(input=='z'){
			break;
		}
		else{
			cout << "Your command is not supported, please input again" << endl;
		}

		//print the size of sequence
		cout << "size=" << v.size() << endl;
		//print the number sequence
		cout << "Number Sequence:";
		for(unsigned int i=0; i<v.size(); i++){
			cout << v[i] << " ";
		}
		cout << endl;

	}
	return 0;
}
