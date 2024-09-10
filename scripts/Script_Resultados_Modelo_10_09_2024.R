library(png)
library(dplyr)
#library(rgdal)
library(zoo)
library(ineq)
library(ggplot2)
library(sf)
library(raster)

setwd("G:/Meu Drive/PosDoc/INPE/Projeto_Pos_Doc/Modelo_Netlogo_PosDoc") 

#c <- read.csv("Resultados/agents_gabarito.csv", header = TRUE, sep = ",", dec = ".")
#c <- read.csv("Resultados/agents_cenario_atual_09_09_2024.csv", header = TRUE, sep = ",", dec = ".")
c <- read.csv("Resultados/agents_cenario_intervencao_09_09_2024.csv", header = TRUE, sep = ",", dec = ".")

attach(c)

d <- c[order(accessibility),]

d$pessoas <- 1

d$sum_pessoas <- cumsum(d$pessoas)/18515
d$access <- d$accessibility/sum(d$accessibility)
d$sum_access <- cumsum(d$access)

c1 <- d[ which(d$group==1),]
c2 <- d[ which(d$group==2),]
c3 <- d[ which(d$group==3),]

equity <- array(, dim = c(11,2))
equity[,1] <- seq(0, 1, by=0.1)
equity[,2] <- seq(0, 1, by=0.1)
equity <- as.data.frame(equity)

e <- dplyr::select(c, accessibility)
e <- as.matrix(e)



#f <- plyr::join(d, dd, by="id", type="left", match="all")

cc <- read.csv("Resultados/agents_cenario_intervencao_09_09_2024.csv", header = TRUE, sep = "," ,dec = ".")
#cc <- read.csv("Resultados/agents_cenario_atual_09_09_2024.csv", header = TRUE, sep = "," ,dec = ".")
#cc <- read.csv("Resultados/agents_gabarito.csv", header = TRUE, sep = "," ,dec = ".")
attach(cc)

dd <- cc[order(accessibility),]

dd$pessoas <- 1

dd$sum_pessoas <- cumsum(dd$pessoas)/18515
dd$access <- dd$accessibility/sum(dd$accessibility)
dd$sum_access <- cumsum(dd$access)

c1_2 <- dd[ which(dd$group==1),]
c2_2 <- dd[ which(dd$group==2),]
c3_2 <- dd[ which(dd$group==3),]

colnames(dd) <- c("id", "cell.id_2", "coord.x_2", "coord.y_2", "group_2", "accessibility_2", "utility_2", "cell.status_2", "pessoas_2", "sum_pessoas_2", "access_2", "sum_access_2")

ggplot(data=d)+ 
  geom_line(aes(x=sum_pessoas, y=sum_access, colour="4"), data = d)+
  geom_line(aes(x=sum_pessoas_2, y=sum_access_2, colour="4"), data = dd)+
  geom_line(aes(x=V1, y=V2, colour="5"), linetype=2, data = equity)+
  geom_point(data=c1, aes(x=median(sum_pessoas), y=median(sum_access), colour="1"), size=6)+
  geom_point(data=c2, aes(x=median(sum_pessoas), y=median(sum_access), colour="2"), size=6)+
  geom_point(data=c3, aes(x=median(sum_pessoas), y=median(sum_access), colour="3"), size=6)+
  geom_point(data=c1_2, aes(x=median(sum_pessoas), y=median(sum_access), colour="1"), size=6)+
  geom_point(data=c2_2, aes(x=median(sum_pessoas), y=median(sum_access), colour="2"), size=6)+
  geom_point(data=c3_2, aes(x=median(sum_pessoas), y=median(sum_access), colour="3"), size=6)+
  scale_x_continuous(name = "People")+
  scale_y_continuous(name = "Accessibility")+
  labs(title = "Lorenz curve")+
  scale_color_manual(name="Legend",
                     labels=c("Median Group 1",
                              "Median Group 2",
                              "Median Group 3",
                              "Lorenz curve",
                              "Equity line"),
                     values = c("1" = "#60A3B5",
                                "2" = "#FCCF51",
                                "3" = "#F24D1F",
                                "4" = "black",
                                "5" = "black"),
                     guide = guide_legend(override.aes = list(
                       linetype=c(rep("blank", 3),"solid","dashed"),
                       shape = c(rep(16,3), NA, NA)))) +
  theme_bw()+
  theme(legend.position = "none")


ineq(e, type = "Gini")

f <- c


f$Group <- as.character(f$group)
#f$group <- paste(f$group, "_2", sep = "")

f$Accessibility <- f$accessibility


p <- ggplot(data=f, mapping= aes(x=Group, y=Accessibility, fill=Group))+
  theme(axis.title.y = element_blank(), axis.title.x = element_blank(), axis.text.x =element_blank(), axis.ticks.x = element_blank())+
  scale_fill_manual("Working group", labels=c("High", "Middle", "Low"), values = c("#60A3B5", "#FCCF51", "#F24D1F"))



p + geom_boxplot() + scale_y_continuous(limits = c(0, 1)) + theme_bw() + theme(legend.position = "bottom")

######################################################################################
######################################################################################
#######################################################################################

#setwd("C:/Users/Diego/OneDrive/Projetos/Artigo_GEOINFO/Modelo")

#c <- read.csv("Resultados/agents_gabarito.csv", header = TRUE, sep = ",", dec = ".")
#c <- read.csv("Resultados/agents_cenario_atual_09_09_2024.csv", header = TRUE, sep = ",", dec = ".")
c <- read.csv("Resultados/agents_cenario_intervencao_09_09_2024.csv", header = TRUE, sep = ",", dec = ".")

c$Totg1 <- ifelse (c$group==1,1,0)
c$Totg2 <- ifelse (c$group==2,1,0)
c$Totg3 <- ifelse (c$group==3,1,0)

c$totrelg1 <- ifelse(c$Totg1!=0, c$Totg1/sum(c$Totg1), 0)
c$totrelg2 <- ifelse(c$Totg2!=0, c$Totg2/sum(c$Totg2), 0)
c$totrelg3 <- ifelse(c$Totg3!=0, c$Totg3/sum(c$Totg3), 0)

c <- within(c, Concatenado <- paste (cell.id, group, sep = "-"))
cc <- dplyr::count(c, vars=Concatenado)
ccc <- stringr::str_split_fixed(cc$vars, "-", 2)
ccc <- as.data.frame(ccc)


cccc <- cbind(cc,ccc)

cccc <- dplyr::select(cccc, V1, V2, n)

ccccc <- reshape::cast(cccc, V1 ~ V2)
ccccc[is.na(ccccc)] <- 0

##### Fator para OD 2007
#ccccc$relg1 <- ccccc$`1`*0.0007733952
#ccccc$relg2 <- ccccc$`2`*0.0002103934
#ccccc$relg3 <- ccccc$`3`*0.0001085776


##### Fator para OD 2017
ccccc$relg1 <- ccccc$`1`/(sum(ccccc$'1'))
ccccc$relg2 <- ccccc$`2`/(sum(ccccc$'2'))
ccccc$relg3 <- ccccc$`3`/(sum(ccccc$'3'))

# ccccc$relg1 <- ccccc$`1`*8.56
# ccccc$relg2 <- ccccc$`2`*4.45
# ccccc$relg3 <- ccccc$`3`*1

ccccc$grupo <- ifelse(ccccc$relg1>ccccc$relg2 & ccccc$relg1>ccccc$relg3,1,"")
ccccc$grupo <- ifelse(ccccc$relg2>ccccc$relg1 & ccccc$relg2>ccccc$relg3,2,ccccc$grupo)
ccccc$grupo <- ifelse(ccccc$relg3>ccccc$relg1 & ccccc$relg3>ccccc$relg2,3,ccccc$grupo)

cc1 <- dplyr::select(ccccc, V1, grupo)

colnames(cc1) <- c("FID_Grid_1", "c1")
cc1$c1 <- as.numeric(as.character(cc1$c1))
cc1$FID_Grid_1 <- as.numeric(as.character(cc1$FID_Grid_1))


#################################################################
#shape <- readOGR(dsn = "Grid_1km_SP.shp", layer = "Grid_1km_SP")
shape <- read_sf("rais_final_grade_v09_04_2024_UTM.shp")

e <- shape$OBJECTI
e <- as.data.frame(e)
colnames(e) <- c("OBJECTI")
cc1 <- cc1 %>%
  rename("OBJECTI" = FID_Grid_1)
f <- plyr::join(e, cc1, by="OBJECTI", type="left", match="all")
#g <- plyr::join(f, dd1, by="FID_Grid_1", type="left", match="all")
#g[is.na(g)] <- 0
f[is.na(f)] <- 0

#combine <- merge (shape, g, by='FID_Grid_1')
combine <- merge (shape, f, by='OBJECTI')

br <- "+init=epsg:32723"

work.area.x <- c(310000, 370000)
work.area.y <- c(7340000, 7417000)

work.area.raster <- raster(nrow=77, 
                           ncol=60, 
                           xmn=work.area.x[1],
                           xmx=work.area.x[2], 
                           ymn=work.area.y[1], 
                           ymx=work.area.y[2], 
                           crs=br)


s <- rasterize(combine, work.area.raster, "c1")
#png(FigGabarito)


plot((s), col=c("grey", "#60A3B5", "#FCCF51", "#F24D1F"))

