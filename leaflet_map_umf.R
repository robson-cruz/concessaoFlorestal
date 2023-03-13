library(dplyr, warn.conflicts = FALSE)
library(sf, warn.conflicts = FALSE)
library(leaflet, warn.conflicts = FALSE)


source("D:/concessaoFlorestal/leaflet_map_flonas.R")

pa_boundary <- st_read('D:/geo/ibge/malha_municipal/PA_UF_2020.shp') %>%
        st_transform(4326)

umf <- st_read(
        "D:/concessaoFlorestal/data/umf_concessao_pa/umf_concessao_pa.shp"
) %>%
        mutate(hectares = as.numeric(hectares)) %>%
        st_transform(4326)

upas <- st_read(
        "D:/concessaoFlorestal/data/upas_concessao_pa_20221206/upas_concessao_pa_20221206.shp"
) %>%
        mutate(status = recode(status, "Exploracao Futura" = "Exploração Futura")) %>%
        st_transform(4326)

pop_upa <- paste0(
        "<b>", "UPA ", "</b", "<b>", upas$UPA, "</b>",
        "<br>",
        "Código UPA: ", upas$COD_UPA,
        "<br>",
        "UMF: ", upas$umf_name,
        "<br>",
        "Concessionária: ", upas$Conces,
        "<br>",
        "Ano: ", upas$Ano_POA,
        "<br>",
        "Hecatres: ", prettyNum(upas$area_upa, big.mark = ".", decimal.mark = ","),
        "<br>",
        "Volume Autorizado: ", prettyNum(upas$Vol_Aut, big.mark = ".", decimal.mark = ","), " m³",
        "<br>",
        "AUTEX: ", upas$AUTEX,
        "<br>",
        "Status: ", upas$status
)

pal <- colorFactor(palette = "RdYlBu", domain = upas$status)

umf_map <- umf %>%
        leaflet() %>%
        addProviderTiles(provider = "OpenStreetMap.Mapnik", group = "OpenStreetMap") %>%
        addProviderTiles(provider = "OpenTopoMap", group = "OpenTopoMap") %>%
        addPolygons(
                group = "UMF",
                fillOpacity = 0.05,
                color = "red",
                weight = 2,
                popup = pop_umf
        ) %>%
        addPolygons(
                data = upas,
                group = "UPA",
                fillOpacity = 0.5,
                color = ~pal(status),
                highlightOptions = highlightOptions(color = 'yellow', 
                                                    weight = 2,
                                                    fillOpacity = 0.7,
                                                    bringToFront = TRUE),
                popup = pop_upa
        ) %>%
        addLegend(
                pal = pal,
                values = ~upas$status,
                group = "UPA",
                title = "UPA"
        ) %>%
        addPolygons(
                data = pa_boundary,
                group = "Pará",
                fill = FALSE,
                color = "#666"
        ) %>%
        addPolygons(
                data = flonas_conces,
                group = "FLONA",
                fill = NA,
                color = "black",
                popup = pop_flona
                
        ) %>%
        addLayersControl(
                baseGroups = c("OpenTopoMap", "OpenStreetMap"),
                overlayGroups = c("UMF", "Pará", "UPA", "FLONA"),
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
