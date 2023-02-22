library(dplyr, warn.conflicts = FALSE)
library(sf, warn.conflicts = FALSE)
library(leaflet, warn.conflicts = FALSE)


source("D:/concessaoFlorestal/leaflet_map_flonas.R")

umf <- st_read(
        "D:/concessaoFlorestal/data/umf_concessao_pa/umf_concessao_pa.shp"
) %>%
        mutate(hectares = as.numeric(hectares))

upas <- st_read(
        "D:/concessaoFlorestal/data/upas_concessao_pa_20221206/upas_concessao_pa_20221206.shp"
) %>%
        mutate(status = recode(status, "Exploracao Futura" = "Exploração Futura"))

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

umf_map <- umf %>%
        leaflet() %>%
        addTiles() %>%
        addProviderTiles(provider = "OpenTopoMap", group = "OpenTopoMap") %>%
        addProviderTiles(provider = "OpenStreetMap.Mapnik", group = "OpenStreetMap") %>%
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
                fillOpacity = 0.05,
                fill = upas$status,
                popup = pop_upa
        ) %>%
        addLayersControl(
                baseGroups = c("OpenTopoMap", "OpenStreetMap", "UPA"),
                overlayGroups = c("UMF"),
                options = layersControlOptions(collapsed = FALSE)
        ) %>%
        addMiniMap(toggleDisplay = TRUE) %>%
        leafem::addMouseCoordinates() %>%
        leafem::addHomeButton(group = "UMF", position = "topleft") %>%
        leafem::addLogo(
                img = "https://upload.wikimedia.org/wikipedia/commons/8/81/Logo_IBAMA.svg", 
                url = "http://www.ibama.gov.br/index.php?tipo=portal",
                position = "bottomleft",
                width = 100,
                height = 50
        )
