

#' Put data into datasource
#'
#' @param data a data object
#' @param datasourceID id of datasource
#' @param user Klipfolio account email
#' @param password Klipfolio account password
#'
#' @return API response
#' @export
#'
#' @examples
#' dat <- head(mtcars)
#' datasource <- c(e535a3be736a7def01d5a07bf1296d57)
#'
#' #' email <- c("klipr.package@gmail.com")
#' password <- c("changeme")
#'
klipfolio_put <- function(data, datasourceID,user,password) {
  
  # ---------------------------------------------------------- #
  # get query of datasource
  query <- paste("https://app.klipfolio.com/api/1.0/datasources/", datasourceID , "/data", sep = "")
  
  # respons of data
  put <- httr::PUT(url=query, httr::authenticate(user = user, password = password), body = as.list(data), encode = "json")
  
  return(put)
  
}