
# figure endemics ---------------------------------------------------------
list_cerrado <- list_br[list_br$cerrado_sp=="yes",]

table(list_cerrado$order)
table(list_cerrado$cerrado_endemic, list_cerrado$order)

library(ggplot2)
library(cowplot)

###########################################################################
# Fig. 1 - Endemism levels ------------------------------------------------
sppRich
sppRich$suborder <- factor(sppRich$suborder, levels=c("Amphisbaenia", "Sauria", "Serpentes"))
sppRich$year <- factor(sppRich$year)

sppRich$lab_prop <- round(sppRich$prop*100, digits=2)

sppRich$lab_prop <- ifelse(
  is.na(sppRich$lab_prop), 
  NA_character_, 
  sprintf("%0.2f%%", sppRich$lab_prop)
)

sppRich$lab_pos <- sppRich$prop - (sppRich$prop*0.05)

sppRich

colors.book <- c("#426635", "#67984C")

# Using lines and points --------------------------------------------------
fig1a <- ggplot(data = sppRich,
                aes(x = year, y = richness,
                    color = endemism,
                    shape = endemism,
                    group = endemism)) + #connect lines
  
  geom_line(linewidth = 0.8, show.legend = FALSE) +
  geom_point(size = 1.5) +
  facet_grid(~suborder) +
  
  labs(x = "", y = "Richness", color = "", shape = "") +
  scale_color_manual(values = colors.book,
                     labels = c("Endemic", "Non-Endemic")) +
  scale_shape_manual(values = c(16,17),
                     labels = c("Endemic", "Non-Endemic")) +
  
  theme_classic() +
  theme(
    plot.margin = margin(t = 1, r = 1, b = 2, l = 1, unit = "mm"),
    #aspect.ratio = 1.3/1,
    
    legend.position = "inside",
    legend.direction = "vertical",
    legend.text = element_text(size = 8), 
    legend.position.inside = c(0.4, 1),
    legend.justification = c(1, 1),
    legend.background = element_blank(),
    legend.key = element_blank(),
    
    strip.text.x = element_text(size = 8, face = "bold"), 
    strip.background = element_blank(),
    
    axis.title = element_text(size = 10), 
    axis.text = element_text(size = 8),
    
    axis.line.x = element_blank(),
    axis.title.x = element_blank(),
    axis.text.x  = element_blank(),
    axis.ticks.x = element_blank(),
  )

fig1a

# bar-plot ----------------------------------------------------------------
fig1b <- ggplot2::ggplot(data=sppRich, aes(x=year, y=richness, fill=endemism))+
  geom_bar(stat="identity", position=position_fill(reverse = TRUE), width = .8)+
  facet_grid(~suborder)+
  geom_text(aes(y=lab_pos, label=lab_prop), vjust=1.6, 
            color="white", size=1.8)+
  geom_text(aes(y=0.80, label=labNe), vjust=1.6, 
            color="white", size=2)+
  geom_text(aes(y=0.90, label=labN), vjust=1.6, 
            color="white", size=2)+
  labs(x= "Year", y= "Richness")+
  scale_fill_manual(values=colors.book)+
  scale_y_continuous(expand=c(0,0), breaks = c(0, 0.5, 1))+
  theme_classic()+
  theme(
    plot.margin = margin(t = 2, r = 1, b = 1, l = 1, unit = "mm"),
    #aspect.ratio = 1.3/1,
    legend.position='none',
    
    strip.text = element_blank(),
    strip.background = element_blank(),
 
    axis.title = element_text(size=10), 
    axis.text = element_text(size=8))

fig1b


fig1 <- cowplot::plot_grid(fig1a, fig1b,
                           nrow=2, ncol=1, align = 'v', #axis='lr',
                           labels = c('A', 'B'), label_size=10,
                           vjust=3,hjust=0, rel_heights = c(1,1))



ggsave("Fig 1.png",
       device = png,
       plot = fig1,
       path = here::here("outputs", "figures"),
       width = 110,
       height = 110,
       units = "mm",
       dpi = 300,
)
