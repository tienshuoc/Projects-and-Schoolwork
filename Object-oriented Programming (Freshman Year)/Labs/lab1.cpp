#include <iostream>
using namespace std;

int main()
{
	char insert_information;
	int unsigned people=0, adult=0; 
	int age=0;
	const unsigned legal_age=18;
	double mean=0;
	
while(1)
{	
	cout << "Key in Y to insert more personal information or N to exit: ";
	cin >> insert_information;

	if(insert_information=='N'){
		cout << "Exit from inserting personal information." << endl;
	if(people!=0){
			mean=(mean/people);
		}
		cout << "The number of people is: " << people << endl;
		cout << "The mean value of their age is: " << mean << endl;
		cout << "The number of adults is: " << adult << endl;

		break;
	}
		else if(insert_information=='Y'){
			cout << "Key in the age of the person: ";
			cin >> age;
				if(age<0){
					cout << "You keyed in a negative number, please key in again." << endl;
					}
					else{
						people++;
						mean+=age;
							if(age>=legal_age){
								adult++;
							}
					}
				}
		else{
			cout << "Please key in again." << endl;
			}
	}

	return 0;
}
