#include <iostream>
#include <fstream>
#include <queue>
#include <stack>
#include <vector>

//bottom left is (0,0)
struct record { bool visited; int steps, prev_x, prev_y; };
struct mark { int x, y, dir; }; //dir- 0:right, 1:down, 2:left, 3:up
struct offsets { int a, b; };
struct Vertex { int x, y; };
struct Route { int cost; std::vector<Vertex> track; };

class node{
public:
	bool not_accessible;
	int right_path, left_path, up_path, down_path;
	int degree;
	bool is_odd_degree;
	node();
};
node::node():not_accessible(1), right_path(0), left_path(0), up_path(0), down_path(0), degree(0), is_odd_degree(0){}

Route shortest_path_to_nearest_odd(std::vector< std::vector<node>> &graph, int u_row, int u_col) {
	std::vector<std::vector<record>> log_book(graph.size(), std::vector<record>(graph[0].size()));
	bool success = false;
	std::queue<mark> path;
	int least_steps = 0;
	int r, c;

	offsets move[4];
	move[0].a = 0;
	move[0].b = 1;
	move[1].a = 1;
	move[1].b = 0;
	move[2].a = 0;
	move[2].b = -1;
	move[3].a = -1;
	move[3].b = 0;

	mark z;
	z.x = u_row;
	z.y = u_col;
	z.dir = 0;
	path.push(z);
	log_book[u_row][u_col].visited = 1;

	while (!path.empty())
	{
		while (path.front().dir < 4)
		{
			r = path.front().x + move[path.front().dir].a;
			c = path.front().y + move[path.front().dir].b;
			if (graph[r][c].is_odd_degree && r!= u_row && c!=u_col)
			{
				success = true;
				break;
			}
			if ((!graph[r][c].not_accessible) && (log_book[r][c].visited != 1))
			{
				mark w;
				w.x = r;
				w.y = c;
				w.dir = 0;
				path.push(w);
				log_book[r][c].visited = 1;
				log_book[r][c].steps = log_book[path.front().x][path.front().y].steps + 1;
				log_book[r][c].prev_x = path.front().x;
				log_book[r][c].prev_y = path.front().y;
			}
			path.front().dir += 1;
		}
		if (success) break;
		path.pop();
	}

	Route route;
	Vertex vertex;
	vertex.x = r;
	vertex.y = c;
	route.track.push_back(vertex);

	int row = path.front().x;
	int col = path.front().y;
	route.cost = 1;

	while ((row != u_row) || (col != u_col))	//count cost
	{
		vertex.x = row;
		vertex.y = col;
		route.track.push_back(vertex);
		route.cost += 1;
		int temp_row = row;
		row = log_book[row][col].prev_x; 
		col = log_book[temp_row][col].prev_y;
	}
	vertex.x = u_row;
	vertex.y = u_col;
	route.track.push_back(vertex);

	return route;
}
//find the shortest path to nearest odd degree vertex

int main(int argc, char** argv)
{
	std::ifstream in_file;
	std::ofstream out_file;
	in_file.open(argv[1]);
	out_file.open(argv[2]);

	int num_of_rows = 0, num_of_cols = 0;
	in_file >> num_of_cols >> num_of_rows;

	std::vector<std::vector<node>> graph(num_of_rows, std::vector<node>(num_of_cols));
	std::vector<Vertex> list_of_odd_degree;
	int cost = 0;
	int original_edges = 0;

	for (int r = 0; r < num_of_rows; r++)	//create graph
		for (int c = 0; c < num_of_cols; c++) {
			in_file >> graph[r][c].not_accessible;
		}
	for (int r = 0; r < num_of_rows; r++) {
		for (int c = 0; c < num_of_cols; c++) {
			if (!graph[r][c].not_accessible)
			{
				if (!graph[r - 1][c].not_accessible) { graph[r][c].up_path = 1; }
				if (!graph[r + 1][c].not_accessible) { graph[r][c].down_path = 1; }
				if (!graph[r][c - 1].not_accessible) { graph[r][c].left_path = 1; }
				if (!graph[r][c + 1].not_accessible) { graph[r][c].right_path = 1; }

				graph[r][c].degree = graph[r][c].up_path + graph[r][c].down_path + graph[r][c].left_path + graph[r][c].right_path;
				original_edges += graph[r][c].degree;

				if (graph[r][c].degree % 2) //odd-degree
				{
					graph[r][c].is_odd_degree = true;
					Vertex p;
					p.x = r;
					p.y = c;
					list_of_odd_degree.push_back(p);
				}
				else graph[r][c].is_odd_degree = false;
			}
		}
	}
	original_edges /= 2;
	//label odd degree nodes(put into a list) & initialize paths & count original edges
	
	for (std::vector<Vertex>::iterator i = list_of_odd_degree.begin(); i != list_of_odd_degree.end(); i ++) {
		if (graph[i->x][i->y].is_odd_degree == false) continue;
		std::vector<Vertex> temp_track;
		cost += shortest_path_to_nearest_odd(graph, i->x, i->y).cost;
		temp_track = shortest_path_to_nearest_odd(graph, i->x, i->y).track;

		std::vector<Vertex>::iterator q = temp_track.end();
		graph[temp_track[0].x][temp_track[0].y].is_odd_degree = false;
		graph[temp_track[temp_track.size() - 1].x][temp_track[temp_track.size() - 1].y].is_odd_degree = false;
		//change the first and last vertexs' is_odd_degree status

		for (std::vector<Vertex>::iterator p = temp_track.begin(); (p != temp_track.end()-1); p++) {
			int a = p->x,
				b = p->y,
				j = (p+1)->x,
				k = (p+1)->y;
			if ((a + 1) == j && b == k) {
				graph[a][b].down_path += 1;
				graph[a][b].degree += 1;
				graph[j][k].up_path += 1;
				graph[j][k].degree += 1;
			}
			else if ((a - 1) == j && b == k) {
				graph[a][b].up_path += 1;
				graph[a][b].degree += 1;
				graph[j][k].down_path += 1;
				graph[j][k].degree += 1;
			}
			else if ((b + 1) == k && a== j) {
				graph[a][b].right_path += 1;
				graph[a][b].degree += 1;
				graph[j][k].left_path += 1;
				graph[j][k].degree += 1;
			}
			else if ((b - 1) == k && a==j) {
				graph[a][b].left_path += 1;
				graph[a][b].degree += 1;
				graph[j][k].right_path += 1;
				graph[j][k].degree += 1;
			}
		}
	}
	//construct additional edges to form eulerian graph

	std::stack<Vertex> current_path;	//Travel Euler circuit
	std::vector<Vertex> circuit;
	Vertex current_vertex;
	current_vertex.x = 0; current_vertex.y = 0;

	for (int r = 0; r < num_of_rows; r++) {
		bool found_start = false;
		for (int c = 0; c < num_of_cols; c++) {
			if (!graph[r][c].not_accessible) {
				current_vertex.x = r;
				current_vertex.y = c;
				found_start = true;
				break;
			}
		}
		if (found_start) break;
	}
	//find starting vertex

	current_path.push(current_vertex);
	
	while (!current_path.empty())
	{
		if (graph[current_vertex.x][current_vertex.y].degree>0)
		{
			current_path.push(current_vertex);
			Vertex next_vertex;
			if (graph[current_vertex.x][current_vertex.y].right_path > 0)
			{
				next_vertex.x = current_vertex.x;
				next_vertex.y = current_vertex.y + 1;
				graph[current_vertex.x][current_vertex.y].degree-=1;
				graph[current_vertex.x][current_vertex.y].right_path-=1;
				graph[next_vertex.x][next_vertex.y].degree-=1;
				graph[next_vertex.x][next_vertex.y].left_path-=1;
			}
			else if (graph[current_vertex.x][current_vertex.y].up_path > 0)
			{
				next_vertex.x = current_vertex.x - 1;
				next_vertex.y = current_vertex.y;
				graph[current_vertex.x][current_vertex.y].degree-=1;
				graph[current_vertex.x][current_vertex.y].up_path-=1;
				graph[next_vertex.x][next_vertex.y].degree-=1;
				graph[next_vertex.x][next_vertex.y].down_path-=1;
			}
			else if (graph[current_vertex.x][current_vertex.y].left_path > 0)
			{
				next_vertex.x = current_vertex.x;
				next_vertex.y = current_vertex.y - 1;
				graph[current_vertex.x][current_vertex.y].degree -= 1;
				graph[current_vertex.x][current_vertex.y].left_path -= 1;
				graph[next_vertex.x][next_vertex.y].degree -= 1;
				graph[next_vertex.x][next_vertex.y].right_path -= 1;
			}
			else if (graph[current_vertex.x][current_vertex.y].down_path>0)
			{
				next_vertex.x = current_vertex.x + 1;
				next_vertex.y = current_vertex.y;
				graph[current_vertex.x][current_vertex.y].degree-=1;
				graph[current_vertex.x][current_vertex.y].down_path-=1;
				graph[next_vertex.x][next_vertex.y].degree-=1;
				graph[next_vertex.x][next_vertex.y].up_path-=1;
			}
			current_vertex.x = next_vertex.x;
			current_vertex.y = next_vertex.y;
		}
		else
		{
			circuit.push_back(current_vertex);
			current_vertex = current_path.top();
			current_path.pop();
		}
	}
	for (int i = circuit.size() - 1; i >= 0; i--)
		out_file << circuit[i].y << " " << num_of_rows - 1 - circuit[i].x << std::endl;
	//convert coordinates for rows & swap x y to match definition

	in_file.close();
	out_file.close();
	return 0;
}
