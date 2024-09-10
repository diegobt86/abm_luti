###############################################################################################################
################### Script para verificar relacao entre usos e distancias a infraestruturas ###################
###############################################################################################################

library(data.table)
library(sf)
library(dplyr)
library(mapview)
library(corrplot)
library(tidyverse)
library(glmnet)
library(olsrr)

setwd("G:/Meu Drive/PosDoc/INPE/Projeto_Pos_Doc/Modelo_Netlogo_PosDoc")

grade <- read_sf("rais_final_grade_v09_04_2024_UTM.shp") %>%
  filter(SP == 1) %>%
  dplyr::select(OBJECTI, G1_int, G2_int, G3_int, atacado, educacao, outros, kibs_fire, armaz_ind)

#################### leitura do arquivo de distancias até a infraestrutura mais próxima #######################

distancias <- fread("distancias_finais_variaveis.csv")
distancias <- distancias %>%
  mutate(distancia_centro_5km = if_else(distancia_centro <= 5000, 1, 0),
         distancia_centro_5_10km = if_else(distancia_centro > 5000 & distancia_centro <= 10000, 1, 0),
         distancia_centro_10_15km = if_else(distancia_centro > 10000 & distancia_centro <= 15000, 1, 0),
         distancia_centro_maior_15km = if_else(distancia_centro > 15000, 1, 0),
         
         distancia_rodovias_5km = if_else(distancia_rodovias <= 5000, 1, 0),
         distancia_rodovias_5_10km = if_else(distancia_rodovias > 5000 & distancia_rodovias <= 10000, 1, 0),
         distancia_rodovias_10_15km = if_else(distancia_rodovias > 10000 & distancia_rodovias <= 15000, 1, 0),
         distancia_rodovias_maior_15km = if_else(distancia_rodovias > 15000, 1, 0),
         
         distancia_arteriais_5km = if_else(distancia_arteriais <= 5000, 1, 0),
         distancia_arteriais_5_10km = if_else(distancia_arteriais > 5000 & distancia_arteriais <= 10000, 1, 0),
         distancia_arteriais_10_15km = if_else(distancia_arteriais > 10000 & distancia_arteriais <= 15000, 1, 0),
         distancia_arteriais_maior_15km = if_else(distancia_arteriais > 15000, 1, 0),
         
         distancia_trem_5km = if_else(distancia_trem <= 5000, 1, 0),
         distancia_trem_5_10km = if_else(distancia_trem > 5000 & distancia_trem <= 10000, 1, 0),
         distancia_trem_10_15km = if_else(distancia_trem > 10000 & distancia_trem <= 15000, 1, 0),
         distancia_trem_maior_15km = if_else(distancia_trem > 15000, 1, 0),
         
         distancia_metro_5km = if_else(distancia_metro <= 5000, 1, 0),
         distancia_metro_5_10km = if_else(distancia_metro > 5000 & distancia_metro <= 10000, 1, 0),
         distancia_metro_10_15km = if_else(distancia_metro > 10000 & distancia_metro <= 15000, 1, 0),
         distancia_metro_maior_15km = if_else(distancia_metro > 15000, 1, 0),
         
         distancia_ensino_superior_5km = if_else(distancia_ensino_superior <= 5000, 1, 0),
         distancia_ensino_superior_5_10km = if_else(distancia_ensino_superior > 5000 & distancia_ensino_superior <= 10000, 1, 0),
         distancia_ensino_superior_10_15km = if_else(distancia_ensino_superior > 10000 & distancia_ensino_superior <= 15000, 1, 0),
         distancia_ensino_superior_maior_15km = if_else(distancia_ensino_superior > 15000, 1, 0),
         
         distancia_hospitais_5km = if_else(distancia_hospitais <= 5000, 1, 0),
         distancia_hospitais_5_10km = if_else(distancia_hospitais > 5000 & distancia_hospitais <= 10000, 1, 0),
         distancia_hospitais_10_15km = if_else(distancia_hospitais > 10000 & distancia_hospitais <= 15000, 1, 0),
         distancia_hospitais_maior_15km = if_else(distancia_hospitais > 15000, 1, 0),
         
         distancia_parques_5km = if_else(distancia_parques <= 5000, 1, 0),
         distancia_parques_5_10km = if_else(distancia_parques > 5000 & distancia_parques <= 10000, 1, 0),
         distancia_parques_10_15km = if_else(distancia_parques > 10000 & distancia_parques <= 15000, 1, 0),
         distancia_parques_maior_15km = if_else(distancia_parques > 15000, 1, 0))


grade_distancias <- dplyr::left_join(grade, distancias, by=c("OBJECTI"="from_id"))

grade_distancias <- grade_distancias %>%
  filter(!is.na(distancia_centro)) %>%
  mutate(atacado = atacado / 100,
         educacao = educacao / 100,
         outros = outros / 100,
         kibs_fire = kibs_fire / 100,
         armaz_ind = armaz_ind / 100,
         tot_pop = G1_int + G2_int + G3_int) %>%
  st_drop_geometry()

#atacado <- lm(atacado ~ G1_int + G2_int + G3_int + distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + educacao + kibs_fire + armaz_ind + outros, data = grade_distancias)
atacado <- lm(atacado ~ tot_pop + G1_int + G2_int + G3_int + distancia_centro + distancia_centro_5km + distancia_centro_5_10km + distancia_centro_10_15km + distancia_centro_maior_15km + distancia_ensino_superior + distancia_ensino_superior_5km + distancia_ensino_superior_5_10km +distancia_ensino_superior_10_15km + distancia_ensino_superior_maior_15km + distancia_hospitais + distancia_hospitais_5km + distancia_hospitais_5_10km + distancia_hospitais_10_15km + distancia_hospitais_maior_15km + distancia_parques + distancia_parques_5km + distancia_parques_5_10km + distancia_parques_10_15km + distancia_parques_maior_15km + distancia_rodovias + distancia_rodovias_5km + distancia_rodovias_5_10km + distancia_rodovias_10_15km + distancia_rodovias_maior_15km + distancia_arteriais + distancia_arteriais_5km + distancia_arteriais_5_10km + distancia_arteriais_10_15km + distancia_arteriais_maior_15km + distancia_trem + distancia_trem_5km + distancia_trem_5_10km + distancia_trem_10_15km + distancia_trem_maior_15km + distancia_metro + distancia_metro_5km +distancia_metro_5_10km +distancia_metro_10_15km +distancia_metro_maior_15km, data = grade_distancias)
summary(atacado)
ols_step_forward_p(model = atacado, details = FALSE)

#educacao <- lm(educacao ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + atacado + kibs_fire + armaz_ind + outros, data = grade_distancias)
educacao <- lm(educacao ~ tot_pop + G1_int + G2_int + G3_int + distancia_centro + distancia_centro_5km + distancia_centro_5_10km + distancia_centro_10_15km + distancia_centro_maior_15km + distancia_ensino_superior + distancia_ensino_superior_5km + distancia_ensino_superior_5_10km +distancia_ensino_superior_10_15km + distancia_ensino_superior_maior_15km + distancia_hospitais + distancia_hospitais_5km + distancia_hospitais_5_10km + distancia_hospitais_10_15km + distancia_hospitais_maior_15km + distancia_parques + distancia_parques_5km + distancia_parques_5_10km + distancia_parques_10_15km + distancia_parques_maior_15km + distancia_rodovias + distancia_rodovias_5km + distancia_rodovias_5_10km + distancia_rodovias_10_15km + distancia_rodovias_maior_15km + distancia_arteriais + distancia_arteriais_5km + distancia_arteriais_5_10km + distancia_arteriais_10_15km + distancia_arteriais_maior_15km + distancia_trem + distancia_trem_5km + distancia_trem_5_10km + distancia_trem_10_15km + distancia_trem_maior_15km + distancia_metro + distancia_metro_5km +distancia_metro_5_10km +distancia_metro_10_15km +distancia_metro_maior_15km, data = grade_distancias)
summary(educacao)
ols_step_forward_p(model = educacao, details = FALSE)

#kibs_fire <- lm(kibs_fire ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + atacado + educacao + armaz_ind + outros, data = grade_distancias)
kibs_fire <- lm(kibs_fire ~ tot_pop + G1_int + G2_int + G3_int + distancia_centro + distancia_centro_5km + distancia_centro_5_10km + distancia_centro_10_15km + distancia_centro_maior_15km + distancia_ensino_superior + distancia_ensino_superior_5km + distancia_ensino_superior_5_10km +distancia_ensino_superior_10_15km + distancia_ensino_superior_maior_15km + distancia_hospitais + distancia_hospitais_5km + distancia_hospitais_5_10km + distancia_hospitais_10_15km + distancia_hospitais_maior_15km + distancia_parques + distancia_parques_5km + distancia_parques_5_10km + distancia_parques_10_15km + distancia_parques_maior_15km + distancia_rodovias + distancia_rodovias_5km + distancia_rodovias_5_10km + distancia_rodovias_10_15km + distancia_rodovias_maior_15km + distancia_arteriais + distancia_arteriais_5km + distancia_arteriais_5_10km + distancia_arteriais_10_15km + distancia_arteriais_maior_15km + distancia_trem + distancia_trem_5km + distancia_trem_5_10km + distancia_trem_10_15km + distancia_trem_maior_15km + distancia_metro + distancia_metro_5km +distancia_metro_5_10km +distancia_metro_10_15km +distancia_metro_maior_15km, data = grade_distancias)
summary(kibs_fire)
ols_step_forward_p(model = kibs_fire, details = FALSE)

#armaz_ind <- lm(armaz_ind ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + atacado + educacao + kibs_fire + outros, data = grade_distancias)
armaz_ind <- lm(armaz_ind ~ tot_pop + G1_int + G2_int + G3_int + distancia_centro + distancia_centro_5km + distancia_centro_5_10km + distancia_centro_10_15km + distancia_centro_maior_15km + distancia_ensino_superior + distancia_ensino_superior_5km + distancia_ensino_superior_5_10km +distancia_ensino_superior_10_15km + distancia_ensino_superior_maior_15km + distancia_hospitais + distancia_hospitais_5km + distancia_hospitais_5_10km + distancia_hospitais_10_15km + distancia_hospitais_maior_15km + distancia_parques + distancia_parques_5km + distancia_parques_5_10km + distancia_parques_10_15km + distancia_parques_maior_15km + distancia_rodovias + distancia_rodovias_5km + distancia_rodovias_5_10km + distancia_rodovias_10_15km + distancia_rodovias_maior_15km + distancia_arteriais + distancia_arteriais_5km + distancia_arteriais_5_10km + distancia_arteriais_10_15km + distancia_arteriais_maior_15km + distancia_trem + distancia_trem_5km + distancia_trem_5_10km + distancia_trem_10_15km + distancia_trem_maior_15km + distancia_metro + distancia_metro_5km +distancia_metro_5_10km +distancia_metro_10_15km +distancia_metro_maior_15km, data = grade_distancias)
summary(armaz_ind)
ols_step_forward_p(model = armaz_ind, details = FALSE)

#outros <- lm(outros ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + atacado + educacao + kibs_fire + armaz_ind, data = grade_distancias)
outros <- lm(outros ~ tot_pop + G1_int + G2_int + G3_int + distancia_centro + distancia_centro_5km + distancia_centro_5_10km + distancia_centro_10_15km + distancia_centro_maior_15km + distancia_ensino_superior + distancia_ensino_superior_5km + distancia_ensino_superior_5_10km +distancia_ensino_superior_10_15km + distancia_ensino_superior_maior_15km + distancia_hospitais + distancia_hospitais_5km + distancia_hospitais_5_10km + distancia_hospitais_10_15km + distancia_hospitais_maior_15km + distancia_parques + distancia_parques_5km + distancia_parques_5_10km + distancia_parques_10_15km + distancia_parques_maior_15km + distancia_rodovias + distancia_rodovias_5km + distancia_rodovias_5_10km + distancia_rodovias_10_15km + distancia_rodovias_maior_15km + distancia_arteriais + distancia_arteriais_5km + distancia_arteriais_5_10km + distancia_arteriais_10_15km + distancia_arteriais_maior_15km + distancia_trem + distancia_trem_5km + distancia_trem_5_10km + distancia_trem_10_15km + distancia_trem_maior_15km + distancia_metro + distancia_metro_5km +distancia_metro_5_10km +distancia_metro_10_15km +distancia_metro_maior_15km, data = grade_distancias)
summary(outros)
ols_step_forward_p(model = outros, details = FALSE)


###############################################################################################################################
################################### TESTE DESAGREGANDO OS COMERCIOS E INDUSTRIA/ARMAZENS ######################################
###############################################################################################################################
setwd("G:/Meu Drive/PosDoc/INPE/Projeto_Pos_Doc/Modelo_Netlogo_PosDoc")

grade <- read_sf("teste_grade_completa_17_05_2024.gpkg") %>%
  filter(SP == 1) %>%
  dplyr::select(OBJECTI, G1_int, G2_int, G3_int, armazens, atacado, educacao, fire, industrias, kibs, outros, varejo)

#################### leitura do arquivo de distancias até a infraestrutura mais próxima #######################

distancias <- fread("distancias_finais_variaveis.csv")

grade_distancias <- dplyr::left_join(grade, distancias, by=c("OBJECTI"="from_id"))

grade_distancias <- grade_distancias %>%
  filter(!is.na(distancia_centro)) %>%
  st_drop_geometry()

atacado <- lm(atacado ~ G1_int + G2_int + G3_int + distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + armazens + educacao + fire + industrias + kibs + outros + varejo, data = grade_distancias)
summary(atacado)
ols_step_forward_p(model = atacado, details = FALSE)

varejo <- lm(varejo ~ G1_int + G2_int + G3_int + distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + armazens + educacao + fire + industrias + kibs + outros + atacado, data = grade_distancias)
summary(varejo)
ols_step_forward_p(model = varejo, details = FALSE)


educacao <- lm(educacao ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + armazens + atacado + fire + industrias + kibs + outros + varejo, data = grade_distancias)
summary(educacao)
ols_step_forward_p(model = educacao, details = FALSE)


fire <- lm(fire ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + kibs + outros + varejo + atacado + educacao + armazens + industrias, data = grade_distancias)
summary(fire)
ols_step_forward_p(model = fire, details = FALSE)

kibs <- lm(kibs ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + fire + outros + varejo + atacado + educacao + armazens + industrias, data = grade_distancias)
summary(kibs)
ols_step_forward_p(model = kibs, details = FALSE)


armazens <- lm(armazens ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + atacado + educacao + fire + industrias + kibs + outros + varejo, data = grade_distancias)
summary(armazens)
ols_step_forward_p(model = armazens, details = FALSE)

industrias <- lm(industrias ~ G1_int + G2_int + G3_int +distancia_centro + distancia_ensino_superior + distancia_hospitais + distancia_parques + distancia_rodovias + distancia_arteriais + distancia_trem + distancia_metro + atacado + educacao + fire + armazens + kibs + outros + varejo, data = grade_distancias)
summary(industrias)
ols_step_forward_p(model = industrias, details = FALSE)


############## verificar se incluo empregos de varejo junto com atacadista

########## Analise de cluster ##########

test <- grade_distancias %>%
  dplyr::select(armazens, atacado, educacao, fire, industrias, kibs, outros, varejo)

correl.cor <- cor(test, use = "pairwise.complete.obs")
correl.dist <- as.dist(1 - correl.cor)
correl.tree <- hclust(correl.dist, method = "complete")

plot(correl.tree)

correl.dend <- as.dendrogram(correl.tree)
plot(correl.dend)

clusters <- cutree(correl.tree, k=5)
table(clusters)
plot(color_branches(correl.tree, k=5))


m <- cor(test,method = "pearson")

corrplot(m, method = 'number')
