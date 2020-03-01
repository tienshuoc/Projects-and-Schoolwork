#include <iostream>
#include <string>

using namespace std;

int main()
{
    int input=2;
    string sentence;
    size_t found;

    string a1="(happy)";
    string a2="(heart)";
    string a3="(confused)";
    string a4="(good";
    string a5="(angel)";

    string b1=":D";
    string b2="<3";
    string b3="o.O";
    string b4="(y)";
    string b5="O:)";


    while(1){
    cout << "-1)exit 0)text->graph 1)graph->text: ";
    cin >> input;
    cout << "Input: ";
    cin >> sentence;


    //0
    if(input==0){
    do{
    found= sentence.find(a1);
    if(found!=string::npos){
        sentence.replace(found, 7, b1);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(a2);
    if(found!=string::npos){
        sentence.replace(found, 7, b2);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(a3);
    if(found!=string::npos){
        sentence.replace(found, 10, b3);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(a4);
    if(found!=string::npos){
        sentence.replace(found, 6, b4);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(a5);
    if(found!=string::npos){
        sentence.replace(found, 7, b5);
        }
    }while(found!=string::npos);

    cout << "Output: " << sentence << endl
    << "------------------" << endl;
    }

    //1
    if(input==1){
    do{
    found= sentence.find(b1);
    if(found!=string::npos){
        sentence.replace(found, 2, a1);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(b2);
    if(found!=string::npos){
        sentence.replace(found, 2, a2);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(b3);
    if(found!=string::npos){
        sentence.replace(found, 3, a3);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(b4);
    if(found!=string::npos){
        sentence.replace(found, 3, a4);
        }
    }while(found!=string::npos);

    do{
    found= sentence.find(b5);
    if(found!=string::npos){
        sentence.replace(found, 3, a5);
        }
    }while(found!=string::npos);

    cout << "Output: " << sentence << endl
    << "------------------" << endl;
    }


    //-1
    if(input==-1){
        break;
    }
    else break;
    }
    return 0;
}
