library(sf)
library(dplyr)
library(aopdata)
library(mapview)
library(data.table)


setwd("G:/Meu Drive/PosDoc/INPE/Dados")


quadras <- st_read(dsn = "banco_modelo.gpkg", layer = "intersecao_quadras_grade")

quadras_sum <- quadras %>%
  group_by(OBJECTID) %>%
  summarise(H01 = sum(H01),
            H01A = sum(H01A),
            H01B = sum(H01B),
            H01M = sum(H01M),
            H02C = sum(H02C),
            H02D = sum(H02D),
            H02M = sum(H02M),
            H03 = sum(H03),
            H03M = sum(H03M),
            H04C = sum(H04C),
            H04D = sum(H04D),
            H05 = sum(H05),
            H06 = sum(H06),
            H07 = sum(H07),
            H08 = sum(H08),
            H09 = sum(H09),
            H10 = sum(H10),
            H11 = sum(H11),
            H12 = sum(H12),
            H13 = sum(H13),
            H14A = sum(H14A),
            H14B = sum(H14B),
            H15 = sum(H15),
            H15R = sum(H15R),
            H99 = sum(H99)) %>%
  st_drop_geometry()

quadras_sum_v2 <- quadras_sum %>%
  group_by(OBJECTID) %>%
  summarise(Residencial = sum(H01) + sum(H01A) + sum(H01B) + sum(H01M) + sum(H02C) + sum(H02D) + sum(H02D) + sum(H02M) + sum(H03) + sum(H03M) + sum(H04C) + sum(H04D) + sum(H05) + sum(H14A) + sum(H14B) + sum(H15R),
            Comercial = sum(H06) + sum(H07),
            Industrial = sum(H08) + sum(H09))


grade <- read_sf("../Modelo_Netlogo_PosDoc/grid_1000m_v4.shp")

grade_dados <- dplyr::left_join(grade, quadras_sum_v2, by="OBJECTID")

grade_dados[is.na(grade_dados)] <- 0

write_sf(grade_dados, "grade_1000m.shp")


