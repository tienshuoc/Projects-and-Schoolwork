#include<iostream>
#include<vector>
using namespace std;

class shape{
	public:
		shape(string p_name,string p_type):name(p_name),type(p_type),Side_length(){}

		void set_Side(int p_Side){Side_length.push_back(p_Side);} 

		vector<int> Side() {return Side_length;}

		string TYPE(){return type;}
		string NAME(){return name;}

		virtual double perimeter()=0; //You need to override this function in each class.
	private:
		vector<int> Side_length;
		string name,type;
};

class polygon : public shape{

	public:
		polygon(string p_name, string p_type):shape(p_name, p_type){

		}
		virtual double perimeter()= 0;
		//compelete your code
};

class circle : public shape{
	public:
		circle(string p_name, string p_type):shape(p_name,p_type){	}
		double perimeter(){
			vector<int>side = Side();
			if(side[0]==-1)
				return -1;
			else return 2*3.14*side[0];
		}
		bool legal(){
			vector<int>side = Side();
			if(side[0] > 0)
			return true;
			else return false;
		}
};

class triangle : public polygon{
	public:
		triangle(string p_name, string p_type):polygon(p_name,p_type){	}
		double perimeter(){
			vector<int>side = Side();
			if(side[0]==-1)
				return -1;
			else return side[0]+side[1]+side[2];	
		}
		bool legal(){
			vector<int>side = Side();
			if((side[0] > 0)&&(side[1]>0)&&(side[2]>0)&&(side[0]+side[1]>side[2])&&(side[0]+side[2]>side[1])&&(side[1]+side[2]>side[0]))
				return true;
				else return false;
		}
		//compelete your code
};

class rectangle : public polygon{
	public:
		rectangle(string p_name, string p_type):polygon(p_name,p_type){	}
		double perimeter(){
			vector<int>side = Side();
			if(side[0]==-1)
				return -1;
			else return side[0]+side[1]+side[2]+side[3];
		}
		virtual bool legal(){
			vector<int>side = Side();
			if((side[0]>0)&&(side[1]>0)&&(side[2]>0)&&(side[3]>0)&&(side[0]==side[2])&&(side[1]==side[3]))
				return true;
				else return false;
		}
		//compelete your code
};

class square : public rectangle{
	public:
		square(string p_name, string p_type):rectangle(p_name,p_type){	}
		double perimeter(){
			vector<int>side = Side();
			if(side[0]==-1)
				return -1;
			else return side[0]+side[1]+side[2]+side[3];
		}
		bool legal(){
			vector<int>side = Side();
			if((side[0]>0)&&(side[1]>0)&&(side[2]>0)&&(side[3]>0)&&(side[0]==side[2])&&(side[1]==side[3])&&(side[1]==side[2]))
				return true;
				else return false;
		}
		//compelete your code
};

int main(int argv,char** argc){
	int i, circle_num=0,triangle_num=0,rectangle_num=0,square_num=0;
	vector<shape*> LEGAL_SHAPE,ILLEGAL_SHAPE;

	int size;
	string temp_name, temp_type;
	int temp_side;

	cin >> size;
	while(size!=0){
		cin >> temp_name;
		cin >> temp_type;


		if(temp_type == "triangle"){
		triangle_num++;
			triangle* t = new triangle(temp_name, "triangle");

				cin >> temp_side;
				t->set_Side(temp_side);
				cin >> temp_side;
				t->set_Side(temp_side);
				cin >> temp_side;
				t->set_Side(temp_side);

			if(t->legal()){
				LEGAL_SHAPE.push_back(t);
				
			}
			else{
				ILLEGAL_SHAPE.push_back(t);
			}
		}

		else if(temp_type == "circle"){
		circle_num++;
			circle* c = new circle(temp_name, "circle");
		cin >> temp_side;
c->set_Side(temp_side);

			if(c->legal()){
				LEGAL_SHAPE.push_back(c);
							}
			else
				ILLEGAL_SHAPE.push_back(c);
		}

		else if(temp_type == "rectangle"){
		rectangle_num ++;
			rectangle* r = new rectangle(temp_name, "rectangle");
	cin >> temp_side;
				r->set_Side(temp_side);
				cin >> temp_side;
				r->set_Side(temp_side);
				cin >> temp_side;
				r->set_Side(temp_side);
				cin >> temp_side;
				r->set_Side(temp_side);
			if(r->legal()){
				LEGAL_SHAPE.push_back(r);
			
				
			}
			else
				ILLEGAL_SHAPE.push_back(r);
		}

		else if(temp_type == "square"){
		square_num++;
			square* s = new square(temp_name,"square");
			//s.square(temp_name, "square");
cin >> temp_side;
				s->set_Side(temp_side);
				cin >> temp_side;
				s->set_Side(temp_side);
				cin >> temp_side;
				s->set_Side(temp_side);
				cin >> temp_side;
				s->set_Side(temp_side);

			if(s->legal()){
				LEGAL_SHAPE.push_back(s);
								
			}
			else
				ILLEGAL_SHAPE.push_back(s);
		}


		size--;
	}

	//compelete your code

	cout<<"[# of each shape]"<<endl;
	cout<<"Triangle: "<<triangle_num<<endl;
	cout<<"Rectangle: "<<rectangle_num<<endl;
	cout<<"Square: "<<square_num<<endl;
	cout<<"Circle: "<<circle_num<<endl;

	cout<<"\n[Legal]"<<endl;
	for(int i=0 ; i<LEGAL_SHAPE.size() ; ++i){
		cout<<"NAME: "<<LEGAL_SHAPE[i]->NAME()<<", \tPERIMETER: "<<LEGAL_SHAPE[i]->perimeter()<<",  \tTYPE: "<<LEGAL_SHAPE[i]->TYPE()<<endl;
	}
	cout<<"\n[Illegal]"<<endl;
	for(int i=0 ; i<ILLEGAL_SHAPE.size() ; ++i){
		cout<<"NAME: "<<ILLEGAL_SHAPE[i]->NAME()<<", \tPERIMETER: "<<"-1"<<",  \tTYPE: "<<ILLEGAL_SHAPE[i]->TYPE()<<endl;
	}

	return 0;
}
