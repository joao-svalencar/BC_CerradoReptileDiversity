library(ggplot2)

# 1. Extrair as coordenadas do NMDS
nmds_coordinates <- as.data.frame(nmds_res$points)
nmds_coordinates$Biome <- rownames(nmds_coordinates)

biome_colors <- c(
  "Cerrado"         = "#E6AB02", 
  "Atlantic Forest" = "#31A354",
  "Caatinga"       = "#D95F02",
  "Amazon"       = "#0B4C28",
  "Pantanal"       = "#0072B2",
  "Pampa"          = "#CC79A7"
)

# 2. Criar o gráfico
nmds_fig <- ggplot(nmds_coordinates, aes(x = MDS1, y = MDS2, color = Biome)) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "gray50", linewidth = 0.6) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "gray50", linewidth = 0.6) +
  geom_point(size = 4, alpha = 0.8) +
  geom_text(aes(label = Biome), 
            vjust = -1, 
            fontface = "bold", 
            size = 4.5, 
            show.legend = FALSE) +
  scale_color_manual(values = biome_colors) +
  expand_limits(
    y = c(min(nmds_coordinates$MDS2) - 0.1, max(nmds_coordinates$MDS2) + 0.1),
    x = c(min(nmds_coordinates$MDS1) - 0.1, max(nmds_coordinates$MDS1) + 0.1)
  ) +
  theme_minimal(base_size = 14) +
  labs(
    x = "Axis 1",
    y = "Axis 2"
  ) +
  theme(
    axis.line = element_line(color = "gray30", linewidth = 0.6),
    legend.position = "none",
    panel.grid.minor = element_blank()
  )


ggsave("nmds_fig.png",
       device = "png",
       plot = nmds_fig,
       path = here::here("outputs", "figures"),
       width = 180,
       height = 100,
       units = "mm",
       dpi = 1000,
)
