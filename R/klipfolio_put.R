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
#' datasource <- "abcd1234"
#'
#' #' email <- "klipfolior@klipfolior.com"
#' password <- "secret_klipfolior"
#'
klipfolio_put <- function(data, datasourceID,user,password) {
  
  # ---------------------------------------------------------- #
  # check input
  if (is.null(data)) {
    stop("Data cannot be empty")
  }
  
  # ---------------------------------------------------------- #
  # get query of datasource
  query <- paste("https://app.klipfolio.com/api/1.0/datasources/", datasourceID , "/data", sep = "")
  
  # respons of data
  put <- httr::PUT(url=query, httr::authenticate(user = user, password = password), body = as.list(data), encode = "json")
  
  return(put)
  
}


