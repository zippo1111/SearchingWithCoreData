#import "SearchingAndCoreData.h"


@implementation SearchingAndCoreData

@synthesize persistence = _persistence;
@synthesize alphabetMenu = _alphabetMenu;
@synthesize alphabetDVMenu = _alphabetDVMenu;
@synthesize menu4drugs_AppDetailsView = _menu4drugs_AppDetailsView;
@synthesize keyDict_RLS = _keyDict_RLS;
@synthesize keyDictDV = _keyDictDV;
@synthesize objectDict_RLS = _objectDict_RLS;
@synthesize objectDictDV = _objectDictDV;
@synthesize uniKeyDict = _uniKeyDict;
@synthesize uniAlphabet = _uniAlphabet;


-(NSMutableArray *)handleSearchForTerm:(NSString*)text entityName:(NSString*)entityName fieldName:(NSString*)fieldName {
    
    if (_persistence == nil) {
        _persistence = [[Persistence alloc] init];
    }
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:fieldName ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSLog(@"search text: %@", text);
    if (text.length > 0) {
        // Define how we want our entities to be filtered
        NSString *thePredicateString = [NSString stringWithFormat:@"(%@ CONTAINS[c] %%@)", fieldName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:thePredicateString, text];
        [fetchRequest setPredicate:predicate];
//        NSLog(@"Predicate for nomen: %@", predicate);
        
    }
    
    NSError *error;
    NSArray* loadedEntities = [_persistence.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"persistence error: %@", error);
//    NSLog(@"entities: %@", loadedEntities);
    fillArray = [[NSMutableArray alloc] initWithArray:loadedEntities];
    
    return fillArray;
    // [table reloadData];
}

-(NSMutableArray *)handleSearchForTermWithPredicate:(NSString*)entityName fieldName:(NSString*)fieldName num:(NSNumber *)num {
    
    if (_persistence == nil) {
        _persistence = [[Persistence alloc] init];
    }
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:fieldName ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString *thePredicateString = [NSString stringWithFormat:@"(%@ == %%@)", fieldName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:thePredicateString, num];
    [fetchRequest setPredicate:predicate];
//    NSLog(@"Predicate for tradename: %@", predicate);
    
    NSError *error;
    NSArray* loadedEntities = [_persistence.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"persistence error: %@", error);
    fillArray = [[NSMutableArray alloc] initWithArray:loadedEntities];
    return fillArray;
    
}

-(NSMutableArray *)handleSearchForTermWithCustomPredicate:(NSString*)entityName fieldName:(NSString*)fieldName thePredicateString:(NSString *)predicateString parameters:(NSArray *)parameters {
    
    if (_persistence == nil) {
        _persistence = [[Persistence alloc] init];
    }
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:fieldName ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString, parameters];
    [fetchRequest setPredicate:predicate];
    //    NSLog(@"Predicate for tradename: %@", predicate);
    
    NSError *error;
    NSArray* loadedEntities = [_persistence.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //    NSLog(@"persistence error: %@", error);
    fillArray = [[NSMutableArray alloc] initWithArray:loadedEntities];
    return fillArray;
    
}


// (GROUP BY fieldName) ASC fieldName
// return: NSDictionaryResultType
-(NSMutableArray *)handleSearchForTermWithoutPredicate:(NSString*)text entityName:(NSString *)entityName fieldName:(NSString*)fieldName {
    
    if (_persistence == nil) {
        _persistence = [[Persistence alloc] init];
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:fieldName ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_persistence.managedObjectContext];
    
    NSAttributeDescription *theField = [entity.attributesByName objectForKey:fieldName];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:theField, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:theField]];
    [fetchRequest setResultType:NSDictionaryResultType];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", fieldName, @""];
    [fetchRequest setPredicate:predicate];
    
    NSLog(@"search text: %@", text);
    if (text.length > 0) {
        // Define how we want our entities to be filtered
        NSString *thePredicateString = [NSString stringWithFormat:@"(%@ CONTAINS[c] %%@)", fieldName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:thePredicateString, text];
        [fetchRequest setPredicate:predicate];
        NSLog(@"Predicate for nomen: %@", predicate);
    }
    
    NSError *error = nil;
    NSMutableArray *fillArray = [[NSMutableArray alloc] initWithArray: [_persistence.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
  
    
    return fillArray;
    
}

-(NSMutableArray *)handleCombineWithPredicate:(NSString*)entityName fieldName:(NSString*)fieldName num:(NSNumber *)num morePredicateString:(NSString *)morePredicateString {
    
    if (_persistence == nil) {
        _persistence = [[Persistence alloc] init];
    }
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:fieldName ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString *thePredicateString = [NSString stringWithFormat:@"(%@ == %%@)", fieldName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:thePredicateString, num];
    [fetchRequest setPredicate:predicate];
//    NSLog(@"Predicate for tradename: %@", predicate);
    
    NSPredicate *morePredicate = [NSPredicate predicateWithFormat:morePredicateString];
    [fetchRequest setPredicate:morePredicate];
//    NSLog(@"more predicate for tradename: %@", morePredicate);
    
    NSError *error;
    NSArray* loadedEntities = [_persistence.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"persistence error: %@", error);
    fillArray = [[NSMutableArray alloc] initWithArray:loadedEntities];
    
    return fillArray;
    
}

-(NSMutableArray *)handleTwoFields:(NSString*)entityName fieldNameOne:(NSString *)fieldName num:(NSNumber *)num fieldNameTwo:(NSString *)fieldNameTwo {
    
    if (_persistence == nil) {
        _persistence = [[Persistence alloc] init];
    }
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:fieldNameTwo ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
//    NSString *nameid = [NSString stringWithFormat:@"%@ (%@)", [tn valueForKey:@"name"], nrl.drugform];
    NSString *thePredicateString = [NSString stringWithFormat:@"(%@ == %%@)", fieldName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:thePredicateString, num];
//    [fetchRequest setPredicate:predicate];
//    NSLog(@"Predicate for tradename: %@", predicate);
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_persistence.managedObjectContext];
    NSAttributeDescription *theField = [entity.attributesByName objectForKey:fieldNameTwo];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:theField, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:theField]]; //group by не работает
    [fetchRequest setResultType:NSDictionaryResultType];
    NSPredicate *predicateTwo = [NSPredicate predicateWithFormat:@"%K != %@", fieldNameTwo, @""];
//    [fetchRequest setPredicate:predicateTwo];
    
    NSArray *predicates = [[NSArray alloc] initWithObjects:predicate, predicateTwo, nil];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    [fetchRequest setPredicate:compoundPredicate];
    
//    [fetchRequest setPredicate:predicate];
    
     
    NSError *error;
    NSArray *loadedEntities = [_persistence.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"persistence error: %@", error);
    fillArray = [[NSMutableArray alloc] initWithArray:loadedEntities];
    return fillArray;
    
}


-(void) setAlphaKeyObject {
    _keyDict_RLS = [[NSArray alloc] initWithObjects:@"form", @"drugformdescr", @"characters", @"pharmaactions", @"actonorg", @"componentsproperties", @"pharmakinetic", @"pharmadynamic", @"clinicalpharmacology", @"indications", @"contraindications", @"pregnancyuse", @"sideactions", @"interactions", @"usemethodanddoses", @"overdose", @"precautions", @"specialguidelines", @"manufacturer", @"aptekaCondition", @"comment", @"storcond", @"lifetime", nil];
    
    _objectDict_RLS = [[NSArray alloc] initWithObjects:@"Состав и форма выпуска", @"Описание лекарственной формы", @"Характеристика", @"Фармакологическое действие", @"Действие на организм", @"Свойства компонентов", @"Фармакокинетика", @"Фармакодинамика", @"Клиническая фармакология", @"Показания препарата", @"Противопоказания", @"Применение при беременности и кормлении грудью", @"Побочные действия ", @"Взаимодействие", @"Способ применения и дозы", @"Передозировка", @"Меры предосторожности", @"Особые указания", @"Производитель", @"Условия отпуска из аптек", @"Комментарий", @"Условия хранения", @"Срок годности", nil];
}

-(void) setAlphaDVKeyObject {
    
    _keyDictDV = [[NSArray alloc] initWithObjects:@"rusname", @"latname", @"chemicalname", @"grossformula", @"cascode", @"characters", @"pharmacology", @"indications", @"usage", @"contraindications", @"pregnancyuse", @"sideactions", @"interactions", @"usemethodanddoses", @"uselimitations", @"overdose", @"precautions", @"specialguidelines", nil];
    _objectDictDV = [[NSArray alloc] initWithObjects:@"Русское название", @"Латинское название", @"Химическое наименование", @"Структурная формула", @"Код CAS", @"Характеристика", @"Фармакологическая группа", @"Показания препарата", @"Применение", @"Противопоказания", @"Применение при беременности и кормлении грудью", @"Побочные действия ", @"Взаимодействие", @"Способ применения и дозы", @"Ограничения к применению", @"Передозировка", @"Меры предосторожности", @"Особые указания", nil];
    
}
    
-(void) setAlphabet {
    [self setAlphaKeyObject];
    _alphabetMenu = [NSDictionary dictionary];
    _alphabetMenu = [[NSDictionary alloc] initWithObjects:_objectDict_RLS forKeys:_keyDict_RLS];
}

-(void) setAlphabetDV {
    [self setAlphaDVKeyObject];
    _alphabetDVMenu = [NSDictionary dictionary];
    _alphabetDVMenu = [[NSDictionary alloc] initWithObjects:_objectDictDV forKeys:_keyDictDV];
}


//[_searchingCoreData setMenuList4Drugs:[NSNumber numberWithInteger:[self.appDetails.setDescid integerValue] ] entName:@"Desctextes" fieldName:@"descid" type:@""];

-(void) setMenuList4Drugs:(NSNumber *)intDescid entName:(NSString *)entityName fieldName:(NSString *)fieldName type:(NSString *)tableType {
    /* на основе запроса:
    
     SELECT FORM,  DRUGFORMDESCR, CHARACTERS, PHARMAACTIONS, ACTONORG, COMPONENTSPROPERTIES, PHARMAKINETIC, PHARMADYNAMIC, CLINICALPHARMACOLOGY, INDICATIONS, CONTRAINDICATIONS, PREGNANCYUSE, SIDEACTIONS, INTERACTIONS, USEMETHODANDDOSES, OVERDOSE, PRECAUTIONS, SPECIALGUIDELINES, MANUFACTURER, APTEKA_CONDITION, COMMENT, STORCOND, LIFETIME 
     
     FROM DESCTEXTES 
     
     WHERE DESCID=%@
     
    */
    
    _menu4drugs_AppDetailsView = [[NSMutableArray alloc] init];
    
    if ([tableType isEqualToString:@"DV"]) {
        [self setAlphabetDV];
        _uniKeyDict = _keyDictDV;
        _uniAlphabet = _alphabetDVMenu;
    } else {
        [self setAlphabet];
        _uniKeyDict = _keyDict_RLS;
        _uniAlphabet = _alphabetMenu;
    }
    
    
    NSMutableArray *ndsc = [self handleSearchForTermWithPredicate:entityName fieldName:fieldName num: intDescid];
    
    NSLog(@"ndsc: %@", ndsc);
    NSLog(@"intDescid: %@", intDescid);
    
    for (NSManagedObject *nds in ndsc) {
        for (NSString *keyName in _uniKeyDict) {
            
            NSString *columnName = [[_uniAlphabet objectForKey:keyName] uppercaseString];
            NSString *cellContent = [nds valueForKey:keyName];
            // form "dictionary" using the key - field name&value - row's content
//            NSLog(@"\n columnName: %@ cellContent: %@ \n", columnName, cellContent);
            if (columnName != nil) {
                NSMutableDictionary *tempMenuDictionary = [NSMutableDictionary dictionary];
                
                if (![cellContent isEqual:nil] && ![cellContent isEqualToString:@""]) {
                    NSString *trimmed = [cellContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
//                    NSLog(@"\n trimmed: %@ \n", trimmed);
                    
                    if (trimmed != nil) {
                        [tempMenuDictionary setObject:cellContent forKey:columnName];
                        [_menu4drugs_AppDetailsView addObject:tempMenuDictionary];
                    }
                }
                
                // dictionary into the array: menu4drugs
                //                            [_menu4drugs_AppDetailsView addObject:tempMenuDictionary];
//                NSLog(@"\n insertObject: %@ atIndex:%d \n", tempMenuDictionary, internalCounter);
//                [_menu4drugs_AppDetailsView insertObject:tempMenuDictionary atIndex:internalCounter];
//                internalCounter++;
                
                
                
                //                            [tempMenuDictionary removeAllObjects];
            }
        }
        
    }

    
    
}

@end
