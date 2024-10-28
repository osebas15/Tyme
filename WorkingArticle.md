# WorkingArticle
1% a day is all you need

an app to make and use timed todo list and recepies


## Scratch Pad
- make workable state for my burger/quick breakfast recepie
    - Focus and priority
        prio can start at 0 and go - or +
            raw prio vs working prio / static vs dynamic
        focus is a score based on prio and completion date
        
    
    - AppleWatch
        show quick breakfast
        
    - iPhone
        add to next functionality
            append next multi step to same spot as previous
                when ordering subObjects use a function that goes back to first activity and checks that on actClass.orderSubActivities
                    
                consider continuos task that are processed in the background
                
            show current activity
            figure out focus
                focus should be enumed
                    [main, passive, secondary]
                    
        timing functionality
    
    
### Happy on complete!
consider how to reward user for finishing tasks

### Going through Swiss burger
make next functionality for:
- iOS
- WatchOS

##### Watch
List for all subactivities on select show next or disappear until all are gone and then show next

# Clean up
##Quick
###Activity Object 
 - move pertinent transient properties into own extension
 - clean up done pathing for remove from parent

##Swift Data
- check if things are deleted after arc goes to zero if not delete on done

##unit tests

# Permenant notes
## UI
UI is a bit of a challenge due to its tree like nature, starting out with 
simple MVP like UI so I can iterate

### UI watch
can I do edits and creation on the watch
