convert_pdf_txt <- function(filename) {
  
  # Read pdf
  tx  <- pdf_text(filename)
  
  # Create flat txt from pdf
  tx2 <- unlist(str_split(tx, "[\\r\\n]+"))
  txt_flat <- str_split_fixed(str_trim(tx2), "\\s{2,}", 5)
  
  return(txt_flat)
}