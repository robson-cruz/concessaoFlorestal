library(dplyr, warn.conflicts = FALSE)
library(sf, warn.conflicts = FALSE)
library(leaflet)


# Forest Concession in Pará State
conces_pa <- c('FLORESTA NACIONAL DE CAXIUANÂ', 'FLORESTA NACIONAL DO CREPORI',
               'FLORESTA NACIONAL DE SARACÁ-TAQUERA', 
               'FLORESTA NACIONAL DE ALTAMIRA')

# Load shapefile data
flonas <- st_read(
        'D:/geo/icmbio/UC_fed_junho_2020/flonas.shp',
        options = 'ENCODING=UTF-8'
) %>%
        filter(UF == 'PA') %>%
        select(nome, areaHa, anoCriacao, areaHa, atoLegal, UF, municipios)

flonas_conces <- flonas %>%
        filter(nome %in% conces_pa)

upas <- st_read(
        'D:/concessaoFlorestal/data/upas_concessao_pa_20221206/upas_concessao_pa_20221206.shp'
) %>%
        st_transform(4326)

umf <- st_read(
        'D:/concessaoFlorestal/data/umf_concessao_pa/umf_concessao_pa.shp'
) %>%
        st_transform(4326)

pop_flona <- paste0(
        "", "<b>",flonas_conces$nom,"</b>",
        "<br>",
        "Hectares: ", prettyNum(flonas_conces$areaHa, big.mark = ".", decimal.mark = ","),
        "<br>",
        "Municípios: ", flonas_conces$municipios,
        "<br>",
        "Ano Criação: ", flonas_conces$anoCriacao
)

pop_umf <- paste0(
        "", "<b>", umf$umf, "</b>",
        "<br>",
        "Hectares: ", prettyNum(umf$hectares, big.mark = ".", decimal.mark = ","),
        "<br>",
        "Concessionária: ", umf$conces,
        "<br>",
        "Situação: ", umf$status
)

flona_map <- flonas_conces %>%
        leaflet() %>%
        addProviderTiles(provider = "OpenStreetMap", group = "OpenStreetmap") %>%
        addPolygons(
                group = "Concessão",
                fillOpacity = 0.05,
                color = 'red',
                weight = 3,
                popup = pop_flona
        ) %>%
        addPolygons(
                data = umf,
                group = "UMF",
                fillOpacity = 0.2,
                color = "steelblue",
                weight = 1,
                popup = pop_umf
        ) %>%
        addLayersControl(
                baseGroups = c("OpenStreetMap", "UMF"),
                overlayGroups = c("Concessão"),
                options = layersControlOptions(collapsed = FALSE)
        ) %>%
        addMiniMap(toggleDisplay = TRUE) %>%
        leafem::addMouseCoordinates() %>%
        leaflet.extras::addResetMapButton() %>%
        leafem::addLogo(
                img = "https://upload.wikimedia.org/wikipedia/commons/8/81/Logo_IBAMA.svg", 
                url = "http://www.ibama.gov.br/index.php?tipo=portal",
                position = "bottomleft",
                width = 100,
                height = 50
        )
