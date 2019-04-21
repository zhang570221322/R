# Description
R package

# Installation

Installation should take less than 5 min. 

## Via Github and devtools

If you want to install the package directly from Github, I recommend to use the `devtools` package.

```R
library(devtools)
install_github('zhang570221322/R/package_Name')
```


## mMarker

```R
library(devtools)
install_github('zhang570221322/R/mMarker')
library(progress)
options(stringsAsFactors = FALSE)
data=read.table("findmarker.xls",header=T,sep="\t")
#Single_cell_markers.txt:wget http://biocc.hrbmu.edu.cn/CellMarker/download/Single_cell_markers.txt
marker_Data=read.table("Single_cell_markers.txt",,header=T,sep="\t")
#input data(data.frame):findmarker.xls ,marker_Data(data.frame):Single_cell_markers.txt , topn(20):select var gene , freq(10):maker frequency
#output Matrix(cluster1,cluster2,.....)
match_Marker_data=Get_Cluster_Marker_Matrix(data,marker_Data,topn=10,freq=10)
write.table(match_Marker_data,"out_data.xls",sep="\t")
```



# Contributing guidelines



# Versioned templates



```
None
```




# License

[GPL-3.0](./LICENSE).
