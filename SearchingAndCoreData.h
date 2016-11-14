#import "Persistence.h"

@interface SearchingAndCoreData : NSObject   {
    Persistence *_persistence;
}

@property(nonatomic, retain) Persistence *persistence;
@property (strong, nonatomic) NSDictionary *alphabetMenu;
@property (strong, nonatomic) NSDictionary *alphabetDVMenu;
@property (strong, nonatomic) NSMutableArray *menu4drugs_AppDetailsView;
@property (strong, nonatomic) NSArray *keyDict_RLS;
@property (strong, nonatomic) NSArray *objectDict_RLS;
@property (strong, nonatomic) NSArray *keyDictDV;
@property (strong, nonatomic) NSArray *objectDictDV;
@property (strong, nonatomic) NSArray *uniKeyDict;
@property (strong, nonatomic) NSDictionary *uniAlphabet;

-(NSMutableArray *)handleSearchForTerm:(NSString*)text entityName:(NSString*)entityName fieldName:(NSString*)fieldName;

-(NSMutableArray *)handleSearchForTermWithPredicate:(NSString*)entityName fieldName:(NSString*)fieldName num:(NSNumber *)num;

-(NSMutableArray *)handleSearchForTermWithoutPredicate:(NSString*)text entityName:(NSString *)entityName fieldName:(NSString*)fieldName;

-(void) setMenuList4Drugs:(NSNumber *)intDescid entName:(NSString *)entityName fieldName:(NSString *)fieldName type:(NSString *)tableType;

-(NSMutableArray *)handleCombineWithPredicate:(NSString*)entityName fieldName:(NSString*)fieldName num:(NSNumber *)num morePredicateString:(NSString *)morePredicateString;

-(NSMutableArray *)handleTwoFields:(NSString*)entityName fieldNameOne:(NSString *)fieldName num:(NSNumber *)num fieldNameTwo:(NSString *)fieldNameTwo;

-(NSMutableArray *)handleSearchForTermWithCustomPredicate:(NSString*)entityName fieldName:(NSString*)fieldName thePredicateString:(NSString *)predicateString parameters:(NSArray *)parameters;

@end
