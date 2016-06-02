#' Set the Census API key
#' @export
#' @param api_key (character) Get Census's API key at \url{http://api.census.gov/data/key_signup.html}.
set_api_key = function(api_key) Sys.setenv(saipe_key = api_key)

#' Get SAHIE data
#'
#' Get SAHIE data at various geographic levels.
#'
#' @import tibble
#' @importFrom httr GET content
#' @importFrom readr write_csv read_csv
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map_df
#'
#' @param geo (character) One of "us", "state", and "county".
#' @param year (numeric) A four-digits value or vector of values. Possible values: 2006--2014.
#' @param var (character) A string or vector of strings. Possible fields: \url{http://api.census.gov/data/timeseries/healthins/sahie/variables.html}
#' @param api_key Use \code{sahieAPI::set_api_key("<Your api here>")} to set api_key.
#' @param ... Pass parameter \code{year} or \code{var} for function \code{sahie_us()}, \code{sahie_state()}, and \code{sahie_county()}. Also see Example section.
#'
#' @return Return a tibble, i.e., modern data frame.
#' If multiple years are specified, it gives a panel dataset.
#'
#' @examples \dontrun{
#' sahieAPI::set_api_key("<Your api here>")
#'
#' # Get national level uninsurance rate for various income groups in 2014
#' sahieAPI::sahie(geo = "us", year = 2014, var = c("NAME", "NUI_PT", "IPR_DESC", "IPRCAT", "PCTUI_PT"))
#'
#' # Or
#' sahieAPI::sahie_us(year = 2014, var = c("NAME", "NUI_PT", "IPR_DESC", "IPRCAT", "PCTUI_PT"))
#'
#' # Get 2013--2014 data for natinal level, state-level, and county-level
#' sahieAPI::sahie_us(year = 2013:2014, var = c("NAME", "NUI_PT", "IPR_DESC", "IPRCAT", "PCTUI_PT"))
#' sahieAPI::sahie_state(year = 2013:2014, var = c("NAME", "NUI_PT", "IPR_DESC", "IPRCAT", "PCTUI_PT"))
#' sahieAPI::sahie_county(year = 2013:2014, var = c("NAME", "NUI_PT", "IPR_DESC", "IPRCAT", "PCTUI_PT"))
#' }
#'
#' @export
sahie = function(geo, year = 2014,  var = c("NAME", "NUI_PT"), api_key = NULL) {
        api_key = Sys.getenv("saipe_key")
        if (identical(api_key, ""))
                stop("Missing API key. Did you forget to call sahieAPI::set_api_key()?", call. = FALSE)
        var = paste(var, sep = '', collapse = ',')
        url = paste0("http://api.census.gov/data/timeseries/healthins/sahie?",
                     "get=", var,
                     "&for=", geo, ":", "*",
                     "&time=", year,
                     "&key=", api_key)
        purrr::map_df(url, sahie_parse)
}

#' @export
#' @rdname sahie
sahie_us = function(...) sahie(geo = "us", ...)

#' @export
#' @rdname sahie
sahie_state = function(...) sahie(geo = "state", ...)

#' @export
#' @rdname sahie
sahie_county = function(...) sahie(geo = "county", ...)

# Helper function
sahie_parse = function(url){
        resp = httr::GET(url)
        if (resp$status_code != 200) stop("HTTP failure: ", resp$status_code, call. = FALSE)

        text = httr::content(resp, "text")
        if (identical(text, "")) stop("No output to parse", call. = FALSE)

        parsed = jsonlite::fromJSON(text, simplifyVector = TRUE)
        parsed = as.data.frame(parsed, stringAsFactors = FALSE)

        tf_csv = tempfile(fileext = ".csv")
        readr::write_csv(parsed, tf_csv)
        readr::read_csv(tf_csv, skip = 1)
}
