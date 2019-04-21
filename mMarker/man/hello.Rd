\name{Get_Cluster_Marker_Matrix}
\alias{Get_Cluster_Marker_Matrix}
\title{Hello, World!}
\usage{
data=Get_Cluster_Marker_Matrix()
}
\description{
input data(data.frame):findmarker.xls ,marker_Data(data.frame):Single_cell_markers.txt , topn(20):select var gene , freq(10):maker frequency
output Matrix(cluster1,cluster2,.....)
}
\examples{
data=Get_Cluster_Marker_Matrix(data,markerData)
data2=Get_Cluster_Marker_Matrix(data,markerData,topn=10,freq=10)
}
