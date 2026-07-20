# 1. Função para calcular a força de compartilhamento de um bioma foco (Cerrado)
# direto da matriz de presença e ausência
calcular_compartilhamento <- function(matriz_pa, bioma_foco = "Cerrado") {
  biomas <- rownames(matriz_pa)
  total_jaccard <- 0
  
  # Vetor da espécie no bioma foco (Cerrado)
  foco_vetor <- matriz_pa[bioma_foco, ]
  
  for (b in biomas) {
    if (b != bioma_foco) {
      vizinho_vetor <- matriz_pa[b, ]
      
      # Matemática pura de Jaccard: Intersecção / União
      Intersecção <- sum(foco_vetor == 1 & vizinho_vetor == 1)
      União       <- sum(foco_vetor == 1 | vizinho_vetor == 1)
      
      jaccard <- Intersecção / União
      total_jaccard <- total_jaccard + jaccard
    }
  }
  return(total_jaccard)
}

# 2. Calcular o Valor Real Observado do Cerrado (agora na escala correta de 0 a 5)
observed_sharing_cerrado <- calcular_compartilhamento(pa_matrix, "Cerrado")
cat("Valor REAL observado do Cerrado (Soma das frações de Jaccard):", observed_sharing_cerrado, "\n")

set.seed(42)
n_permutations <- 1000  # Pode testar com 1000 primeiro

null_sharing_cerrado <- numeric(n_permutations)

cat("Rodando as permutações na escala correta...\n")
for (i in 1:n_permutations) {
  # Embaralha as linhas da matriz de presença e ausência
  permuted_pa <- pa_matrix
  for (j in 1:nrow(permuted_pa)) {
    permuted_pa[j, ] <- sample(permuted_pa[j, ])
  }
  
  # Calcula o compartilhamento usando a mesma função do dado real
  null_sharing_cerrado[i] <- calcular_compartilhamento(permuted_pa, "Cerrado")
}

# Novo Summary para checar se as escalas bateram
print(summary(null_sharing_cerrado))

# Novo p-valor honesto
p_value_real <- sum(null_sharing_cerrado >= observed_sharing_cerrado) / n_permutations
cat("\nNovo P-valor do Teste de Permutação:", p_value_real, "\n")
