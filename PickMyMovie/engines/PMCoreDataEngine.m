#import "PMCoreDataEngine.h"


#define Movie @"Movie"

@interface PMCoreDataEngine ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation PMCoreDataEngine
#pragma mark INTERNAL DATABASE

- (id)init {
    if (self = [super init]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}

#pragma mark Write Data to Chosen Movies

//put the values from the server to core data
-(void)addMovie:(PMSearchModel *)model {
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:Movie inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newMovie = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectContext];
    
    [newMovie setValue:model.title forKey:TitleKey];
    [newMovie setValue:model.image forKey:ImageKey];
    [newMovie setValue:@(model.movieId) forKey:MovieIdKey];
    [newMovie setValue:model.releaseDate forKey:ReleaseDateKey];
    [newMovie setValue:@(model.voteAverage) forKey:VoteAverageKey];
    [newMovie setValue:model.genres forKey:GenresKey];
    [newMovie setValue:model.overview forKey:OverviewKey];
    
    NSEntityDescription *entityDescVideo = [NSEntityDescription entityForName:@"VideoKey" inManagedObjectContext:self.managedObjectContext];
    
    NSMutableSet *set = [NSMutableSet new];
    for (NSString *keyString in model.videoKeys) {
        NSManagedObject *videos = [[NSManagedObject alloc]initWithEntity:entityDescVideo insertIntoManagedObjectContext:self.managedObjectContext];
        
        [videos setValue:keyString forKey:@"key"];
        //[videos setValue:model forKey:@"movie"];
        [set addObject:videos];
    }
    [newMovie setValue:set forKey:@"videoKeys"];
    
    
    //Error check
    NSError *error;
    if(![self.managedObjectContext save:&error]){
#if DEBUG
        NSLog(@"Whoops, couldnt save: %@",[error localizedDescription]);
#endif
    }
}

//this gives back all data for a specifi entity
-(NSArray *)getDataWithEntityWithoutPredicate:(NSString *)entity{
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entitydesc];
    NSError *error;
    NSArray *matchingData = [self.managedObjectContext executeFetchRequest:request error:&error];
    return matchingData;
}

-(NSMutableArray *)getAllMovies{
    NSMutableArray *movieDataCollection = [NSMutableArray new];
    
    NSArray *matchingData = [self getDataWithEntityWithoutPredicate:Movie];
    
    for(NSManagedObject *obj in matchingData){
        PMSearchModel *movieData = [[PMSearchModel alloc]initWithContext:obj attributes:[self movieAttributes]];
        [movieDataCollection addObject:movieData];
    }
    
    return movieDataCollection;
}

- (NSDictionary *)movieAttributes {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:Movie inManagedObjectContext:context];
    return  [entity attributesByName];
}

-(NSManagedObject *)movieContextWithId:(int)movieId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:Movie inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              [NSString stringWithFormat:@"%@ = '%d'",MovieIdKey,movieId]];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    if (items.count > 0) {
        NSManagedObject *firstObject = items[0];
        
        return firstObject;
    }
    return nil;
}

-(PMSearchModel *)movieWithId:(int)movieId {
    
    NSManagedObject *object = [self movieContextWithId:movieId];
    if (object != nil) {
        PMSearchModel *model = [[PMSearchModel alloc] initWithContext:object attributes:[self movieAttributes]];
        return model;
    }
    
    return nil;
    
}

-(void)removeMovieWithId:(int)movieId{
    
    NSManagedObject *object = [self movieContextWithId:movieId];
    if (object == nil) {
        return;
    }
    [self.managedObjectContext deleteObject:object];
    
    NSError *error;
    [self.managedObjectContext save: &error];
    
}

@end