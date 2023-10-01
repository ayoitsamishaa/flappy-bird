#include <bits/stdc++.h>
using namespace std;

int main(){

    int n;
    cin>>n;
    string gene;
    cin>>gene;

    // int size= gene.size()/4;
    // int a=0, c=0, t=0, g=0, cnt=0;

    // for (int i=0; i<gene.size(); i++){
    //     if (gene[i]=='A'){
    //         a++;
    //     }
    //     if (gene[i]=='C'){
    //         c++;
    //     }
    //     if (gene[i]=='T'){
    //         t++;
    //     }
    //     if (gene[i]=='G'){
    //         g++;
    //     }
    // }

    //     if (a<size){
    //         cnt = cnt + (size-a);
    //     }else cnt++;

    //     if (c<size){
    //         cnt = cnt + (size-c);
    //     }else cnt++;

    //     if (t<size){
    //         cnt = cnt + (size-t);
    //     }else cnt++;

    //     if (g<size){
    //         cnt = cnt + (size-g);
    //     } else cnt++;

    // cout<<cnt<<endl;


    // int n = gene.size();
    int k = n/4, x=0; 
    vector<int> hsh(128,0);
    for(auto i:gene) hsh[i]++;
    for(int &i:hsh)
    {
        i = max(0,i-k);
        x += i;
    }
    int l = 0,r = 0,cnt = 0,mini = 1e9;
    while(r < n)
    {
        if(hsh[gene[r++]]-->0)x--;
        while(x==0)
        {
            mini = min(mini,r-l);

            if(++hsh[gene[l++]]>0){
                x++;
            }
        }
    }
    cout<<mini<<endl;

    return 0;
}