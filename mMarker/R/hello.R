# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


#no index
options(stringsAsFactors = FALSE)



#print
My_Print=function(n=1,info){
  if(n==1){
    print(paste("[success]",info,sep=":"))
  }
  if(n==0){
    print(paste("[warning]",info,sep=":"))
  }
  if(n==-1){
    print(paste("[error]",info,sep=":"))
  }
}

#Select_Top_N()
#select top n in every cluster ,
#input  data:frame
#output return a matrix(col:genes,colname:clusters)
Select_Top_N=function(data,topn=20){
  return_Matrix=matrix(NA,20,0)
  clusters=sort(unique(data$cluster))
  for (cluster_Id in clusters){
    return_Matrix=cbind(return_Matrix,(data[data$cluster==cluster_Id,])[1:topn,]$gene)
  }
  colnames(return_Matrix)=clusters

  return_Matrix
}

#Match_Marker()
#input: gene_Name(character) ,marker_Data(frame)
#output:  match_marker_Data
Match_Marker=function(gene_Name,marker_Data){
  #init  data
  marker_Data$match_gene=NA
  marker_Data$frequency=NA
  #init output
  output_Martix=matrix(NA,0,17);
  for (i in 1:dim(marker_Data)[1]) {

    if(stringr::str_detect(marker_Data$cellMarker[i],gene_Name)){
      marker_Data[i,]$match_gene=gene_Name
      marker_Data[i,]$frequency=1
      output_Martix=rbind(output_Martix,marker_Data[i,])
    }
  }
  output_Martix
}


#define object
# setClass("Cluster_Marker",slots=list(cluster_Id="character",gene_Top_N="list",marker_Info="matrix",marker_Info_Frequency="matrix"))

#handle  frequency
Handle_Frequency=function(data,freq=10){
  for(cell_Name in unique(unlist(data$cellName))){

    data[data$cellName==cell_Name,]$frequency=dim(data[data$cellName==cell_Name,])[1]
  }
  #flter > 10
  data=data[as.numeric(data$frequency)>=10,]
  output_Data=matrix(NA,0,6)
  for (cell_Name  in unique(data$cellName)){


    data[data$cellName==cell_Name,][1,]$match_gene=paste(unlist(data[data$cellName==cell_Name,]$match_gene)," ",collapse=",")
    output_Data=rbind(output_Data,data[data$cellName==cell_Name,][1,])
  }

  output_Data
}


#input data:findmarker.xls ,marker_Data:Single_cell_markers.txt , topn(20):select var gene , freq(10):maker frequency
#output Matrix(cluster1,cluster2,.....)
Get_Cluster_Marker_Matrix=function(data,marker_Data,topn=20,freq=10){
  matrix_Top_N=Select_Top_N(data,topn)
  My_Print(1,paste("select matrix_Top_",topn,sep=""))

  output_Martix=matrix(NA,0,17);
  gene_List=list()

  for(col_Index in 1:dim(matrix_Top_N)[2]){
    gene_List=list(gene_List,matrix_Top_N[,col_Index])
  }

  gene_List=list(unique(unlist(gene_List)))
  pb  = progress_bar$new(total = length(unlist(gene_List)))
  for(gene_Name in unlist(gene_List)){
    marker_Info=as.matrix(Match_Marker(gene_Name,marker_Data))
    output_Martix=rbind(output_Martix,marker_Info)
    pb$tick()
    Sys.sleep(1 /length(unlist(gene_List)))

  }
  My_Print(1,"Finish matching marker")

  output_Martix2=matrix(NA,0,6);
  output_Martix=as.data.frame(output_Martix)
  for(col_Index in 1:dim(matrix_Top_N)[2]){
    gene_List2=unlist(matrix_Top_N[,col_Index])
    marker_Info=matrix(NA,0,17);
    for(gene_Name2 in gene_List2){
      foo2= output_Martix[output_Martix$match_gene==gene_Name2,]
      marker_Info=rbind(marker_Info,foo2)
    }
    marker_Info$cluster_Id=colnames(matrix_Top_N)[col_Index]
    #select data
    marker_Info=data.frame(marker_Info$cellName,marker_Info$cluster_Id,marker_Info$match_gene,marker_Info$frequency,marker_Info$CellOntologyID,marker_Info$UberonOntologyID)
    colnames(marker_Info)=c("cellName","cluster_Id","match_gene","frequency","CellOntologyID","UberonOntologyID")
    marker_Info=Handle_Frequency(marker_Info,freq)
    output_Martix2=rbind(output_Martix2,marker_Info)
  }
  colnames(output_Martix2)=c("cellName","cluster_Id","match_gene","frequency","CellOntologyID","UberonOntologyID")

  output_Martix2

}




