
# calculating weighted  degree centrality (WDC) ---------------------------

wdc <- function(pa_matrix, interest_bioma = "Cerrado") {
  biomes <- rownames(pa_matrix)
  total_jaccard <- 0
  
  interest_vector <- pa_matrix[interest_bioma, ]
  
  for (b in biomes) {
    if (b != interest_bioma) {
      neighbor_vector <- pa_matrix[b, ]
      
      # Jaccard: intersection / union
      intersection <- sum(interest_vector == 1 & neighbor_vector == 1)
      union       <- sum(interest_vector == 1 | neighbor_vector == 1)
      
      jaccard <- intersection / union
      total_jaccard <- total_jaccard + jaccard
    }
  }
  return(total_jaccard)
}


# permutation test --------------------------------------------------------
observed_sharing_cerrado <- wdc(pa_matrix, "Cerrado")
cat("Observed sharing in Cerrado (Sum of Jaccard indices):", observed_sharing_cerrado, "\n")

set.seed(42)
n_permutations <- 10000

null_sharing_cerrado <- numeric(n_permutations)



library(vegan)

# 1. Gera os modelos nulos
null_models <- nullmodel(pa_matrix, method = "swap")
simulated_matrices <- simulate(null_models, nsim = 10000)

# 2. Aplica a função wdc em cada uma das 10.000 matrizes (dimensão 3)
null_sharing_cerrado <- apply(simulated_matrices, 3, wdc, interest_bioma = "Cerrado")

# 3. Resumo e P-valor
print(summary(null_sharing_cerrado))

p_value <- sum(null_sharing_cerrado >= observed_sharing_cerrado) / 10000
cat("\n Permutation test p-value (Swap):", p_value, "\n")


df_null <- data.frame(wdc = null_sharing_cerrado)
figS1 <- ggplot(df_null, aes(x = wdc)) +
  geom_histogram(bins = 30, fill = "lightblue", color = "white") +
  geom_vline(xintercept = observed_sharing_cerrado, 
             color = "red", linetype = "dashed", size = 1) +
  coord_cartesian(xlim = c(min(c(null_sharing_cerrado, observed_sharing_cerrado)) - 0.001,
                            max(c(null_sharing_cerrado, observed_sharing_cerrado)) * 1.01)) +
  labs(
    title = "Permutation Test (Swap)",
    x = "Weighted Degree Centrality (WDC)",
    y = "Frequency"
  ) +
  theme_classic()

p

ggsave("Fig S1.png",
       device = png,
       plot = figS1,
       path = here::here("outputs", "figures"),
       width = 180,
       height = 100,
       units = "mm",
       dpi = 1000,
)
