#include <iostream>
#include <vector>
#include <algorithm>
#include <iomanip>

using namespace std;

class info{
    public:
        int ID=0;
        double height=0, weight=0, BMI=0;

};

bool myfunc(info a, info b){ //compare a certain variable in class type
    if(a.BMI<b.BMI) return true;
        else return false;
}

int main(){
    info data;
    vector<info> v; ///put each student's information in data

    while(1){  ///enter each student's ID and information

        cout << "Student ID:";
        cin >> data.ID;

        if(data.ID==(-1)){
            break;
        }
        cout << "Student's weight:";
        cin >> data.weight;
        cout << "Student's height:";
        cin >> data.height;

        data.BMI=(data.weight/(data.height*data.height));

        v.push_back(data);

            }
///print out all information by entered sequence

int k=0, j=0;

for(k=0;k<(v.size());k++){
    cout << "ID:" << v[k].ID << "|";
    cout << fixed << setprecision(2) << v[k].weight << "|";
    cout << fixed << setprecision(2) << v[k].height << "|";
    cout << v[k].BMI << endl;
}
///sort the information according to the BMI values
    sort(v.begin(), v.end(), myfunc);
///print the information after sorting
    cout << "After sorting" << endl;
for(j=0;j<(v.size());j++){
    cout << "ID:" << v[j].ID << "|";
    cout << fixed << setprecision(2) << v[j].weight << "|";
    cout << fixed << setprecision(2) << v[j].height << "|";
    cout << v[j].BMI << endl;
}

return 0;
}
