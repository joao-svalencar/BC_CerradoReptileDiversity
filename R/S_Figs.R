
# figure endemics ---------------------------------------------------------
table(list_cerrado$order)
table(list_cerrado$cerrado_endemic, list_cerrado$order)

library(ggplot2)
library(cowplot)

###########################################################################
# Fig. 1 - Endemism levels ------------------------------------------------
head(sppRich)
sppRich$suborder <- factor(sppRich$suborder, levels=c("Amphisbaenia", "Sauria", "Serpentes"))
sppRich$year <- factor(sppRich$year)

sppRich$labNe <- c(NA,NA,"Ne=18", "Ne=23", NA,NA,"Ne=33", "Ne=44", NA,NA,"Ne=48", "Ne=60")
sppRich$labN <- c(NA,NA,"N=30", "N=43", NA,NA,"N=74", "N=125", NA,NA,"N=158", "N=245")
sppRich$lab <- c(NA,NA,(18/(30)),(23/(43)),NA,NA,(33/(74)),(44/(125)), NA,NA,(48/(158)),(60/(245)))
sppRich$lab <- round(sppRich$lab*100, digits=2)
sppRich$lab_perc <- sprintf("%0.2f%%", sppRich$lab)
sppRich$lab_pos <- c(NA, NA, 0.38, 0.35, NA, NA, 0.31, 0.26, NA, NA, 0.23, 0.20)

colors.book <- c("#426635", "#67984C")

fig1 <- ggplot2::ggplot(data=sppRich, aes(x=year, y=richness, fill=type))+
  geom_bar(stat="identity", position=position_fill(reverse = TRUE), width = .7)+
  facet_grid(~suborder)+
  geom_text(aes(y=lab_pos, label=lab_perc), vjust=1.6, 
            color="white", size=3)+
  geom_text(aes(y=0.80, label=labNe), vjust=1.6, 
            color="white", size=3)+
  geom_text(aes(y=0.90, label=labN), vjust=1.6, 
            color="white", size=3)+
  labs(x= "Year", y= "Richness")+
  scale_fill_manual(values=colors.book)+
  scale_y_continuous(expand=c(0,0), breaks = c(0, 0.5, 1))+
  theme_classic()+
  theme(#panel.spacing = unit(-1, "lines"),
    aspect.ratio = 1.3/1,
    legend.position='none',
    strip.text.x = element_blank(),
    axis.title = element_text(size=10, margin = margin(t=0, r=0, b=0, l=0, unit="mm")), 
    axis.text = element_text(size=10))

fig1

ggsave("Fig 1.png",
       device = png,
       plot = fig1,
       path = here::here("outputs", "figures"),
       width = 168,
       height = 80,
       units = "mm",
       dpi = 300,
)

