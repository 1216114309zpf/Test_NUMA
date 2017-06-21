#include<iostream>
#include<string>
#include<vector>
#include<algorithm>

using namespace std;

bool compare(char,char);
void swap(char &,char &);

vector<string> result;


int main()
{
    string str;

    cout<<"Please enter a string:"<<endl;
    cin>>str;

    if(str.size()<2){
        cout<<"Only one character,no need to permute"<<endl;
        return 0;
    }

    sort(str.begin(),str.end(),compare);

    result.push_back(str);

    while(true){
       int i=-1,j=0;
       for(int itr=str.size()-1;itr>0;--itr){  //find the first i from end such that str[i]<str[i+1]
          if(str[itr-1] < str[itr]){
             i=itr-1;
             break;
          }
       }

       if(i==-1)    //permuation finish
          break;    

       for(int itr=str.size()-1;itr>i;--itr){
          if(str[itr]>str[i]){
              j=itr;
              break;
          }
       }

       swap(str[i],str[j]);       

       j=str.size()-1;
       ++i;
       while(j>=i){     //reverse i+1 to end
          swap(str[i],str[j]);
          ++i;
          --j;
       }

       result.push_back(str);
       
    }
    int total = result.size();
    cout<<"Total permutation is "<<total<<endl;
    for(int i=0;i<total;++i){
       cout<<result[i]<<endl;
    }
    return 0;
}

bool compare(char a,char b){
   return a<b;
}

void swap(char &a,char &b){
   char tmp=a;
   a=b;
   b=tmp;
} 
