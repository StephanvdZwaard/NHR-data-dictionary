convert_txt_NHR_table <- function(flat_txt) {
  
  # Get registration
    registry    <- flat_txt[which(str_detect(tolower(flat_txt),'(?=.*nhr handboek)(?=.*versie)'))[1]]
    handbook    <- gsub('(.*)-(.*)-(.*)','\\1',gsub('NHR Handboek','',registry)) %>% str_trim()
    version     <- gsub('(.*)-(.*)-(.*)','\\2',registry) %>% str_trim()
  
  # Select relevant sections from NHR handbook
    if(handbook == 'Percutane Coronaire Interventie (PCI)') {
      id_overview <- tail(which(grepl('^2.2 overzicht variabelen',    tolower(flat_txt))),1)
      id_specs    <- tail(which(grepl('^2.3 specificaties variabelen',tolower(flat_txt))),1)
      id_descript <- which(flat_txt=='2.4 Casuïstiek') # When next paragraph isn't the description of datasets (PCI).
    } else {
      id_overview <- tail(which(str_detect(tolower(flat_txt), '(?=.*overzicht)(?=.*variabelen)')),1)
      id_specs    <- tail(which(str_detect(tolower(flat_txt), '(?=.*specificaties)(?=.*variabelen)')),1)
      id_descript <- which(flat_txt=='3. Beschrijving datasets')
    }
  
  # Get overview of variables
    data <-  data.frame(flat_txt[(id_overview+1):(id_specs-1),]) %>% select(1:4)
    colnames(data) <- c('Variabelenr','Variabelenaam','Aanlevering_basic','Opmerking_basic')
    base <-  data %>% 
             mutate(Categorie = ifelse(Variabelenr == 'Variabelenr',lag(Variabelenr,1),NA)) %>%
             filter(!c(Variabelenr %in% Categorie),
                    !str_detect(Variabelenr,'NHR Handboek'),
                    row_number()>1,
                    Variabelenr != '') %>%
             mutate(Categorie    = na.locf(Categorie)) %>%
             mutate(Aanvulling   = ifelse(!grepl("[0-9]",Variabelenr) & grepl("^[[:lower:]]+$", Variabelenr), Variabelenr,NA)) %>%
             mutate(Variabelenaam = ifelse(lead(Variabelenaam,1)=='' & !is.na(lead(Aanvulling,1)), paste(Variabelenaam,lead(Aanvulling,1)), Variabelenaam)) %>%
             filter(Variabelenaam != '', Variabelenr != 'Variabelenr') %>%
             select(-c(Aanvulling, Variabelenaam))
  
  # Get specific data dictionary information per variable
    data   <-  data.frame(flat_txt[(id_specs+1):(id_descript-1),]) %>% select(1:2)
    colnames(data) <- c('name','value')
    fields <-  c('Aanlevering|Datatype|Definitie|Kolomnaam|Variabelenaam|Variabelenr|Codering|Opmerkingen|Zorg Informatie|Bron')
  
      # Add approximate 'fuzzy' string matching for overall categories.
      fuzzy <- c()
      for (i in 1:nrow(data)) {
          if (data$name[i] != '') {
              fuzzy[i] <- length(agrep(data$name[i],unique(base$Categorie),max.distance = 0.05))
          } else {
              fuzzy[i] <- 0
          }
      }
      
    data   <-  cbind(data,fuzzy) %>% 
      
               # Perform data wrangling: Filter empty rows and NHR handbook description remove special symbols
                 filter(!c(value == '' & name == '')) %>%
                 filter(!str_detect(name,paste0('NHR Handboek ',handbook))) %>%
                 mutate_all(.funs = list(~ifelse(.=='','',.))) %>%
                 mutate(name = ifelse(name %in% c('codering','Coderingen'),'Codering',name),
                        name = ifelse(name %in% c('Opmerking'),'Opmerkingen',name)) %>%
      
               # Filter category description and duplicate names
                 filter(!c(name %in% unique(base$Categorie))) %>% 
                 filter(!c(str_detect(substr(name,1,1),"[[:upper:]]") & fuzzy > 0)) %>%   # Filter categories detected by approximate string matching and starting with a capital letter.
                 filter(!c(name == lag(name,1) & str_detect(name,'Codering'))) %>%        #Filter for double codering.
      
               # Add variable code as column (to avoid duplicate rows)
                 mutate(id = ifelse(name == 'Variabelenr',1,NA)) %>%
                 mutate(id = ifelse(id == 1, value, NA)) %>% 
                 filter(!c(row_number()==1 & is.na(id))) %>%
                 mutate(id = na.locf(id)) %>%
  
               # Correctly position and combine separated text fields
                 mutate(value = ifelse(value=='' & !c(name %in% fields) & lag(name,1) != 'Variablenr',name,value)) %>%
                 mutate(name  = ifelse(name == value & !str_detect(value,fields), NA, name)) %>%
                 mutate(name  = ifelse(name == "", NA, name)) %>%
                 mutate(name  = na.locf(name)) %>%
                 group_by(id,name) %>% 
                 mutate(value = paste0(value, collapse = " ")) %>%
                 filter(row_number() ==1) %>%
                 ungroup() %>%
      
               # Transpose df
                 pivot_wider(names_from = name, values_from = value, values_fill = NA) %>%
      
               # Add variable number and merge columns for ZIB
                 filter(!is.na(Variabelenr)) %>%
                 mutate(id = row_number()) %>%
                 select(-fuzzy)
    
    
  # Combine basic and detailed variable descriptions        
    data   <-  left_join(data, base, by=c('Variabelenr')) %>% 
               mutate(handbook = handbook,
                      version  = version) %>%
               select(handbook,version,id:Aanlevering,Categorie,everything())
  
  
  return(data)
}