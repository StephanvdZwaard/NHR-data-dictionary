# ------------------------------------------------------------------------------------------------------------------------ #
#                           Script for obtaining data dictionary from NHR handbooks                                        #
# ------------------------------------------------------------------------------------------------------------------------ #
#                                                                                                                          #
# Description:  Retrieve data dictionary from handbooks for the National Heart Registries (NHR)                            #
# Authors:      Stephan van der Zwaard [s.vanderzwaard@amsterdamumc.nl]                                                    #
# Date:         22-06-2023                                                                                                 #
# Version:      1.0                                                                                                        #
# R.version:    4.2.1 (2022-06-23) 
#                                                                                                                          #
# ------------------------------------------------------------------------------------------------------------------------ #


# ------------------------------------------------------------------------------------------------------------------------ #
#                                               Settings & dependencies                                                    #
# ------------------------------------------------------------------------------------------------------------------------ #

  # ------------------------------------------------------
  # Import libraries
  # ------------------------------------------------------   
  
    library(pdftools)
    library(stringr)
    library(writexl)
    library(dplyr)
    library(tidyr)
    library(zoo)
    
  
  # ------------------------------------------------------
  # Set options
  # ------------------------------------------------------   
  
    # set options
    options(stringsAsFactors = FALSE)
    setwd('/R/NHR data dictionary')
  
  # ------------------------------------------------------
  # Load helper scripts
  # ------------------------------------------------------   
  
    source("Scripts/convert_pdf_txt.R")
    source("Scripts/convert_txt_NHR_table.R")
  
  
# ------------------------------------------------------------------------------------------------------------------------ #
#                                        Data collection from pdf handbooks                                                #
# ------------------------------------------------------------------------------------------------------------------------ #
  
  
  # Read NHR handbook from pdf to txt
    path  <- 'Handbooks/'
    files <- list.files(path)
    
    data_dict <- c()
    for (filename in files) {
      
      flat_txt  <- convert_pdf_txt(paste0(path,filename))
      data      <- convert_txt_NHR_table(flat_txt)
      
      if (filename == files[1]) {
          data_dict <- data
      } else {
          data_dict <- full_join(data_dict, data)
      }
    }
  
# ------------------------------------------------------------------------------------------------------------------------ #
#                                                     Final processing                                                     #
# ------------------------------------------------------------------------------------------------------------------------ #

  
  #Final processing
  data_dict <- data_dict %>%
               mutate_at(.vars = vars(c(`Zorg Informatie`,`Bouwsteen (ZIB)`,Opmerkingen,`Opmerking:`,Kwaliteitscontrole)),
                         .funs = list(~ifelse(is.na(.),'',.))) %>%
               mutate(Opmerkingen = paste0(Opmerkingen, `Opmerking:`),
                      Opmerkingen = paste0(Opmerkingen, Kwaliteitscontrole,sep=' ')) %>% 
               mutate(`Zorg informatie bouwsteen (ZIB)` = paste(`Zorg Informatie`,`Bouwsteen (ZIB)`)) %>%
               select(-c(`Zorg Informatie`,`Bouwsteen (ZIB)`)) %>%
               select(handbook:Opmerkingen, `Zorg informatie bouwsteen (ZIB)`, Bron)

  
# ------------------------------------------------------------------------------------------------------------------------ #
#                                                    Save data dictionary                                                  #
# ------------------------------------------------------------------------------------------------------------------------ #
  
  
  # Reformat txt to tabular format for data dictionary
    write_xlsx(data_dict,'data_dictionary_nhr.xlsx')
    
    
    
##############################################################################################################################
#                                                   End of syntax                                                            #
############################################################################################################################## 
