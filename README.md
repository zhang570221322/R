# Description
R package For the R Script

# Installation

Installation should take less than 5 min. 

## Via Github and devtools

If you want to install the package directly from Github, I recommend to use the `devtools` package.

```R
library(devtools)
install_github('zhang570221322/R/package_Name')
```


## mMarker

### Usage

```R
library(devtools)
install_github('zhang570221322/R/mMarker')
library(progress)
library(mMarker)
options(stringsAsFactors = FALSE)
data=read.table("findmarker.xls",header=T,sep="\t")
#Single_cell_markers.txt:wget http://biocc.hrbmu.edu.cn/CellMarker/download/Single_cell_markers.txt
marker_Data=read.table("Single_cell_markers.txt",,header=T,sep="\t")
#input data:findmarker.xls ,marker_Data:Single_cell_markers.txt , topn(20):select var gene , freq(10):maker frequency,topfreqn(4):4,isTopfreqn=T
#output Matrix(cluster1,cluster2,.....)
#description isTopfreqn, if isTopfreqn is true,then the  freq of pqrameter is  invalid ,and the  topfreqn of pqrameter is valid.
match_Marker_data=Get_Cluster_Marker_Matrix(data,marker_Data,topn=20,freq=10,topfreqn=4,isTopfreqn=T)
#match_Marker_data=Get_Cluster_Marker_Matrix(data,marker_Data,topn=20,freq=10,topfreqn=4,isTopfreqn=F)
#match_Marker_data=Get_Cluster_Marker_Matrix(data,markerData)
write.table(match_Marker_data,"out_data.xls",sep="\t")
```
### Remove
```R
remove.packages("mMarker")
```


# Contributing guidelines



# Versioned templates



```
None
```




# License

[GPL-3.0](./LICENSE).

# author
wlZhang
