node* del(int del_key, node* p){
	node* temp = 0;
	if(!target_tree) return NULL;
	else if(del_key < p->key) p->left = del(del_key, p->left);
	else if(del_key > p->key) p->right = del(del_key, p->right);
	else if(p->left && p->right){	//the node is found and has right and left subtree
		temp = p->left;
		while(temp->right){	//find left max
			temp = temp->right;
		}
		p->key = temp->key;
		p-> left = del(p->key, p->left);
	}
	else{
		temp = p;
		if(!p->left) p = p->right;
		else if(!p->right) p = p->left;
		delete temp;
	}
	return p;
}