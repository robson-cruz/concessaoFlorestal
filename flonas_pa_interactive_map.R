library(dplyr, warn.conflicts = FALSE)
library(sf, warn.conflicts = FALSE)
library(tmap, warn.conflicts = FALSE)
library(leaflet)

# Forest Concession in Pará State
conces_pa <- c('FLORESTA NACIONAL DE CAXIUANÂ', 'FLORESTA NACIONAL DO CREPORI',
               'FLORESTA NACIONAL DE SARACÁ-TAQUERA', 
               'FLORESTA NACIONAL DE ALTAMIRA')

# Load shapefile data
flonas <- st_read(
        'D:/geo/icmbio/UC_fed_junho_2020/flonas.shp',
        options = 'ENCONDING=latin1'
) %>%
        filter(UF == 'PA')

flonas_conces <- flonas %>%
        filter(nome %in% conces_pa)

upas <- st_read(
        'C:/Users/rcflo/Documents/upas_concessao_pa_20221110/upas_concessao_pa_20221110.shp'
)

umf <- st_read(
        'C:/Users/rcflo/Documents/upas_concessao_pa_20221110/umf_concessao_pa.shp'
)

pa_boundaring <- st_read('D:/geo/ibge/malha_municipal/PA_Municipios_2020/PA_Municipios_2020.shp')


# Set the interactive mode
tmap_mode('view') 

# Municipios
tm_shape(pa_boundaring) +
        tm_polygons(col = NA, alpha = 0.1,
                    group = 'Município',
                    id = 'NM_MUN',
                    popup.vars = NULL) +
        
        # FLONA
        tm_shape(flonas) +
        tm_fill(
                'darkolivegreen3',
                alpha = .75, 
                group = 'FLONA',
                id = 'nome', 
                popup.vars = c('Hectares' = 'areaHa', 
                               'Municípios' = 'municipios', 
                               'Ano de Criação' = 'anoCriacao'), 
                popup.format = list(
                        areaHa = list(digits = 2, decimal.mark = ',', big.mark = '.'), 
                        anoCriacao = list(big.mark = '')
                )
        ) +
        
        # FLONA Sob Concessao 
        tm_shape(flonas_conces) +
        tm_borders(col = 'red', group = 'Concessão') +
        
        # tmap_leaflet(flonas_conces, add.titles = FALSE) +
        # leaflet::hideGroup('flonas_conces', 'flonas_conces') +
        
        tm_minimap(server = 'OpenStreetMap', position = c('right', 'bottom')) +
        tm_basemap(server = 'OpenStreetMap') +
        tm_mouse_coordinates()


        
