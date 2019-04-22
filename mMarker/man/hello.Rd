\name{Get_Cluster_Marker_Matrix}
\alias{Get_Cluster_Marker_Matrix}
\title{Hello, World!}
\usage{
data=Get_Cluster_Marker_Matrix()
}
\description{
input data:findmarker.xls ,marker_Data:Single_cell_markers.txt , topn(20):select var gene , freq(10):maker frequency,topfreqn(4):4,isTopfreqn=T
output Matrix(cluster1,cluster2,.....)
description isTopfreqn, if isTopfreqn is true,then the  freq of pqrameter is  invalid ,and the  topfreqn of pqrameter is valid.
}
\examples{
data=Get_Cluster_Marker_Matrix(data,markerData)
data2=Get_Cluster_Marker_Matrix(data,marker_Data,topn=20,freq=10,topfreqn=4,isTopfreqn=T)  
data3=Get_Cluster_Marker_Matrix(data,marker_Data,topn=20,freq=10,topfreqn=4,isTopfreqn=F)
}
