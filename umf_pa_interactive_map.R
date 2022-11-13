library(dplyr, warn.conflicts = FALSE)
library(sf, warn.conflicts = FALSE)
library(tmap, warn.conflicts = FALSE)

umf <- st_read(
        'D:/concessaoFlorestal/data/umf_pa.shp'
)

tmap_mode('view')

tm_shape(umf) +
        tm_polygons(col = NA, 
                    border.col = 'red', 
                    alpha = 0.5,
                    group = 'UMF',
                    id = 'umf',
                    popup.var = c('Flona' = 'flona', 'Concessionária' = 'Conces', 'Situação' = 'status')
                    # popup.format = list(
                    #         HECTARES = list(digits = 2, 
                    #                         decimal.mark = ',', 
                    #                         big.mark = '.'))
        ) +
        
        #tm_text('Name', size = 1.4) +
        
        tm_facets(sync = FALSE, ncol = 2, by = 'flona', free.coords	
                  = TRUE) +
        
        tm_basemap(server = 'OpenStreetMap') +
        tm_mouse_coordinates()
