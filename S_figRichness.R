library(ggplot2)

eval_grid <- expand.grid(
  n_records = seq(0, 1000, length.out = 300),
  order = levels(model_data$order)
)

pred_fit <- predict(mod, newdata = eval_grid, type = "link", se.fit = TRUE)

eval_grid$richness_fit <- exp(pred_fit$fit)
eval_grid$ci_lower     <- exp(pred_fit$fit - 1.96 * pred_fit$se.fit)
eval_grid$ci_upper     <- exp(pred_fit$fit + 1.96 * pred_fit$se.fit)

# 3. Plota no ggplot2
figRich <- ggplot(eval_grid, aes(x = n_records, y = richness_fit, color = order, fill = order)) +
  geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), alpha = 0.15, color = NA) +
  geom_line(size = 1.2) +
  scale_color_manual(values = c("Squamata" = "#2b5c8f", "Testudines" = "#d95f02", "Crocodylia" = "#1b9e77")) +
  scale_fill_manual(values = c("Squamata" = "#2b5c8f", "Testudines" = "#d95f02", "Crocodylia" = "#1b9e77")) +
  labs(
    x = "Number of records per grid cell",
    y = "Expected richnes",
    color = "Order", fill = "Order"
  ) +
  theme_classic(base_size = 14) +
  theme(legend.position = c(0.15, 0.85))

figRich
