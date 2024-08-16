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
        "data/uc_fed_julho_2019/uc_fed_julho_2019.shp",
        options = "ENCONDING=latin1"
) %>%
        filter(UF == 'PA')

flonas_conces <- flonas %>%
        filter(nome %in% conces_pa)

upas <- st_read(
        'D:/concessaoFlorestal/data/upas_concessao_pa_20221206/upas_concessao_pa_20221206.shp'
)

umf <- st_read(
        'D:/concessaoFlorestal/data/umf_concessao_pa/umf_concessao_pa.shp'
)

pa_county <- st_read('D:/geo/ibge/malha_municipal/PA_Municipios_2020/PA_Municipios_2020.shp')

pa_boundary <- st_read('D:/geo/ibge/malha_municipal/PA_UF_2020.shp')

# Set the interactive mode
tmap_mode('view') 

# Municipios
f <- tm_shape(pa_county) +
        tm_polygons(col = NA,
                    alpha = 0.3,
                    group = 'Município',
                    id = 'NM_MUN',
                    popup.vars = NULL) +
        tm_shape(pa_boundary) +
        tm_borders(col = 'black', lwd = 3, group = 'PA') +
        
        # FLONA
        tm_shape(flonas) +
        tm_fill(
                'darkolivegreen1',
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
        tm_basemap(server = 'OpenStreetMap') +
        tm_mouse_coordinates() +
        tm_minimap(server = 'OpenStreetMap', position = c('right', 'bottom'))

flona_map <- tmap_leaflet(f, in.shiny = TRUE) %>%
        addLayersControl(baseGroups = c('Camadas'), 
                         overlayGroups = c('PA', 'FLONA', 'Município', 'Concessão'))
