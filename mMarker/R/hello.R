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
Select_Top_N=function(data,topn){
  return_Matrix=matrix(NA,topn,0)
  clusters=sort(unique(data$cluster))
  for (cluster_Id in clusters){
    return_Matrix=cbind(return_Matrix,(data[data$cluster==cluster_Id,])[1:topn,]$gene)
  }
  colnames(return_Matrix)=clusters

  return_Matrix
}

#List_Logic_And()
#input list(T,F,....)
#process &
#return T or F
List_Logic_And=function(list){
  return_Logic_Value=F
  for(logic_Value in list){
      if(!return_Logic_Value){
      return_Logic_Value=return_Logic_Value||logic_Value
      }else{
        break
      }
   }
  return_Logic_Value
  
}


#Match_Marker() 
#input: gene_Name(character) ,marker_Data(frame)
#output:  match_marker_Data
Match_Marker=function(gene_Name,marker_Data){
  #init  data
  marker_Data$match_gene=NA
  marker_Data$frequency=NA
  #init output
  output_Martix=matrix(NA,0,18);
  for (i in 1:dim(marker_Data)[1]) {
  list=gsub(" ","",unlist(strsplit(marker_Data$cellMarker[i],",")))%in%gene_Name
  if(List_Logic_And(list)){
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
Handle_Frequency=function(data,freq,topfreqn,isTopfreqn){
  #count times
  for(Id in unique(unlist(data$Id))){
    data[data$Id==Id,]$frequency=dim(data[data$Id==Id,])[1]
  }
  #flter > freq
  if(!isTopfreqn){
  data=data[as.numeric(data$frequency)>=as.numeric(freq),]
  }
  output_Data=matrix(NA,0,11)
  for (Id  in unique(data$Id)){
    data[data$Id==Id,][1,]$match_gene=paste(unlist(data[data$Id==Id,]$match_gene)," ",collapse=",")
    output_Data=rbind(output_Data,data[data$Id==Id,][1,])
  }
   output_Data=as.data.frame(output_Data)
   output_Data=output_Data[output_Data$speciesType=="Human",]
  
   output_Data=data.frame(output_Data$tissueType,output_Data$PMID,output_Data$cellName,output_Data$cluster_Id,output_Data$match_gene,output_Data$frequency,output_Data$CellOntologyID,output_Data$UberonOntologyID)
    if(as.numeric(dim(output_Data))[1]==0){
    	output_Data=matrix(NA,0,8)
    	output_Data=as.data.frame(output_Data)
   		output_Data[1,]=NA
   }
   colnames(output_Data)=c("tissueType","PMID","cellName","cluster_Id","match_gene","frequency","CellOntologyID","UberonOntologyID")
   if(isTopfreqn){
    output_Data$frequency=as.numeric(output_Data$frequency)
    output_Data=output_Data[order(output_Data[,6],decreasing=T),]
    output_Data=output_Data[1:as.numeric(topfreqn),]
   }
    # output_Data=output_Data[!(is.na(output_Data$cellName=="NA")),]
  output_Data
}


#input data:findmarker.xls ,marker_Data:Single_cell_markers.txt , topn(20):select var gene , freq(10):maker frequency,topfreqn(4):4,isTopfreqn=T
#output Matrix(cluster1,cluster2,.....)
#description isTopfreqn, if isTopfreqn is true,then the  freq of pqrameter is  invalid ,and the  topfreqn of pqrameter is valid.
Get_Cluster_Marker_Matrix=function(data,marker_Data,topn=20,freq=10,topfreqn=4,isTopfreqn=T){
  matrix_Top_N=Select_Top_N(data,topn=topn)
  My_Print(1,paste("select matrix_Top_",topn,sep=""))
  marker_Data$Id=c(1:dim(marker_Data)[1])
  output_Martix=matrix(NA,0,18);
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
    marker_Info=matrix(NA,0,18);
    for(gene_Name2 in gene_List2){
      foo2= output_Martix[output_Martix$match_gene==gene_Name2,]
      marker_Info=rbind(marker_Info,foo2)
    }
    marker_Info$cluster_Id=colnames(matrix_Top_N)[col_Index]
    #select data
    marker_Info=data.frame(marker_Info$Id,marker_Info$speciesType,marker_Info$tissueType,marker_Info$cellType,marker_Info$PMID,marker_Info$cellName,marker_Info$cluster_Id,marker_Info$match_gene,marker_Info$frequency,marker_Info$CellOntologyID,marker_Info$UberonOntologyID)
    colnames(marker_Info)=c("Id","speciesType","tissueType","cellType","PMID","cellName","cluster_Id","match_gene","frequency","CellOntologyID","UberonOntologyID")
    marker_Info=Handle_Frequency(marker_Info,freq,topfreqn,isTopfreqn)
    output_Martix2=rbind(output_Martix2,marker_Info)
  }
  colnames(output_Martix2)=c("tissueType","PMID","cellName","cluster_Id","match_gene","frequency","CellOntologyID","UberonOntologyID")

  output_Martix2

}





