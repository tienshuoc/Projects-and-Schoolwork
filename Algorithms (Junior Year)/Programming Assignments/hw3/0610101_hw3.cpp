#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <sstream>
#include <map>

using namespace std;

bool BFS_Residual(map<int, map<int, int>> residualGraph, vector<int> &parentNode, int sinkIndex)
{
    map<int, bool> visited;
    queue<int> bfsQueue;

    bfsQueue.push(0); //push source into queue
    visited[0] = true;

    while (!bfsQueue.empty())
    {
        int anchorNode = bfsQueue.front();
        bfsQueue.pop(); //remove front element from queue

        map<int, int>::iterator ptr;

        for (ptr = residualGraph[anchorNode].begin(); ptr != residualGraph[anchorNode].end(); ptr++)
        {
            int i = ptr->first;

            if (visited[i] != true && ptr->second != 0) //not visited and is connected to anchorNode
            {
                bfsQueue.push(i);
                visited[i] = true;
                parentNode[i] = anchorNode;
            }
        }
    }
    return visited[sinkIndex]; //see if sink is reached, returns true if yes
}

int FordFulkerson_EK(map<int, map<int, int>> cargoGraph, int nbOfLocations, int sinkIndex)
{
    int maxFlow = 0;
    map<int, map<int, int>> residualGraph;
    vector<int> parentNode(nbOfLocations, -1); //initialized to be filled with -1
    residualGraph = cargoGraph;

    while (BFS_Residual(residualGraph, parentNode, sinkIndex))
    {
        //find pathflow
        int currNode = parentNode[sinkIndex];             // "to" node
        int prevNode = parentNode[currNode];              // "from" node
        int pathFlow = residualGraph[prevNode][currNode]; //start from sink's parent and retrace
        while (prevNode != 0)
        {
            pathFlow = (residualGraph[prevNode][currNode] < pathFlow) ? residualGraph[prevNode][currNode] : pathFlow; // no need to consider negative because starts from node prior to sink and stops before currrent is source, thus flow can't be -1 (infinite)
            currNode = prevNode;
            prevNode = parentNode[currNode];
        }

        //update residual network
        currNode = parentNode[sinkIndex]; // "to" node
        prevNode = parentNode[currNode];  // "from" node
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
    infile.open(argv[1]);
    outfile.open(argv[2]);

    map<int, map<int, int>>::iterator firstItr;
    map<int, int>::iterator secondItr;
    map<int, map<int, int>> cargoGraph;
    int nbOfLocations, nbOfTrucks, startPt, endPt, loadCap, locationIndex, sinkIndex;
    string inString;

    infile >> nbOfLocations;
    nbOfLocations += 2; //counting source and add pseudo sink

    std::getline(infile, inString);
    while (inString.length() == 0)       //read until non-blank line
        std::getline(infile, inString);  // (connected to source) list of warehouses directly connected to factory
    istringstream is_toSource(inString); //extract numbers from string
    while (is_toSource >> locationIndex)
        cargoGraph[0][locationIndex] = -1; //indicate infinite capacity

    std::getline(infile, inString); // (connected to sink) list of stores
    istringstream is_toSink(inString);
    while (is_toSink >> locationIndex)
        cargoGraph[locationIndex][nbOfLocations - 1] = -1;

    std::getline(infile, inString);
    while (inString.length() == 0)      //read until non-blank line
        std::getline(infile, inString); //capacity of warehouse and stores
    istringstream is_nodeCap(inString);

    infile >> nbOfTrucks;
    for (int i = 0; i < nbOfTrucks; i++)
    {
        infile >> startPt >> endPt >> loadCap;
        cargoGraph[startPt][endPt] = loadCap;
    }

    sinkIndex = nbOfLocations - 1;
    //if there is a capacity limit, replace vertex with two vertexes with the capacity as the weighted edge in between
    for (int i = 1; i < sinkIndex; i++)
    {
        string nodeCap;
        is_nodeCap >> nodeCap;
        if (nodeCap == "Inf")
            continue;
        else
        {
            stringstream string2int(nodeCap);
            int capacity;
            string2int >> capacity;
            int pseudoNode = sinkIndex + i;

            for (secondItr = cargoGraph[i].begin(); secondItr != cargoGraph[i].end(); /* secondItr++*/)
            {
                //erase every vertex adjacent with original vertex and connect with pseudo vertex
                cargoGraph[pseudoNode][secondItr->first] = secondItr->second;

                map<int, int>::iterator tempItr = secondItr;
                secondItr++;
                cargoGraph[i].erase(tempItr);
            }
            cargoGraph[i][pseudoNode] = capacity; //create pseudo vertex and connect with capacity edge
            nbOfLocations++;                      //additional location which is added pseudo vertex
        }
    }
    outfile << FordFulkerson_EK(cargoGraph, nbOfLocations, sinkIndex);

    return 0;
}
