
#' Aquire klips from the Klipfolio API
#'
#' @title klipfolio_klips
#' @param user user (Klipfolio account email)
#' @param password password (Klipfolio account password)
#' @return List of dashboards obtainable by \code{user} with password: \code{password} with id, name and description of klips
#' @export
#'
#'@examples
#' email <- c("klipr.package@gmail.com")
#' password <- c("changeme")
#'
#' klipfolio_klips(email,password)
klipfolio_klips <- function(user, password) {
  
  # ---------------------------------------------------------- #
  # obtain meta data
  # check api access
  # get number of calls needed
  api_meta <- httr::GET(paste("https://app.klipfolio.com/api/1.0/klips?limit=1"),httr::authenticate(user = user, password = password), encode = "XML")
  
  
  if(api_meta$status_code != 200) {
    
    print(paste("API error (",api_meta$status_code,") - check https://apidocs.klipfolio.com/reference for further info",sep = ""))
    
  } else {
    
    n_calls <- ceiling(httr::content(api_meta)$meta$total/100)
    
    # ---------------------------------------------------------- #
    # obtain data from calls
    # assign data to list_base
    for(i in 1:n_calls) {
      
      query <- paste("https://app.klipfolio.com/api/1.0/klips?limit=100&offset=",(i-1)*100, sep= "")
      
      if(i == 1) {
        
        list_raw_base <- httr::GET(query,httr::authenticate(user = user, password = password), encode = "XML")
        list_base <- httr::content(list_raw_base)$data$klips
        
      } else {
        
        list_raw_temp <- httr::GET(query,httr::authenticate(user = user, password = password), encode = "XML")
        list_temp <- httr::content(list_raw_temp)$data$klips
        
      }
      
      if(n_calls != 1 & i != 1) {
        
        list_base <- c(list_base,list_temp)
        
      }
    }
    
    # ---------------------------------------------------------- #
    # create empty df to fill in data
    # fill with data from list_base
    # if if description is empty fill in blank
    # return df
    df <- data.frame(matrix(0, ncol = length(list_base[[1]]), nrow = length(list_base)))
    
    names(df)[1] <- "klip_id"
    names(df)[2] <- "klip_name"
    names(df)[3] <- "klip_description"
    
    for(i in 1:(length(list_base))) {
      df[i,1] <- list_base[[i]]$id
      df[i,2] <- list_base[[i]]$name
      df[i,3] <- if(is.null(list_base[[i]]$description)) {""} else {list_base[[i]]$description}
    }
    return(df)
    Sys.sleep(2)
  }
}
