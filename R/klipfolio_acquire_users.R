
#' Aquire users from the Klipfolio API
#'
#' @title klipfolio_users
#' @param user user (Klipfolio account email)
#' @param password password (Klipfolio account password)
#'
#' @return List of users obtainable by \code{user} with password: \code{password} with name, email and last login
#' @export
#'
#' @examples
#' email <- c("klipr.package@gmail.com")
#' password <- c("changeme")
#'
#' klipfolio_users(email,password)
#' 
klipfolio_users <- function(user, password) {
  
  # ---------------------------------------------------------- #
  # obtain meta data
  # check api access
  # get number of calls needed
  api_meta <- httr::GET(paste("https://app.klipfolio.com/api/1.0/users?limit=1"),httr::authenticate(user = user, password = password), encode = "XML")
  
  
  if(api_meta$status_code != 200) {
    
    print(paste("API error (",api_meta$status_code,") - check https://apidocs.klipfolio.com/reference for further info",sep = ""))
    
  } else {
    
    n_calls <- ceiling(httr::content(api_meta)$meta$total/100)
    
    #---------------------------------------------------------- #
    # obtain data from calls
    # assign data to list_base
    for(i in 1:n_calls) {
      
      # query
      query <- paste("https://app.klipfolio.com/api/1.0/users?limit=100&offset=",(i-1)*100, sep= "")
      
      if(i == 1) {
        
        list_raw_base <- httr::GET(query,httr::authenticate(user = user, password = password), encode = "XML")
        list_base <- httr::content(list_raw_base)$data$users
        
      } else {
        
        list_raw_temp <- httr::GET(query,httr::authenticate(user = user, password = password), encode = "XML")
        list_temp <- httr::content(list_raw_temp)$data$users
        
      }
      
      if(n_calls != 1 & i != 1) {
        
        list_base <- c(list_base,list_temp)
        
      }
    }
    
    # ---------------------------------------------------------- #
    # create empty df to fill in data
    # fill with data from list_base
    # if last-login is empty > add never logged in
    # return df
    df <- data.frame(matrix(0, ncol = length(list_base[[1]]), nrow = length(list_base)))
    
    names(df)[1] <- "user_id"
    names(df)[2] <- "user_first_name"
    names(df)[3] <- "user_last_name"
    names(df)[4] <- "user_email"
    names(df)[5] <- "user_date_last_login"
    
    for(i in 1:(length(list_base))) {
      df[i,1] <- list_base[[i]]$id
      df[i,2] <- list_base[[i]]$first_name
      df[i,3] <- list_base[[i]]$last_name
      df[i,4] <- list_base[[i]]$email
      df[i,5] <- if(is.null(list_base[[i]]$date_last_login)) {"Never logged in"} else {list_base[[i]]$date_last_login}
      
    }
    # return data
    return(df)
    Sys.sleep(2)
  }
}
