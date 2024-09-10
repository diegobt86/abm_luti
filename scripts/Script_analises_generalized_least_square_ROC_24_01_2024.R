###############################################################################################################
####### Script para calcular regressões de variaveis de localzação de Estabelecimentos em São Paulo ###########
###############################################################################################################

library(data.table)
library(sf)
library(dplyr)
library(mapview)
library(reshape2)
library(reshape)
library(corrplot)
library(tidyverse)
library(dendextend)
library(pROC)
library(nlme)
library(car)
library(caret)

setwd("G:/Meu Drive/PosDoc/INPE/Projeto_Pos_Doc/Modelo_Netlogo_PosDoc")

grade <- read_sf("rais_final_grade_v08_11_2023_UTM.shp") %>%
  filter(atacado > 0 | educacao > 0 | outros > 0 | kibs_fire > 0 | armaz_ind > 0) %>%
  select(OBJECTI,atacado, educacao, outros, kibs_fire, armaz_ind, G1_int, G2_int, G3_int, ACC_CUM_PT, ACC_CUM_PR, Rodovia, Trem, TRUNK, trnst_1)

distancias <- fread("Resultados/analise_04_09_2023.csv")

rais_final_grade_distancias <- dplyr::left_join(grade, distancias, by=c("OBJECTI" = "id")) 

rais_final_grade_distancias <- rais_final_grade_distancias %>%
  filter(sp == 1) %>%
  st_drop_geometry() %>%
  dplyr::select(-c(sp,OBJECTI))

#test <- rais_final_grade_distancias[,-c(2,29)]
test <- rais_final_grade_distancias[,-c(2)]
test <- test %>%
mutate(dist_road_1km = if_else(dist_road <= 1, 1,0),
       dist_road_1km_5km = if_else(dist_road > 1 & dist_road <= 5, 1,0),
       dist_road_5km_10km = if_else(dist_road > 5 & dist_road <= 10, 1,0),
       #dist_road_mais_10km = if_else(dist_road > 10, 1,0),
       dist_transit_1km = if_else(dist_transit <= 1, 1,0),
       dist_transit_1km_5km = if_else(dist_transit > 1 & dist_transit <= 5, 1,0),
       dist_transit_5km_10km = if_else(dist_transit > 5 & dist_transit <= 10, 1,0),
       #dist_transit_mais_10km = if_else(dist_transit > 10, 1,0),
       dist_trunk_1km = if_else(dist_trunk <= 1, 1,0),
       dist_trunk_1km_5km = if_else(dist_trunk > 1 & dist_trunk <= 5, 1,0),
       dist_trunk_5km_10km = if_else(dist_trunk > 5 & dist_trunk <= 10, 1,0),
       #dist_trunk_mais_10km = if_else(dist_trunk > 10, 1,0),
       dist_cbd_1km = if_else(dist_cbd <= 1, 1,0),
       dist_cbd_1km_5km = if_else(dist_cbd > 1 & dist_cbd <= 5, 1,0),
       dist_cbd_5km_10km = if_else(dist_cbd > 5 & dist_cbd <= 10, 1,0),
       #dist_cbd_mais_10km = if_else(dist_cbd > 10, 1,0),
       dist_railway_1km = if_else(dist_railway <= 1, 1,0),
       dist_railway_1km_5km = if_else(dist_railway > 1 & dist_railway <= 5, 1,0),
       dist_railway_5km_10km = if_else(dist_railway > 5 & dist_railway <= 10, 1,0))
       #dist_railway_mais_10km = if_else(dist_railway > 10, 1,0))

################## Modelo de regressão linear ########################

mod.ols <- lm(total_empregos_ensino ~ ACC_CUM_PT + G1_int + outros, data = test)
mod.ols <- lm(total_empregos_industrias ~ ., data = test)
summary(mod.ols)


teste_predicao = function(mod, data){
  probs = predict(mod, newdata = data, type = "response")
}

test_pred <- teste_predicao(mod.ols, data = test)
test_ref <- as.vector(test$total_empregos_ensino)

test_roc = roc(test_ref ~ test_pred, plot = TRUE, print.auc = TRUE)

###########

############################# Generalized Least Square ###########################

mod.gls <- gls(total_empregos_ensino ~ ACC_CUM_PT + G1_int + outros, data = test)
mod.gls <- gls(total_empregos_industrias ~ ., data = test)
mod.gls <- gls(total_empregos_industrias ~ densidade_empregos_atacadista + dist_cbd, data = test)
summary(mod.gls)

teste_predicao = function(mod, data){
  probs = predict(mod, newdata = data, type = "response")
}


test_pred <- teste_predicao(mod.gls, data = test)
test_ref <- as.vector(test$total_empregos_ensino)

test_roc = roc(test_ref ~ test_pred, plot = TRUE, print.auc = TRUE)



