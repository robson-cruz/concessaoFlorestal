library(dplyr, warn.conflicts = FALSE)
library(sf, warn.conflicts = FALSE)
library(tmap, warn.conflicts = FALSE)

umf <- st_read(
        'D:/concessaoFlorestal/data/umf_concessao_pa/umf_concessao_pa.shp'
) %>%
        mutate(hectares = as.numeric(hectares))


tmap_mode('view')

umf_map <- tm_shape(umf) +
        tm_polygons(col = NA, 
                    border.col = 'red', 
                    alpha = 0.5,
                    group = 'UMF',
                    id = 'umf',
                    popup.var = c('hectares',
                                  'Flona' = 'flona', 
                                  'Concessionária' = 'conces', 
                                  'Situação' = 'status'),
                    popup.format = list(hectares = list(digits = 2, decimal.mark = ',', big.mark = '.'))
        ) +
        
        #tm_text('Name', size = 1.4) +
        
        tm_facets(sync = FALSE, ncol = 2, by = 'flona', free.coords	
                  = TRUE) +
        
        tm_basemap(server = 'OpenStreetMap') +
        tm_mouse_coordinates()
