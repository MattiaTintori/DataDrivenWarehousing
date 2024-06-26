library(osrm)
library(leaflet)
library(sf)
library(tidyverse)
library(readxl)
# Import dataframe and warehouse settings
warehouses <- read.csv("final_warehouses.csv")
customers_served <- read_csv("final_served_customers.csv")
warehouses = warehouses %>% filter(build_warehouse=="Yes")
warehouse_sf <- st_as_sf(warehouses, coords = c("longitude", "latitude"), crs = 4326)
df = read_xlsx("../Db_corretto.xlsx") %>% 
  mutate(unique_id = paste0(Cliente, "_", row_number()-1)) %>% 
  select(unique_id, Cliente, Longitudine, Latitudine, Freq_ordini) %>% 
  rename(lat_client = Latitudine, lng_client = Longitudine)
df$lng_client <- as.numeric(df$lng_client)
df$lat_client <- as.numeric(df$lat_client)
# OSRM isochrone for cluster 1
iso_1 <- osrmIsochrone(warehouse_sf[1,], 
                       breaks = seq(from = 0, to = 60, by = 10),
                       res = 300,
                       osrm.server = "http://127.0.0.1:5000/")
# OSRM isochrone for cluster 2
iso_2 <- osrmIsochrone(warehouse_sf[2,], 
                       breaks = seq(from = 0, to = 60, by = 10),
                       res = 300,
                       osrm.server = "http://127.0.0.1:5000/")

customers_served = customers_served %>% 
  left_join(df %>% select(unique_id, lng_client, lat_client, Freq_ordini), by = "unique_id")
# Distances for 2 warehouses
warehouse_sf <- st_as_sf(warehouses, coords = c("longitude", "latitude"), crs = 4326)
customer_sf <- st_as_sf(customers_served, coords = c("lng_client", "lat_client"), crs = 4326)
distances <- vector(mode = "numeric", length = nrow(customers_served))
durations <- vector(mode = "numeric", length = nrow(customers_served))
for (i in 1:nrow(customer_sf)) {
  assigned_warehouse <- customer_sf$warehouse_id[i]
  warehouse_coords <- warehouse_sf[warehouse_sf$warehouse_id == assigned_warehouse, ]
  result <- osrmTable(src = warehouse_coords,
                      dst = customer_sf[i, ],
                      measure = c("duration", "distance"),
                      osrm.server = "http://127.0.0.1:5000/")
  distances[i] <- result$distances
  durations[i] <- result$durations
}
customers_served$distance <- distances
customers_served$duration <- durations
# Define time breaks
iso_1$run_times <- factor(paste(iso_1$isomin, "to", iso_1$isomax, "min"))
iso_2$run_times <- factor(paste(iso_2$isomin, "to", iso_2$isomax, "min"))
# Define color palette
factpal <- colorFactor(rev(heat.colors(6)), iso_1$run_times)
# Coordinates for the warehouses from warehouse_sf
warehouse_1 <- st_coordinates(warehouse_sf[1,])
warehouse_2 <- st_coordinates(warehouse_sf[2,])
# Customer count and percentage
points_within_categories_1 <- cut(customers_served$duration[customers_served$warehouse_id == 'Warehouse 35'], breaks = seq(0, 60, by = 10), right = FALSE, include.lowest = TRUE, labels = iso_1$run_times)
points_within_categories_2 <- cut(customers_served$duration[customers_served$warehouse_id == 'Warehouse 97'], breaks = seq(0, 60, by = 10), right = FALSE, include.lowest = TRUE, labels = iso_2$run_times)
counts_1 <- table(points_within_categories_1)
counts_2 <- table(points_within_categories_2)
total_customers <- nrow(customers_served)
total_percentage_1 <- 0
total_percentage_2 <- 0
box_content_1 <- "<div id='content_1' style='font-size: 12px;'>"
box_content_1 <- paste0(box_content_1, "<b>Customers within Travel Time Categories (Warehouse 35):</b><br>")
for (i in seq_along(counts_1)) {
  percentage_1 <- counts_1[i] / total_customers * 100
  total_percentage_1 <- total_percentage_1 + percentage_1
  box_content_1 <- paste0(box_content_1, counts_1[i], " customers within ", names(counts_1)[i], " (", round(percentage_1, 2), "%)", "<br>")
}
box_content_1 <- paste0(box_content_1, "<br><b>Percentage of customers within 1 hour (Warehouse 35):</b> ", round(total_percentage_1, 2), "%", "<br></div>")

box_content_2 <- "<div id='content_2' style='font-size: 12px;'>"
box_content_2 <- paste0(box_content_2, "<b>Customers within Travel Time Categories (Warehouse 97):</b><br>")
for (i in seq_along(counts_2)) {
  percentage_2 <- counts_2[i] / total_customers * 100
  total_percentage_2 <- total_percentage_2 + percentage_2
  box_content_2 <- paste0(box_content_2, counts_2[i], " customers within ", names(counts_2)[i], " (", round(percentage_2, 2), "%)", "<br>")
}
box_content_2 <- paste0(box_content_2, "<br><b>Percentage of customers within 1 hour (Warehouse 97):</b> ", round(total_percentage_2, 2), "%", "<br></div>")
# Leaflet map
isochrone <- leaflet() %>%
  addTiles() %>%
  addPolygons(data = iso_1, fill = TRUE, stroke = TRUE,
              color = "white", fillColor = ~factpal(run_times),
              weight = 0.5, fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Cluster 1") %>%
  addMarkers(lng = warehouse_1[1], lat = warehouse_1[2], popup = "Warehouse 1",
             group = "Cluster 1") %>%
  addPolygons(data = iso_2, fill = TRUE, stroke = TRUE,
              color = "white", fillColor = ~factpal(run_times),
              weight = 0.5, fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Cluster 2") %>%
  addMarkers(lng = warehouse_2[1], lat = warehouse_2[2], popup = "Warehouse 2",
             group = "Cluster 2") %>%
  addCircleMarkers(lng = customers_served$lng_client, 
                   lat = customers_served$lat_client, 
                   radius = 2,
                   stroke = FALSE,
                   color = "gray",
                   fillOpacity = 0.5) %>%
  addLegend("bottomright", pal = factpal, 
            values = iso_1$run_times,
            title = "Travel Time (minutes)") %>%
  addLayersControl(overlayGroups = c("Cluster 1", "Cluster 2"),
                   options = layersControlOptions(collapsed = FALSE),
                   position = "topleft") %>%
  setView(lng = mean(c(warehouse_1[1], warehouse_2[1])),
          lat = mean(c(warehouse_1[2], warehouse_2[2])),
          zoom = 8) %>%
  addControl(html = box_content_1, layerId = "Cluster 1", position = "topright") %>% 
  addControl(html = box_content_2, layerId = "Cluster 2", position = "topright")
# Visualization
isochrone