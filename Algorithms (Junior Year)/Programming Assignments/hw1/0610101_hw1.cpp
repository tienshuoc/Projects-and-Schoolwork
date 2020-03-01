#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

using namespace std;

struct treeNode
{
    int leftKey, rightKey, key;
    bool vowel;
    int skewChainlen;

    treeNode() : vowel(false), leftKey(0), rightKey(0), skewChainlen(0){};
    int updateSkewChain(vector<treeNode> &nodeArray);
    vector<int> traversePath(vector<treeNode> &nodeArray);
};
int treeNode::updateSkewChain(vector<treeNode> &nodeArray) //update the node's skew chain length, returns chain length of that node
{
    int leftChainLength, rightChainLength;
    int leftIndex = this->leftKey;
    int rightIndex = this->rightKey;
    int chainLength;

    if (this->vowel)
    {
        leftChainLength = nodeArray[leftIndex].skewChainlen;
        rightChainLength = nodeArray[rightIndex].skewChainlen;
        if (leftChainLength >= rightChainLength)
            this->skewChainlen = leftChainLength + 1;
        else
            this->skewChainlen = rightChainLength + 1;
        return (leftChainLength + rightChainLength + 1);
    }
    else
    {
        this->skewChainlen = 0;
        return 0;
    }
}
vector<int> treeNode::traversePath(vector<treeNode> &nodeArray) //returns skewed path of node
{
    vector<int> path;
    treeNode *nodePtr = this;
    while (true)
    {
        path.push_back(nodePtr->key);
        int leftIndex = nodePtr->leftKey;
        int rightIndex = nodePtr->rightKey;
        if ((leftIndex == 0 && rightIndex == 0) || (nodeArray[leftIndex].skewChainlen == 0 && nodeArray[rightIndex].skewChainlen == 0))
            break;
        else if (nodeArray[leftIndex].skewChainlen >= nodeArray[rightIndex].skewChainlen)
        {
            *nodePtr = nodeArray[leftIndex];
        }
        else
            *nodePtr = nodeArray[rightIndex];
    }
    return path;
}

bool isVowel(char alphabet)
{
    if ((alphabet == 'a') || (alphabet == 'e') || (alphabet == 'i') || (alphabet == 'o') || (alphabet == 'u'))
        return true;
    else
        return false;
}

int main(int argc, char **argv)
{

    ifstream infile;
    ofstream outfile;
    infile.open(argv[1]);
    outfile.open(argv[2]);
    int nbOfNodes, outMode;
    string inString;
    string input;

    infile >> nbOfNodes;
    infile >> outMode;

    vector<treeNode> nodeArray;
    nodeArray.resize(nbOfNodes + 1);
    int counter = 1;
    int nodeArrayindex = 1; //allow additional slot to match index

    while (infile >> inString)
    {
        stringstream strin2int(inString); //helps convert string to int
        switch (counter)
        {
        case 1:
            strin2int >> nodeArray[nodeArrayindex].key;
            counter++;
            break;
        case 2:
            nodeArray[nodeArrayindex].vowel = isVowel(inString[0]);
            counter++;
            break;
        case 3:
            strin2int >> nodeArray[nodeArrayindex].leftKey;
            counter++;
            break;
        case 4:
            strin2int >> nodeArray[nodeArrayindex].rightKey;
            counter = 1;
            nodeArrayindex++;
            break;
        }
    }
    int maxLenChain = 0; //remember to minus one to match edges
    int maxLenNode = 0;  //node index of longest chain's root
    for (int i = 1; i < nodeArray.size(); i++)
    {
        int currLen = nodeArray[i].updateSkewChain(nodeArray);
        if (maxLenChain < currLen) //update maxlength if longer chain is found
        {
            maxLenChain = currLen;
            maxLenNode = i;
        }
    }

    //find and print path of longest chain
    int leftIndex = nodeArray[maxLenNode].leftKey;
    int rightIndex = nodeArray[maxLenNode].rightKey;

    if (outMode == 0)
    {
        outfile << maxLenChain - 1 << endl; //minus one to equal nb of edges traversed
        return 0;
    }
    if (outMode == 1)
    {
        vector<int> leftPath, rightPath, totalPath;
        if (leftIndex != 0)
            leftPath = nodeArray[leftIndex].traversePath(nodeArray);
        if (rightIndex != 0)
            rightPath = nodeArray[rightIndex].traversePath(nodeArray);

        totalPath.reserve(leftPath.size() + rightPath.size() + 1);
        totalPath.insert(totalPath.end(), leftPath.rbegin(), leftPath.rend()); //reverse leftpath before appending
        totalPath.push_back(maxLenNode);
        totalPath.insert(totalPath.end(), rightPath.begin(), rightPath.end());

        outfile << maxLenChain - 1 << endl
                << endl;

        if (totalPath[0] <= totalPath[totalPath.size() - 1])
            for (int i = 0; i < totalPath.size(); i++)

                outfile << totalPath[i] << endl;
        else
            for (int i = totalPath.size() - 1; i >= 0; i--)
                outfile << totalPath[i] << endl;
    }
}
