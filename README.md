#R
##Description
R package

## Installation

Installation should take less than 5 min. 

### Via Github and devtools

If you want to install the package directly from Github, I recommend to use the `devtools` package.

```R
library(devtools)
install_github('zhang570221322/R/package')
```

---
###mMarker

```R
library(devtools)
install_github('zhang570221322/R/mMarker')
library(progress)
library(string)
#input data(data.frame):findmarker.xls ,marker_Data(data.frame):Single_cell_markers.txt , topn(20):select var gene , freq(10):maker frequency
#output Matrix(cluster1,cluster2,.....)
match_Marker_data=Get_Cluster_Marker_Matrix(data,markerData,topn=10,freq=10)
```

---

## Contributing guidelines



## Versioned templates



```
None
```

## Contributing workflow


## License

[GPL-3.0](./LICENSE).
