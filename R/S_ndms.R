library(ggplot2)

# 1. Extrair as coordenadas dos eixos (NMDS1 e NMDS2) do resultado do NMDS
nmds_coordinates <- as.data.frame(nmds_res$points)

# 2. Adicionar o nome dos biomas como uma coluna de texto
nmds_coordinates$Biome <- rownames(nmds_coordinates)

# 3. Criar o gráfico com o ggplot2
ggplot(nmds_coordinates, aes(x = MDS1, y = MDS2, color = Biome)) +
  # Adiciona pontos grandes para destacar a posição central de cada bioma
  geom_point(size = 4, alpha = 0.8) +
  # Adiciona os nomes dos biomas logo acima ou ao lado dos pontos
  geom_text(aes(label = Biome), vjust = -1, fontface = "bold", size = 4.5) +
  # Define uma paleta de cores bonita e suave (estilo ColorBrewer)
  scale_color_brewer(palette = "Set2") +
  # Ajusta os limites dos eixos para os nomes não ficarem cortados nas bordas
  expand_limits(y = c(min(nmds_coordinates$MDS2) - 0.1, max(nmds_coordinates$MDS2) + 0.1),
                x = c(min(nmds_coordinates$MDS1) - 0.1, max(nmds_coordinates$MDS1) + 0.1)) +
  # Aplica um tema limpo e minimalista
  theme_minimal(base_size = 14) +
  # Customiza os títulos e rótulos
  labs(
    title = "NMDS - Ordenação dos Biomas Brasileiros",
    subtitle = paste("Baseado na proporção de ocorrência de répteis (Stress =", round(nmds_res$stress, 3), ")"),
    x = "NMDS Eixo 1",
    y = "NMDS Eixo 2",
    color = "Biomas"
  ) +
  # Ajustes finos no visual do tema
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 11, face = "italic", hjust = 0.5),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )
