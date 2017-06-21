#include<iostream>
#include<string>
#include<vector>

using namespace std;
vector<string> result;

void PermuteWorker(string current,int count);

int main()
{
    string str;
    cout<<"Please enter a string:"<<endl;
    cin>>str;
    PermuteWorker(str,0);
    int total = result.size();
    cout<<"Total permutation is "<<total<<endl;
    for(int i=0;i<total;++i){
       cout<<result[i]<<endl;
    }
    return 0;
}


void PermuteWorker(string current,int count)
{
    if(current.size() == count){
       result.push_back(current);
       return;
    }
    else{
       for(int i=count;i<current.size();++i){
           char tmp = current[count];
           current[count] = current[i];
           current[i] = tmp;
           PermuteWorker(current,count+1);
       }
    }
    return;
}
