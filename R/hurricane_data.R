#' Read in Extended Best Track (EBTRK) data
#'
#' This function reads in raw EBTRK rectangular data and returns a tibble
#'
#' @param filename A character string with the full file name
#' @param dir A characther string with path to data file
#'
#' @return The function returns a data table with EBTRK data.
#'
#' @importFrom readr read_fwf fwf_widths
#'
#' @export
data_fetch <- function(filename = "ebtrk_atlc_1988_2015.txt", dir = "./data") {
    # construct file path
    filepath <- paste(dir, filename, sep = "/")

    # check to see if file exists and path is correct
    stopifnot(file.exists(filepath))

    # column widths in the raw EBTRK datafile
    ext_tracks_widths <- c(7, 10, 2, 2, 3, 5, 5, 6, 4, 5, 4, 4, 5, 3,
                           4, 3, 3, 3, 4, 3, 3, 3, 4, 3, 3, 3, 2, 6, 1)

    # column names
    ext_tracks_colnames <- c("storm_id", "storm_name", "month", "day",
                             "hour", "year", "latitude", "longitude",
                             "max_wind", "min_pressure", "rad_max_wind",
                             "eye_diameter", "pressure_1", "pressure_2",
                             paste("radius_34", c("ne", "se", "sw", "nw"),
                                   sep = "_"),
                             paste("radius_50", c("ne", "se", "sw", "nw"),
                                   sep = "_"),
                             paste("radius_64", c("ne", "se", "sw", "nw"),
                                   sep = "_"),
                             "storm_type", "distance_to_land", "final")

    # read in data
    ext_tracks <- readr::read_fwf(filepath,
                                  readr::fwf_widths(ext_tracks_widths,
                                                    ext_tracks_colnames),
                                  na = "-99")

    # returns a tibble
    return(ext_tracks)
}

#' Tidy EBTRK hurricane data
#'
#' This function takes the data fetched by the \code{data_fetch} function and "tidys" up the data
#'
#' @param data Tibble that is created using the \code{data_fetch} function
#'
#' @return Returns a "tidy" tibble
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate select starts_with
#' @importFrom stringr str_to_title
#' @importFrom lubridate ymd_h
#' @importFrom tidyr pivot_longer separate pivot_wider
#'
#' @export
data_tidy <- function(data) {

    clean_data <-
        data %>%
        # create new variables
        dplyr::mutate(storm_id = paste(stringr::str_to_title(storm_name), year,
                                       sep = "-"),
                      date = lubridate::ymd_h(paste(year, month, day, hour,
                                                    sep = "-")),
                      longitude = - longitude,
                      wind_speed = max_wind,
                      ) %>%
        # select/arrange needed variables
        dplyr::select(storm_id, date, latitude, longitude, wind_speed,
                      radius_34_ne:radius_64_nw) %>%
        # gather radius values and names in radius and variable columns
        tidyr::pivot_longer(names_to = "variable", values_to = "radius",
                            dplyr::starts_with("radius")) %>%
        # separate varaible in to suffix, wind_speed, and quadrant
        tidyr::separate(col = variable,
                        into = c("suffix", "wind_speed", "quadrant"),
                        sep = "_") %>%
        # spread quadrand ne, se, sw, and se into separate columns
        tidyr::pivot_wider(names_from = quadrant, values_from = radius) %>%
        # drop suffix column
        dplyr::select(-suffix)

    # return tidy data
    return(clean_data)
}

#' Filter out data by hurricane
#'
#' This function takes the clean data produced by the \code{data_tidy} function and produces a new filtered dataset
#'
#' @note The year of the storm is also needed because storm names are recycled
#'
#' @param data A tibble with tidy hurricane data
#' @param name A character string of the name of the hurricane
#' @param year And integer or character string with year of the storm -- as the same named storm can happen in multiple years
#'
#' @return Filtered hurricane data
#'
#' @importFrom dplyr filter
#' @importFrom stringr str_detect str_to_title
#'
#' @examples
#' \dontrun{
#'     data_filter_hurricane(data, name = "alberto", year = 1988)
#'     data_filter_hurricane(data, name = "alberto", year = "2006")
#'     data_filter_hurricane(data, name = "alberto", year = 2012)
#' }
#'
#' @export
data_filter_hurricane <- function(data, name = "alberto", year = 2012) {
    #stopifnot(exists(data))

    hurricane_data <-
        data %>%
        dplyr::filter(stringr::str_detect(storm_id, stringr::str_to_title(name)) &
                      stringr::str_detect(storm_id, as.character(year)))

    return(hurricane_data)
}

