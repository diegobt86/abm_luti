###############################################################################################################
############## Script para espacializar a RAIS de Estabelecimentos em São Paulo através do CEP ################
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

# analise_cor_grade <- cor(rais_final_grade_distancias, method = "spearman")
# 
# corrplot(analise_cor_grade,addCoef.col = "red")
# 
# model <- lm(total_empregos_ensino ~., data = rais_final_grade_distancias)
# summary(model)
# 
# library(glmnet)
# 
# set.seed(123)
# model2_educacao <- cv.glmnet(as.matrix(rais_final_grade_distancias[,-c(2,23,29)]), y=rais_final_grade_distancias$educacao,alpha= 0.5, lambda = 10^seq(4,-1,-0.1))
# best_lambda = model2_educacao$lambda.min
# en_coeff = predict(model2_educacao, s=best_lambda, type = "coefficients")
# en_coeff


library(nlme)
library(car)

#mod.ols <- lm(total_empregos_ensino ~ dist_road + dist_railway + dist_cbd + dist_trunk + dist_transit, data = rais_final_grade_distancias)
#mod.ols <- lm(total_empregos_ensino ~ dist_road + dist_cbd + dist_transit + total_trabalhadores + G1_int + G2_int + G3_int, data = rais_final_grade_distancias)

test <- rais_final_grade_distancias[,-c(2,29)]

mod.ols <- lm(total_empregos_ensino ~ densidade_empregos_comercio_outros, data = test)
summary(mod.ols)

#acf(residuals(mod.ols), type = "partial")
#durbinWatsonTest(mod.ols, amx.lag = 5)


plot(total_empregos_ensino ~ densidade_empregos_comercio_outros, data = test, col = "red")
abline(mod.ols, lwd = 3, col = "dodgerblue")

teste_predicao = function(mod, data){
  probs = predict(mod, newdata = data, type = "response")
}


test_pred <- teste_predicao(mod.ols, data = test)
test_ref <- as.vector(test$total_empregos_ensino)

#test_tab = table(predicted = test_pred, actual = test$total_empregos_ensino)

# library(caret)
# 
#test_ref <- as.vector(test$total_empregos_ensino)
# 
#test_ref <- as.vector(as.integer(test_ref))
#test_pred <- as.vector(as.integer(test_pred))
# 
# 
# test_ref <- as.factor(test_ref)
# test_pred <- as.factor(test_pred)
# 
# test_con_mat = confusionMatrix(test_pred, test_ref, positive = NULL)


# metrics = rbind(c(test_con_mat$overall["Accuracy"],
#                   test_con_mat$byClass["Sensitivity"],
#                   test_con_mat$byClass["Specificity"]))



library(pROC)

test_roc = roc(test_ref ~ test_pred, plot = TRUE, print.auc = TRUE)


############################# Generalized Least Square ###########################


mod.gls <- gls(total_empregos_ensino ~ G1_int + G2_int + ACC_CUM_PT + densidade_empregos_industria + densidade_empregos_comercio_outros, data = test)
summary(mod.gls)


#plot(total_empregos_ensino ~ densidade_empregos_comercio_outros, data = test, col = "red")
#abline(mod.gls, lwd = 3, col = "dodgerblue")

teste_predicao = function(mod, data){
  probs = predict(mod, newdata = data, type = "response")
}


test_pred <- teste_predicao(mod.gls, data = test)
test_ref <- as.vector(test$total_empregos_ensino)

library(pROC)

test_roc = roc(test_ref ~ test_pred, plot = TRUE, print.auc = TRUE)
