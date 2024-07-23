compare_handbooks <- function(handbook_old, handbook_new, filename='', print=TRUE) {
  
  # Compare tables with handbook info
  if (print==T & filename == '') {
    message('No filename specified')
  }
  
  if (print==T) {
    df_diff <- diffdf(handbook_old, handbook_new,
                      keys = 'Variabelenr',
                      file = paste0('Output/',Sys.Date(),'_',filename,'.txt'))
  } else {
    df_diff <- diffdf(handbook_old, handbook_new,
                      keys = 'Variabelenr')
  }

  # Check added/removed vars
  removed <- c(VARIABLE = 'Variabelen verwijderd',Variabelenr = '', BASE = 'Geen', COMPARE = '')
  added   <- c(VARIABLE = 'Variabelen toegevoegd',  Variabelenr = '', BASE = '', COMPARE = 'Geen')
  
  if (!is.null(df_diff[['ExtRowsBase']])) {
    removed_vars <- paste0(pull(df_diff$ExtRowsBase),collapse=',')
    removed <- c(VARIABLE = 'Variabelen verwijderd',Variabelenr = '', BASE = removed_vars, COMPARE = '')
    df_diff <- df_diff[!c(names(df_diff) %in% 'ExtRowsBase')] 
  }
  if (!is.null(df_diff[['ExtRowsComp']])) {
    added_vars <- paste0(pull(df_diff$ExtRowsComp),collapse=',')
    added <- c(VARIABLE = 'Variabelen toegevoegd',Variabelenr = '', BASE = '', COMPARE = added_vars)
    df_diff <- df_diff[!c(names(df_diff) %in% 'ExtRowsComp')]  
  }

  # Save differences in tabular form                               
  output_diff <- rbindlist(df_diff, fill=TRUE)
  output_diff <- output_diff %>% select(VARIABLE,Variabelenr,BASE,COMPARE) %>%
                 filter(!is.na(VARIABLE)) %>% 
                 
                 # Summarise detected differences in version to 1 record
                 group_by(VARIABLE) %>% 
                 filter(case_when(VARIABLE=="version" ~ row_number()==1,
                                  T ~ row_number()>=1)) %>%
                 ungroup() %>%
                 mutate(Variabelenr = ifelse(VARIABLE == 'version','ALL',Variabelenr)) 

                 # Remove detected differences that only differ in version number
                 version_old <- output_diff %>% filter(VARIABLE == 'version') %>% pull(BASE)
                 version_new <- output_diff %>% filter(VARIABLE == 'version') %>% pull(COMPARE)
  output_diff <- output_diff %>% 
                 mutate(BASE = ifelse(VARIABLE != 'version', 
                                      str_replace(BASE,version_old,version_new),
                                      BASE)) %>%
                 #mutate(identical = ifelse(BASE==COMPARE,'yes','no')) %>%
                 filter(BASE != COMPARE) %>%
                 mutate(BASE = ifelse(VARIABLE != 'version', 
                                      str_replace(BASE,version_new,version_old),
                                      BASE)) 
  
  # Rearranging final output dataframe
  output_diff <- rbind(removed,added,output_diff) %>% rename(Handbook_prior = BASE,
                                                             Handbook_new = COMPARE)
  output_diff <- rbind(output_diff %>% filter(VARIABLE != 'id'),
                       output_diff %>% filter(VARIABLE == 'id'))
  
  if (print==T) {
      write_xlsx(output_diff, path = paste0('Output/',Sys.Date(),'_',filename,'.xlsx'))
  }
  
  return(df_diff)
  
}