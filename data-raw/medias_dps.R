library(tidyverse)



# Dados do "http://tabnet.saude.prefeitura.sp.gov.br/cgi/tabcgi.exe?secretarias/saude/TABNET/SIM/obito.def"
# Carregar dados de 2015 a 2017 (18 e 19 estão faltando)
lista <- map(paste0("data-raw/", 2015:2017, ".csv"), 
             read_csv2, 
             skip = 3,
             n_max = 12, na = "-")

# Empilhar os dados de 2015 a 2017 num unico df
da_empilhado <- bind_rows(lista) %>%
  janitor::clean_names()

# Fazer a soma do que não é acidente e então a media por mês
da_media_dp <- da_empilhado %>%
  rename(mes = 1) %>% 
  mutate(tot = rowSums(.[2:59], na.rm = TRUE)) %>%
  select(1,69) %>%  
  group_by(mes) %>% 
  summarize(media = (mean(tot, na.rm = TRUE)), dp = (sd(tot, na.rm = TRUE))) %>% 
  filter(mes == "Abril")

# Salvar os dados na pasta data
write_csv(da_media_dp, "data/media_abril15_17.csv")            
