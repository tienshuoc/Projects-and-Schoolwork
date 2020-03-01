#include <iostream>
#include <fstream>

using namespace std;

struct node{
	int key;
	int left_size;
	
	node* left;
	node* right;

	node():key(0), left_size(1), left(NULL), right(NULL){};
};

class BST{
	node* root;	
	public:
		BST():root(0){};
		void insertion(int in_key);
		void deletion(int del_key);
		int search(int target_key);
		node* search_rank(int k); 	


node* del(int del_key, node* target_tree); //recursive version

};

void BST::insertion(int in_key){
	node *p = root, *q = 0;	
	while(p){ //by comparison, get to the bottom-most level of the BST where the inserted key belongs
		q = p;
		if(in_key == p->key)
			return;
		if(in_key < p->key){
			p = p->left;
		}
		else p = p->right;
	}
	p = new node;
	p->left = p->right = 0;
	p->key = in_key;
	if(!root) root = p;	//inserting the root into an emtpy BST
	else{
		if(in_key < q->key) q->left = p;
		else q->right = p;
		p = root;
		while(p){	//update ranks, the BST now have at least two nodes
			if(in_key < p->key){
				p->left_size+=1;
				p = p->left;
			}
			else p = p->right;
		}
	}
	return;
}

void BST::deletion(int del_key){ //unfinished, rank update
	node *p = root, *left_max = 0, *q = 0, *prev_p = 0; //p points to the node that is to be deleted
	bool smaller_than_prev = false;
	while(p){
		if(del_key == p->key){
			p = root;
			while(p->key!=del_key){	//update rank
				if(del_key < p->key){
					p->left_size-=1;
					p = p->left;
				}
				else p = p->right;
			}
			if(p->left) p->left_size-=1;

			left_max = p->left;
			q = p;
			if(left_max){ 	//the node that is to be deleted has a left subtree, i.e. has left_max
				while(left_max->right!=0){ //find largest node in left subtree
					q = left_max;
					left_max = left_max->right;
				}					
			p->key = left_max->key; //change the key of p to the one of left_max, same as replacing the deleted node with left_max
			if(left_max->left){	//left_max has left subtree, move it to connect with q
				if(q == p) p->left = left_max->left;
				else q->right = left_max->left;
			}
			delete left_max;
			}
			else{
				if(prev_p){
					if(smaller_than_prev) prev_p->left = p->right;
					else prev_p->right = p->right;
				}
				delete p;
			}
			return;
		}	
		prev_p = p;
		if(del_key < p->key){
			p = p->left;
			smaller_than_prev = true;
		}
		else{
			p = p->right;
			smaller_than_prev = false;
		}
	}
	return;
}
int BST::search(int target_key){ //returns level
	node *p = root;
	bool match = false;
	int level = -1;
	while(p){
		level+=1;
		if(target_key == p->key){
			match = true;
			break;
		}
		else if(target_key < p->key) p = p->left;
		else p = p->right;
	}
	if(match) return level;
	else return -1;
	
}
node* BST::search_rank(int k){
	for(node* t = root; t; ){
		if(k == t->left_size) return t;
		if(k < t->left_size) t = t->left;
		else{
			k-= t->left_size;
			t = t-> right;
		}
	}
	return 0;
}



int main(int argc, char** argv){
	ifstream in_file;
	ofstream out_file;
	in_file.open(argv[1]);
	out_file.open(argv[2]);

	BST my_tree; 

	int task;
	while(in_file>>task){
		int number;
		in_file >> number;
		switch(task){
			case 1:	//insertion
				my_tree.insertion(number);
				break;
			case 2:	//deletion
				my_tree.deletion(number);
				break;
			case 3:	//search
				out_file << my_tree.search(number) << endl;
				break;
			case 4:	//search by rank
				if(my_tree.search_rank(number))
					out_file << my_tree.search_rank(number)->key << " " << my_tree.search(my_tree.search_rank(number)->key)<< endl;
				else out_file << "-1" << endl;
				break;
				
		}
	}

	in_file.close();
	out_file.close();
	
	return 0;
}
