#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

class base_employee
{
    private:
        string  m_name;             //employee's name
        int     m_salary;           //salary $$ per month
        double  m_year;             //how many years do this employee stay
        char    m_position;         //C is chairman, M is Manager , E is Employee , P is Part-time
    public:
        base_employee(const string name,double year,char position): m_name(name),m_year(year),m_position(position){}

		void set_salary(int salary)	{m_salary = salary;}

		string name() 		const {return m_name;}
        int    salary() 	const {return m_salary;}
        double year()		const {return m_year;}
        char   position() 	const {return m_position;}
};
ostream& operator<<(ostream &out, base_employee& x){
	out << x.name() << " " << x.position() << " " << x.year() << " " << x.salary() << endl;
	return out;
}
class manager: public base_employee
{
	public:
	int manager_salary;
    manager(const string name, double year, char position):base_employee(name, year, position){	
	
	manager_salary = 22000 + 24000 + 5000*year;
	set_salary(manager_salary);
}
};
class employee: public base_employee
{
    public:
	int employee_salary;
	employee(const string name, double year, char position):base_employee(name, year, position){

	employee_salary = 22000 + 3000*year;
	set_salary(employee_salary);

	
}
};
class parttime: public base_employee
{
    
	public:
	int parttime_salary;
	parttime(const string name, double year, char position):base_employee(name, year, position){
	
	parttime_salary = 22000;
	set_salary(parttime_salary);
	
}
};
class chairman: public manager
{
    public:
	int chairman_salary;
	chairman(const string name, double year, char position):manager(name, year, position){
	
	chairman_salary = (22000 + 24000 + 5000*year + 40000 + 5000*year);
	set_salary(chairman_salary);
	
	}
};

bool myfunc(const base_employee& a, const base_employee& b){
	if(a.salary()<b.salary())
	return false;
	else return true;
};
int main()
{
	int list_length, i;
	string temp_name;
	char temp_title;
	float temp_years;
	int tot_salary;
	int num_manager, num_employee;

    vector<base_employee> data;

    cin >> list_length;
	// data.resize(list_length);
	//
//	manager m(1,23,3);
//	data.push_back(m);

	for(i=0;i<list_length;i++) {

	cin >> temp_name;		//scan in name and title
	cin >> temp_title;
	cin >> temp_years;

	if(temp_title=='M'){
	manager m(temp_name, temp_years, temp_title);
	data.push_back(m);
	tot_salary += m.manager_salary;
//	num_manager ++;
	}
	else if(temp_title=='E'){
	employee e(temp_name, temp_years, temp_title);
	data.push_back(e);
	tot_salary += e.employee_salary;
	num_employee ++;
	}
	else if(temp_title=='P'){
	parttime p(temp_name, temp_years, temp_title);
	data.push_back(p);
	tot_salary += p.parttime_salary;
	num_employee ++;
	}
	else if(temp_title=='C'){
	chairman c(temp_name, temp_years, temp_title);
	data.push_back(c);
	tot_salary += c.chairman_salary;
//	num_manager ++;
	}
	}
	
	sort(data.begin(), data.end(), myfunc);
	
	cout << "Total salary payment is: " << tot_salary << endl;
	cout << "#Manager: " << (list_length-num_employee) << "#Employee: " << num_employee << endl;

	for(i=0; i<list_length; i++){

	cout << data[i] << endl;
	}

	
	
	
    return 1;
	
}
