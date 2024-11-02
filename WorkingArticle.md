# WorkingArticle
1% a day is all you need

an app to make and use timed todo list and recepies

## BIG BUGS
### Memory leaks
    - seems to be mostly at beggining

## Scratch Pad
- Timing mechanism
    - queue up notifications
    - create var waitingTimeOver? on object
    - on foreground or start waiting create timers
    - on background kill timers
    
- make workable state for my burger/quick breakfast recepie
    - UI for Active activities
        - higher nodes!!!
        - ordering and what is shown
            - the higher up on the next scale the higher up on the active list
                - should be scrolled past this
                    - show an up arrow
            - second and where it should be scrolled to are the lowest on the next scale while completable
            - second to last are waiting "passive" activities
            - last are completed activities
        - focus this for complete task
            - i.e Quick Breakfast
    - tasking and multitaskings
        wait X time after completion
            - can be made passive if has a passive timing
                - research between dispatch Queue vs Actor system
        number of completions
        - Focus //and priority
            //class prio vs object prio / static vs dynamic
            ordering matters
            focus is a state. if passive then easy multitask, if focused then compete for spotlight
    
    - AppleWatch
        show current activity
        figure out focus
            focus should be enumed
                [main, passive, secondary]
    
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
 - clean up start logic is too complex
 - clean up done pathing 
    - for remove from parent
    - current done is more like clicked on, make it actually done

##Swift Data
- check if things are deleted after arc goes to zero if not delete on done

##unit tests

# Permenant notes
## UI
UI is a bit of a challenge due to its tree like nature, starting out with 
simple MVP like UI so I can iterate

### UI watch
can I do edits and creation on the watch
research apple watch background states
