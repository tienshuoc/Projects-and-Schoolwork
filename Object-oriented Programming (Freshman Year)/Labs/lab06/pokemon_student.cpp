#include <iostream>
#include <vector>
using namespace std;

class skill{
    private:
        string skill_name;
        int skill_damage;
    public:
        skill(string p_name="Pound",int p_damage=35,int p_level=5):skill_name(p_name),skill_damage(p_damage*p_level/400+p_damage){}
        string SKILL(){return skill_name;}
        int DAMAGE(){return skill_damage;}
};

class Pokemon {
    private:
        string m_name;
        int level;              //the input is greater than 0 (we won't give the illegal value)
        int type;               //normal:0, fire:1, water:2, grass:3 (we won't give the illegal value)
        int HP;                 //HP = 15 + level*2
        int FULL_HP;            //FULL-HP will not be changed after construct.
        skill pokemon_skill[4];
    public:
        Pokemon(string p_name="Pikachu",int p_level=5,int p_type=0):m_name(p_name),level(p_level),type(p_type),HP(15+p_level*2),FULL_HP(15+p_level*2){}
        string NAME(){return m_name;}
        int LEVEL(){return level;}
        int TYPE(){return type;}
        void set_HP(int p_damage){HP-=p_damage;}
        int  get_HP(){return HP;}
        int  FULLHP(){return FULL_HP;}

		bool Ability_to_fight(){
			if(HP>0)
				return true;
			else
				return false;
		}
        void alive(){			 //You can use this function to print each pokemon's status after the battle
            if(HP>0)
                cout<<m_name<<" HP: "<<HP<<"/"<<FULL_HP<<endl;
            else
                cout<<m_name<<" loss ability to fight!!"<<endl;
        }
        string TYPE_NAME(){
            if(type==1) return "Fire";
            else if(type==2) return "Water";
            else if(type==3) return "Grass";
            else return "Normal";
        }
        void set_skill(skill p_skill1,skill p_skill2,skill p_skill3,skill p_skill4){
            pokemon_skill[0]=p_skill1;
            pokemon_skill[1]=p_skill2;
            pokemon_skill[2]=p_skill3;
            pokemon_skill[3]=p_skill4;
        }
        skill SKILL(int p_num){return pokemon_skill[p_num];}

        virtual void attack(Pokemon*,int)=0; //You need to override this function in each type. attack( [Defender], [Attacker skill's number] )
};

class pokemon_fire:public Pokemon{
    public:
        pokemon_fire(string name, int level, int type):Pokemon(name, level, type){}
        void attack(Pokemon* attckr, int attckr_skill_num){   //attacked by whom, their skill's number, and calculate the damage dealt
            if((attckr->TYPE()== 0)||(attckr->TYPE()== 1)){
                set_HP(attckr->SKILL(attckr_skill_num-1).DAMAGE());
            }
            else if(attckr->TYPE()== 2){
                int damage_dealt;
                damage_dealt = (attckr->SKILL(attckr_skill_num-1).DAMAGE())*2;
                set_HP(damage_dealt);
            }
            else if(attckr->TYPE()== 3){
                int damage_dealt;
                damage_dealt = (attckr->SKILL(attckr_skill_num-1).DAMAGE())*0.5;
                set_HP(damage_dealt);
            }                                                           //normal:0, fire:1, water:2, grass:3
        }
    //compelete your code
};
class pokemon_water:public Pokemon{
    public:
        pokemon_water(string name, int level, int type):Pokemon(name, level, type){}
        void attack(Pokemon* attckr, int attckr_skill_num){   //attacked by whom, their skill's number, and calculate the damage dealt
            if((attckr->TYPE()== 0)||(attckr->TYPE()== 2)){
                set_HP(attckr->SKILL(attckr_skill_num-1).DAMAGE());
            }
            else if(attckr->TYPE()== 1){
                int damage_dealt;
                damage_dealt = (attckr->SKILL(attckr_skill_num-1).DAMAGE())*0.5;
                set_HP(damage_dealt);
            }
            else if(attckr->TYPE()== 3){
                int damage_dealt;
                damage_dealt = (attckr->SKILL(attckr_skill_num-1).DAMAGE())*2;
                set_HP(damage_dealt);
            }                                                           //normal:0, fire:1, water:2, grass:3
        }
    //compelete your code
};
class pokemon_grass:public Pokemon{
    public:
        pokemon_grass(string name, int level, int type):Pokemon(name, level, type){}
        void attack(Pokemon* attckr, int attckr_skill_num){   //attacked by whom, their skill's number, and calculate the damage dealt
            if((attckr->TYPE()== 0)||(attckr->TYPE()== 3)){
                set_HP(attckr->SKILL(attckr_skill_num-1).DAMAGE());
            }
            else if(attckr->TYPE()== 1){
                int damage_dealt;
                damage_dealt = (attckr->SKILL(attckr_skill_num-1).DAMAGE())*2;
                set_HP(damage_dealt);
            }
            else if(attckr->TYPE()== 2){
                int damage_dealt;
                damage_dealt = (attckr->SKILL(attckr_skill_num-1).DAMAGE())*0.5;
                set_HP(damage_dealt);
            }
        }
    //compelete your code
};
class pokemon_normal:public Pokemon{
    public:
        pokemon_normal(string name, int level, int type):Pokemon(name, level, type){}
        void attack(Pokemon* attckr, int attckr_skill_num){   //attacked by whom, their skill's number, and calculate the damage dealt
                set_HP(attckr->SKILL(attckr_skill_num-1).DAMAGE());
        }
    //compelete your code
};
int main(int argv,char** argc){

    int num_of_pokemon, temp_level, temp_type, temp_damage, i, num_of_rounds;
    int fighter_one_num, fighter_one_skill_num, fighter_two_num, fighter_two_skill_num;
    string temp_name, temp_skill_name;
 //   skill temp_skill_1, temp_skill_2, temp_skill_3, temp_skill_4;
    vector<Pokemon*> pokemon;


    cin >> num_of_pokemon;

    while(num_of_pokemon > 0){          //input all pokemons and store them into their respective classes
    cin >> temp_name;
    cin >> temp_level;
    cin >> temp_type;

        cin >> temp_skill_name;
        cin >> temp_damage;
        skill temp_skill_1(temp_skill_name, temp_damage, temp_level);
        cin >> temp_skill_name;
        cin >> temp_damage;
        skill temp_skill_2(temp_skill_name, temp_damage, temp_level);
        cin >> temp_skill_name;
        cin >> temp_damage;
        skill temp_skill_3(temp_skill_name, temp_damage, temp_level);
        cin >> temp_skill_name;
        cin >> temp_damage;
        skill temp_skill_4(temp_skill_name, temp_damage, temp_level);

    if(temp_type == 0){
        num_of_pokemon--;
        pokemon_normal* n = new pokemon_normal(temp_name, temp_level, temp_type);

        n->set_skill(temp_skill_1, temp_skill_2, temp_skill_3, temp_skill_4);

        pokemon.push_back(n);
        }
    else if(temp_type == 1){
        num_of_pokemon--;
        pokemon_fire* f = new pokemon_fire(temp_name, temp_level, temp_type);


        f->set_skill(temp_skill_1, temp_skill_2, temp_skill_3, temp_skill_4);
        pokemon.push_back(f);
        }
    else if(temp_type == 2){
        num_of_pokemon--;
        pokemon_water* w = new pokemon_water(temp_name, temp_level, temp_type);

        w->set_skill(temp_skill_1, temp_skill_2, temp_skill_3, temp_skill_4);
        pokemon.push_back(w);
        }
    else if(temp_type == 3){
        num_of_pokemon--;
        pokemon_grass* g = new pokemon_grass(temp_name, temp_level, temp_type);

        g->set_skill(temp_skill_1, temp_skill_2, temp_skill_3, temp_skill_4);
        pokemon.push_back(g);
        }
    }

    cin >> num_of_rounds;

    int (*round_rec)[4] = new int[num_of_rounds][4];     // !! round one is stored in i = 0;
    for(i=0; i<num_of_rounds; i++){
        cin >> round_rec[i][0];    //first fighter of round-1 = i
        cin >> round_rec[i][1];    //skill used by first fighter
        cin >> round_rec[i][2];    //second fighter
        cin >> round_rec[i][3];    //skill used by second fighter
    }

    for(i=0;i<pokemon.size();i++){       //print each pokemon with its info
        cout << pokemon[i]->NAME() << " " << "TYPE:" << pokemon[i]->TYPE_NAME() << " ";
        cout << "LEVEL:" << pokemon[i]->LEVEL() << " " << "HP:" << pokemon[i]->FULLHP() << endl;
        cout << "SKILL1: " <<  pokemon[i]->SKILL(0).SKILL() << " " << pokemon[i]->SKILL(0).DAMAGE() << endl;
        cout << "SKILL2: " <<  pokemon[i]->SKILL(1).SKILL() << " " << pokemon[i]->SKILL(1).DAMAGE() << endl;
        cout << "SKILL3: " <<  pokemon[i]->SKILL(2).SKILL() << " " << pokemon[i]->SKILL(2).DAMAGE() << endl;
        cout << "SKILL4: " <<  pokemon[i]->SKILL(3).SKILL() << " " << pokemon[i]->SKILL(3).DAMAGE() << endl;
    }

    for(i=0; i<num_of_rounds; i++){
        cout << "Round " << i+1 << endl;

        fighter_one_num = round_rec[i][0]-1;
        fighter_one_skill_num = round_rec[i][1];
        fighter_two_num = round_rec[i][2]-1;
        fighter_two_skill_num = round_rec[i][3];


        cout << pokemon[fighter_one_num]->NAME() << " Attack " << pokemon[fighter_two_num]->NAME();
        cout << "(" << pokemon[fighter_one_num]->SKILL(fighter_one_skill_num-1).SKILL() << ")" << endl;
        pokemon[fighter_two_num]->attack(pokemon[fighter_one_num], fighter_one_skill_num);                              //calculate remaining HP of second fighter

        cout << pokemon[fighter_two_num]->NAME() << " HP:" << pokemon[fighter_two_num]->get_HP() << "/" << pokemon[fighter_two_num]->FULLHP() << endl;

        cout << pokemon[fighter_two_num]->NAME() << " Attack " << pokemon[fighter_one_num]->NAME();
        cout << "(" << pokemon[fighter_two_num]->SKILL(fighter_two_skill_num-1).SKILL() << ")" << endl;
        pokemon[fighter_one_num]->attack(pokemon[fighter_two_num], fighter_two_skill_num);                              //calculate remaining HP of first fighter
        cout << pokemon[fighter_one_num]->NAME() << " HP:" << pokemon[fighter_one_num]->get_HP() << "/" << pokemon[fighter_one_num]->FULLHP() << endl;

        if((pokemon[fighter_two_num]->get_HP()<0)||(pokemon[fighter_one_num]->get_HP()<0))
            break;

        //after each round, if one of them has negative HP print unable message and break
    }

    cout << "---------------------------" << endl;
    for(i=0; i<pokemon.size();i++){
        pokemon[i]->alive();
    }






    return 0;
    //compelete your code
}
