#include <iostream>
#include <fstream>
#include <stack>
#include <vector>
#include <queue>

using namespace std;


struct mark{int x, y, dir;};	//dir- 0:right, 1:down, 2:left, 3:up
struct offsets {int a, b;};

struct record{bool visited; int steps, prev_x, prev_y;};

int main(int argc, char** argv){
	ifstream in_file;
	ofstream out_file_1, out_file_2;
	
	in_file.open(argv[1]);
	out_file_1.open(argv[2]);
	out_file_2.open(argv[3]);
	
	offsets move[4];
	move[0].a = 0;
	move[0].b = 1;
	move[1].a = 1;
	move[1].b = 0;
	move[2].a = 0;
	move[2].b = -1;
	move[3].a = -1;
	move[3].b = 0;	
	
	int width, height;
	int i, j;
	int start_x, start_y;
	int success = 0;
	stack<mark> path;
	
	bool success_2 = 0;
	queue<mark> path_2;
	int least_steps = 0;
	int r, c;

	in_file >> width >> height; 

	//vectors for first method:
	vector< vector<char> > maze(height, vector<char>(width, '2'));
	vector< vector<bool> > log(height, vector<bool>(width, 0)); //used to log paths that have been taken

	//vectors for second method:
	vector< vector<char> > maze_2(height, vector<char>(width, '2'));
	vector< vector<record> > log_2(height, vector<record>(width));

	for(int k=0; k<height; k++)	//scan all data into maze array and look for 'S';
	{
		for(int q=0; q<width; q++)
		{
			in_file >> maze[k][q];
			maze_2[k][q] = maze[k][q];
			if(maze[k][q]=='S')
			{		//look for 'S'
				mark a;				//push 'S' position into stack
				a.x = k;
				a.y = q;
				a.dir = 0;
				path.push(a);
				path_2.push(a);
				log_2[k][q].visited = 1;
				i = k;
				j = q;
				start_x = k;
				start_y = q;
			}
		}
	}

	while(!path.empty())	//method one
	{
		int dir = path.top().dir;
		i = path.top().x;
		j = path.top().y;
		path.pop();
		
		while(dir<4)
		{	
			int g = i + move[dir].a;
			int h = j + move[dir].b;
			if(maze[g][h]=='E')
			{
				maze[i][j] = '1';
				success = 1;
				break;
			}
			if((maze[g][h]!='2')&&(log[g][h]!=1))
			{
				log[g][h] = 1;

				mark a;
				a.x = i;
				a.y = j;
				a.dir = dir;	
				path.push(a);
				i = g; j = h; dir = 0;
			}
			else dir+=1;
		}
		if(success == 1)
			break;
	}

	while(!path_2.empty())	//method 2 (BFS)
	{
		while(path_2.front().dir<4)
		{
			r = path_2.front().x + move[path_2.front().dir].a;
			c = path_2.front().y + move[path_2.front().dir].b;
			if(maze_2[r][c]=='E')
			{
				success_2 = 1;
				break;
			}
			if((maze_2[r][c]!='2')&&(log_2[r][c].visited!=1))
			{
				mark b;
				b.x = r;
				b.y = c;
				b.dir = 0;
				path_2.push(b);
				log_2[r][c].visited = 1;
				log_2[r][c].steps = log_2[path_2.front().x][path_2.front().y].steps + 1;
				log_2[r][c].prev_x = path_2.front().x;
				log_2[r][c].prev_y = path_2.front().y;
			}
			path_2.front().dir+=1;
		}
		if(success_2 == 1)
			break;
		path_2.pop();
	}

	while(!path.empty())	//write path for maze
	{
		maze[path.top().x][path.top().y] = '1';
		path.pop();
	}

	maze[start_x][start_y] = 'S';

 	int row = path_2.front().x;
	int col = path_2.front().y;

	while(maze_2[row][col]!='S')	//write path for maze_2
	{
		maze_2[row][col] = '1';
		int temp_row = row;		//the value of row would soon change
		row = log_2[row][col].prev_x;
		col = log_2[temp_row][col].prev_y;
	}

		for(int k=0; k<height; k++)
		{
			for(int q=0; q<width; q++)
			{
				out_file_1 << maze[k][q] << " ";
				out_file_2 << maze_2[k][q] << " ";
			}
			out_file_1 << endl;
			out_file_2 << endl;
		}

	
	in_file.close();
	out_file_1.close();
	out_file_2.close();
	
return 0;
}
