# Load packages
library(dplyr, warn.conflicts = FALSE)

# Load dataset
umf <- foreign::read.dbf('./umf_concessao_florestal_pa.dbf', as.is = T) %>%
        select(1:4) %>%
        rename(FLONA = flona)

glimpse(umf)

upa <- foreign::read.dbf('./UPA_PA.dbf', as.is = T)
glimpse(upa)

# data cleaning
upa_clean <- upa %>%
        left_join(umf, by = c('UMF', 'FLONA')) %>%
        mutate(umf_name = toupper(umf_name)) %>%
        mutate(UPA_aux = if_else(UPA < 10, paste('0', UPA, sep=''), 
                                 as.character(UPA))) %>%
        mutate(id_upa = paste(id_umf, UPA_aux, sep = '-')) %>%
        select(id, id_umf, UMF, umf_name, FLONA, UPA, COD_UPA, id_upa, Conces, 
               Processo, Contrato, Ano_POA, status, AUTEX, Safra, Vol_IF, 
               Vol_Aut, Vol_Exp, Rev_AUTEX, n_arv_inv, n_arv_aut, area_upa)

# Out put
head(upa_clean)
tail(upa_clean, 8)
foreign::write.dbf(upa_clean, './dataAnalysis/UPA_PA.dbf')
write.csv2(upa_clean, './dataAnalysis/umf_concessao_florestal_pa.csv', row.names = F)

as.vector(unique(umf$FLONA))
glimpse(upa_clean)
dim(upa_clean)
dim(upa)
