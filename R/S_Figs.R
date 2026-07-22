
# figure endemics ---------------------------------------------------------
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

sppRich$lab_prop <- sprintf("%0.2f%%", sppRich$lab_prop)
sppRich$lab_pos <- sppRich$prop - (sppRich$prop*0.05)

colors.book <- c("#426635", "#67984C")

fig1 <- ggplot2::ggplot(data=sppRich, aes(x=year, y=richness, fill=type))+
  geom_bar(stat="identity", position=position_fill(reverse = TRUE), width = .8)+
  facet_grid(~suborder)+
  geom_text(aes(y=lab_pos, label=lab_prop), vjust=1.6, 
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
    strip.text.x = element_text(size = 10, face = "bold"),
    strip.background = element_blank(),
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


# Figure 1 using absolute values instead of proportions. ------------------

# Calculates the sum per group, BUT keeps the original vector length!
sppRich$total_bar <- ave(sppRich$richness, sppRich$suborder, sppRich$year, FUN = sum)
sppRich$y_labProp <- sppRich$total_bar + 5
sppRich$y_labNe <- sppRich$y_labProp + 10
sppRich$y_labN  <- sppRich$y_labNe + 20

fig_absoluta <- ggplot(data = sppRich, aes(x = year, y = richness, fill = type)) +
  # Empilha o valor absoluto da riqueza
  geom_bar(stat = "identity", position = position_stack(reverse = TRUE), width = 0.7) +
  
  facet_grid(~suborder) +
  
  # 2. labNe logo acima do topo total de cada barra
  geom_text(aes(y = y_labNe, label = labNe), 
            vjust = 0, color = "black", size = 3, check_overlap = TRUE) +
  
  # 3. labN um pouco mais acima do labNe
  geom_text(aes(y = y_labN, label = labN), 
            vjust = 0, color = "black", size = 3, check_overlap = TRUE) +
  
  labs(x = "Year", y = "Richness") +
  scale_fill_manual(values = colors.book) +
  
  # Folga extra no topo do eixo Y (25%) para acomodar os rótulos superiores
  scale_y_continuous(expand = expansion(mult = c(0, 0.25))) +
  
  theme_classic() +
  theme(
    aspect.ratio = 1.3/1,
    legend.position = 'none',
    strip.text.x = element_text(size = 10, face = "bold"),
    strip.background = element_blank(),
    axis.title = element_text(size = 10, margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "mm")),
    axis.text = element_text(size = 10)
  )

fig_absoluta

ggsave("Fig 1_abs.png",
       device = png,
       plot = fig_absoluta,
       path = here::here("outputs", "figures"),
       width = 168,
       height = 80,
       units = "mm",
       dpi = 300,
)



# Using lines and points --------------------------------------------------

sppRich$Endemism <- ifelse(sppRich$type=="end", "Endemic", "Non-Endemic")

# Gráfico de linhas e pontos facetado por Suborder
fig_lines <- ggplot(data = sppRich, aes(x = year, y = richness, 
                                               # Cor diferencia o tipo (end vs non_end)
                                               color = Endemism, 
                                               # Símbolo diferencia o tipo (para acessibilidade)
                                               shape = Endemism, 
                                               # Garante que as linhas conectem o mesmo tipo ao longo dos anos
                                               group = Endemism)) +
  
  # Adiciona as linhas conectando os anos
  geom_line(size = 0.8) +
  # Adiciona os pontos
  geom_point(size = 2.5) +
  # Separa cada subordem em seu próprio painel
  facet_grid(~suborder) +
  # Rótulos dos eixos
  labs(x = "Year", y = "Richness", color = "", shape = "") +
  
  # Cores personalizadas (usando as cores originais que você definiu para os types)
  scale_color_manual(values = colors.book) +
  
  # Estilo visual limpo
  theme_classic() +
  theme(
    aspect.ratio = 1.3/1, # Mantém a proporção vertical das barras originais
    legend.position = "bottom", # Move a legenda para baixo para ganhar espaço horizontal
    
    # Exibe os nomes do facet (suborder) no topo em negrito
    strip.text.x = element_text(size = 10, face = "bold"), 
    strip.background = element_blank(),
    
    # Formatação dos eixos
    axis.title = element_text(size = 10, margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "mm")), 
    axis.text = element_text(size = 10)
  )

fig_lines

ggsave("Fig 1_lines.png",
       device = png,
       plot = fig_lines,
       path = here::here("outputs", "figures"),
       width = 168,
       height = 80,
       units = "mm",
       dpi = 300,
)
