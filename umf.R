library(dplyr, warn.conflicts = FALSE)


umf <- foreign::read.dbf('./umf_concessao_florestal_pa.dbf', as.is = T)
glimpse(umf)

test <- umf %>%
        mutate(UMF = gsub('UMF-', '', umf_name)) %>%
        select(id_umf, UMF, umf_name, flona, UF, Conces)

head(test)
tail(test, 8)
foreign::write.dbf(test, './dataAnalysis/New folder/umf_concessao_florestal_pa.dbf')

write.csv(test, './dataAnalysis/New folder/umf_concessao_florestal_pa.dbf')
