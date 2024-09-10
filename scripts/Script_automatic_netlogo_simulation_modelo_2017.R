library('RNetLogo')
library(raster)
library(png)
library(dplyr)
library(rgdal)

Correlacao <- function (alpha_c1, alpha_c2, alpha_c3){
  NLCommand(paste("set alpha_c1", alpha_c1, sep = " "))
  NLCommand(paste("set alpha_c2", alpha_c2, sep = " "))
  NLCommand(paste("set alpha_c3", alpha_c3, sep = " "))
  #NLCommand(paste("set compare-utility-strategy",""class"", sep = " "))
  NLCommand("setup")
  NLDoCommand(50,"go")
  NLCommand("export")
  #NLQuit()
  
  c_simulacao <- read.csv("models/Modelo_2017/Resultados/agents.csv", header = TRUE, sep = ",", dec = ".")
  cc_simulacao <- as.data.frame(with(c_simulacao, table(group, cell.id, dnn = c("cgroup", "ccell.id"))))
  dd_simulacao <- reshape::cast(cc_simulacao, ccell.id ~ cgroup, sum)
  colnames(dd_simulacao) <- c("ID_USAR", "G1_simulacao", "G2_simulacao", "G3_simulacao")
  
  
  c <- read.csv("models/Modelo_2017/Resultados/agents_gabarito.csv", header = TRUE, sep = ",", dec = ".")
  cc <- as.data.frame(with(c, table(group, cell.id, dnn = c("cgroup", "ccell.id"))))
  dd <- reshape::cast(cc, ccell.id ~ cgroup, sum)
  colnames(dd) <- c("ID_USAR", "G1", "G2", "G3")
  
  e <- plyr::join(dd_simulacao, dd, "ID_USAR", type="right")
  e[is.na(e)] <- 0
  
  ww_pearson_g1 <- cor(e$G1_simulacao,e$G1, method = "pearson")
  ww_spearman_g1 <- cor(e$G1_simulacao,e$G1, method = "spearman")
  
  ww_pearson_g2 <- cor(e$G2_simulacao,e$G2, method = "pearson")
  ww_spearman_g2 <- cor(e$G2_simulacao,e$G2, method = "spearman")
  
  ww_pearson_g3 <- cor(e$G3_simulacao,e$G3, method = "pearson")
  ww_spearman_g3 <- cor(e$G3_simulacao,e$G3, method = "spearman")
  
  write.csv(ww_pearson_g1, paste("models/Modelo_2017/Resultados/correlacao_pearson", 1, ".csv", sep = "_"), col.names = FALSE)
  write.csv(ww_pearson_g2, paste("models/Modelo_2017/Resultados/correlacao_pearson", 2, ".csv", sep = "_"), col.names = FALSE)
  write.csv(ww_pearson_g3, paste("models/Modelo_2017/Resultados/correlacao_pearson", 3, ".csv", sep = "_"), col.names = FALSE)
  
  write.csv(ww_spearman_g1, paste("models/Modelo_2017/Resultados/correlacao_spearman", 1, ".csv", sep = "_"), col.names = FALSE)
  write.csv(ww_spearman_g2, paste("models/Modelo_2017/Resultados/correlacao_spearman", 2, ".csv", sep = "_"), col.names = FALSE)
  write.csv(ww_spearman_g3, paste("models/Modelo_2017/Resultados/correlacao_spearman", 3, ".csv", sep = "_"), col.names = FALSE)
  
}

setwd("C:/Program Files/NetLogo 6.0.4/app")

nl.path <- "C:/Program Files/NetLogo 6.0.4/app"
nl.jarname <- 'netlogo-6.0.4.jar'
NLStart(nl.path, nl.jarname = nl.jarname)
model.path <- "/models/Modelo_2017/Modelo_TESE_v1_empregos_exogenos_SP_1km_acessibilidade_aleatorio_densidade_v13_teste_kmeans_v2.nlogo"
NLLoadModel(paste(nl.path, model.path, sep = ""))

x1 <- array(, dim = c(11,1))
x2 <- array(, dim = c(11,1))
x3 <- array(, dim = c(11,1))

s1 <- array(, dim = c(11,11,11))
s2 <- array(, dim = c(11,11,11))
s3 <- array(, dim = c(11,11,11))

v1 <- array(, dim = c(11,11,11))
v2 <- array(, dim = c(11,11,11))
v3 <- array(, dim = c(11,11,11))

#Configura o alpha da simulação

for (ii in (0:10)){
  for (jj in (0:10)){
    for (kk in (0:10)){
      x1[ii+1,1] <- ifelse(ii!=10, paste("0", ii, sep = "."), "1.0") 
      x2[jj+1,1] <- ifelse(jj!=10, paste("0", jj, sep = "."), "1.0")
      x3[kk+1,1] <- ifelse(kk!=10, paste("0", kk, sep = "."), "1.0")
    }
  }
}


for (i in (1:11)){
  for (j in (1:11)){
    for (k in (1:11)){
      print(i)
      print(j)
      print(k)
      Correlacao(x1[i,1], x2[j,1], x3[k,1])
      v1[i,j,k] <- read.csv("models/Modelo_2017/Resultados/correlacao_pearson_1_.csv")[1,2]
      v2[i,j,k] <- read.csv("models/Modelo_2017/Resultados/correlacao_pearson_2_.csv")[1,2]
      v3[i,j,k] <- read.csv("models/Modelo_2017/Resultados/correlacao_pearson_3_.csv")[1,2]
      s1[i,j,k] <- read.csv("models/Modelo_2017/Resultados/correlacao_spearman_1_.csv")[1,2]
      s2[i,j,k] <- read.csv("models/Modelo_2017/Resultados/correlacao_spearman_2_.csv")[1,2]
      s3[i,j,k] <- read.csv("models/Modelo_2017/Resultados/correlacao_spearman_3_.csv")[1,2]
    }
  }
}

