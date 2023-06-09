#' Get location information for a bank with a given CERT number
#'
#' This function retrieves location information for a bank with a given CERT number from the Federal Deposit Insurance Corporation (FDIC) database.
#'
#' @param CERT A character string specifying the CERT number of the bank to retrieve location information for.
#' @param fields A character vector specifying the fields to include in the output. Default is c("NAME", "CITY", "STNAME").
#' @param limit An integer specifying the maximum number of locations to retrieve. Default is 10000.
#'
#' \describe{
#' \item{ZIP}{The ZIP code for the location.}
#' \item{UNINUM}{A unique identifier for the location.}
#' \item{STNAME}{The name of the state where the location is located.}
#' \item{STCNTY}{The name of the county where the location is located.}
#' \item{STALP}{The two-letter abbreviation for the state where the location is located.}
#' \item{SERVTYPE_DESC}{A description of the type of service provided at the location.}
#' \item{SERVTYPE}{A code indicating the type of service provided at the location.}
#' \item{RUNDATE}{The date the location information was last updated.}
#' \item{OFFNUM}{The number of the office associated with the location.}
#' \item{OFFNAME}{The name of the office associated with the location.}
#' \item{NAME}{The name of the financial institution associated with the location.}
#' \item{MAINOFF}{A flag indicating whether the location is the main office for the financial institution.}
#' \item{MDI_STATUS_DESC}{A description of the regulatory status of the financial institution associated with the location.}
#' \item{MDI_STATUS_CODE}{A code indicating the regulatory status of the financial institution associated with the location.}
#' \item{LONGITUDE}{The longitude of the location.}
#' \item{LATITUDE}{The latitude of the location.}
#' \item{FI_UNINUM}{A unique identifier for the financial institution associated with the location.}
#' \item{ESTYMD}{The date the financial institution associated with the location was established.}
#' \item{CSA_NO}{The Core Based Statistical Area (CBSA) number for the location.}
#' \item{CSA_FLG}{A flag indicating whether the location is part of a CBSA.}
#' \item{CSA}{The name of the CBSA associated with the location.}
#' \item{COUNTY}{The name of the county associated with the location.}
#' \item{CITY}{The name of the city associated with the location.}
#' \item{CERT}{The certificate number of the financial institution associated with the location.}
#' \item{CBSA_NO}{The CBSA number for the location.}
#' \item{CBSA_MICRO_FLG}{A flag indicating whether the CBSA associated with the location is a micro area.}
#' \item{CBSA_METRO_NAME}{The name of the metropolitan area associated with the location.}
#' \item{CBSA_METRO_FLG}{A flag indicating whether the location is part of a metropolitan area.}
#' \item{CBSA_METRO}{The code for the metropolitan area associated with the location.}
#' \item{CBSA_DIV_NO}{The CBSA division number for the location.}
#' \item{CBSA_DIV_FLG}{A flag indicating whether the location is part of a CBSA division.}
#' \item{CBSA_DIV}{The name of the CBSA division associated with the location.}
#' \item{CBSA}{The code for the CBSA associated with the location.}
#' \item{BKCLASS}{The bank class associated with the location.}
#' \item{ADDRESS}{Address of the bank.}
#' }
#' @return A data frame containing location information for the bank.
#' @export
#' @import dplyr
#' @examples
#' # Get location information for a bank with CERT number 3850
#' getLocation(3850)
#'
#' # Get location information for a bank with CERT number 3850 and fields "NAME", "CITY", and "ZIP"
#' getLocation(3850, fields = c("NAME", "CITY", "ZIP"))

getLocation <- function(CERT, fields =c("NAME","CITY","STNAME"),limit = 10000){
  stopifnot(!missing(CERT))
  url <- paste0("https://banks.data.fdic.gov/api/locations?filters=CERT%3A",CERT,
                "&fields=CERT%2CNAME%2CESTYMD%2CMAINOFF%2C",
                paste(fields, collapse = '%2C'),
                paste0("&limit=",limit),
                "&format=csv&download=false&filename=data_file")

  tryCatch({
    suppressWarnings(
      df <- read.csv(url,header=TRUE)
    )
    df <- df %>%
      mutate(
        ID = NULL,
        ESTYMD =  as.Date(as.character(get('ESTYMD')), "%m/%d/%Y")
      )

    return(df)
  }, error = function(e) {
    message("ERROR: ", conditionMessage(e))
    return(NULL)
  })
}
