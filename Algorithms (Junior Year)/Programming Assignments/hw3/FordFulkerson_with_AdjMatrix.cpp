#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <sstream>

using namespace std;

bool BFS_Residual(vector<vector<int>> residualGraph, vector<int> &parentNode)
{
    vector<bool> visited;
    queue<int> bfsQueue;
    int nbOfLocations = parentNode.size();
    visited.resize(nbOfLocations); //size visited array to match number of nodes

    bfsQueue.push(residualGraph[0][0]); //push source into queue
    visited[0] = true;

    while (!bfsQueue.empty())
    {
        int anchorNode = bfsQueue.front();
        bfsQueue.pop(); //remove front element from queue
        for (int i = 0; i < nbOfLocations; i++)
        {
            if (visited[i] == false && residualGraph[anchorNode][i] != 0) //not visited and is connected to anchorNode
            {
                bfsQueue.push(i);
                visited[i] = true;
                parentNode[i] = anchorNode;
            }
        }
    }
    return visited[nbOfLocations - 1]; //see if sink is reached, returns true if yes
}

int FordFulkerson(vector<vector<int>> cargoGraph)
{
    int maxFlow = 0;
    int nbOfLocations = cargoGraph.size();
    vector<vector<int>> residualGraph;
    vector<int> parentNode(nbOfLocations, -1); //initialized to be filled with -1
    residualGraph = cargoGraph;

    while (BFS_Residual(residualGraph, parentNode))
    {
        //find pathflow
        int currNode = parentNode[nbOfLocations - 1];     // "to" node
        int prevNode = parentNode[currNode];              // "from" node
        int pathFlow = residualGraph[prevNode][currNode]; //start from sink's parent and retrace
        while (prevNode != 0)
        {
            pathFlow = (residualGraph[prevNode][currNode] < pathFlow) ? residualGraph[prevNode][currNode] : pathFlow; // no need to consider negative because starts from node prior to sink and stops before currrent is source, thus flow can't be -1 (infinite)
            currNode = prevNode;
            prevNode = parentNode[currNode];
        }

        //update residual network
        currNode = parentNode[nbOfLocations - 1]; // "to" node
        prevNode = parentNode[currNode];          // "from" node
        while (prevNode != 0)
        {
            residualGraph[prevNode][currNode] -= pathFlow;
            residualGraph[currNode][prevNode] += pathFlow;
            currNode = prevNode;
            prevNode = parentNode[currNode];
        }
        //add pathFlow to maxFlow
        maxFlow += pathFlow;
    }
    return maxFlow;
}

int main(int argc, char **argv)
{
    ifstream infile;
    ofstream outfile;
    //infile.open(argv[1]);
    //outfile.open(argv[2]);

    infile.open("test.txt");

    vector<vector<int>> cargoGraph;
    int nbOfLocations, nbOfTrucks, startPt, endPt, loadCap, locationIndex;
    vector<int> locationCapacity;
    string inString;

    infile >> nbOfLocations;
    nbOfLocations += 2;                                              //counting source and add pseudo sink
    cargoGraph.resize(nbOfLocations, vector<int>(nbOfLocations, 0)); //size graph and initialize to indicate no paths btw them (0: no path, -1: infinite capacity)
    locationCapacity.resize(nbOfLocations);

    getline(infile, inString);
    while (inString.length() == 0)       //read until non-blank line
        getline(infile, inString);       // (connected to source) list of warehouses directly connected to factory
    istringstream is_toSource(inString); //extract numbers from string
    while (is_toSource >> locationIndex)
        cargoGraph[0][locationIndex] = -1; //indicate infinite capacity

    getline(infile, inString); // (connected to sink) list of stores
    istringstream is_toSink(inString);
    while (is_toSink >> locationIndex)
        cargoGraph[locationIndex][nbOfLocations - 1] = -1;

    getline(infile, inString);
    while (inString.length() == 0) //read until non-blank line
        getline(infile, inString); //capacity of warehouse and stores
    istringstream is_nodeCap(inString);

    infile >> nbOfTrucks;
    for (int i = 0; i < nbOfTrucks; i++)
    {
        infile >> startPt >> endPt >> loadCap;
        cargoGraph[startPt][endPt] = loadCap;
    }

    //implement new code for bounded node
    // for(int i = 1; i < nbOfLocations-2; i ++)
    // {
    //     string nodeCap
    //     is_nodeCap >>
    // }

    cout << FordFulkerson(cargoGraph);

    //print out graph   ###########################
    // cout << "   ";
    // for (int t = 0; t < nbOfLocations; t++)
    //     cout << t << " ";
    // cout << endl;
    // for (int k = 0; k < nbOfLocations; k++)
    // {
    //     cout << k << ": ";
    //     for (int j = 0; j < nbOfLocations; j++)
    //         cout << cargoGraph[k][j] << " ";
    //     cout << endl;
    // }
    // ##############################################

    return 0;
}
