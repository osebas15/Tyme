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
            - second to last are waiting "passive" activities
            - last are completed activities
    - tasking and multitaskings
        - wait X time after completion
            - can be made passive if has a passive timing
                - research between dispatch Queue vs Actor system
        - number of completions
    
### Happy on complete!
consider how to reward user for finishing tasks

##### Watch
List for all subactivities on select show next or disappear until all are gone and then show next

# Clean up
##Quick
###Activity Object 
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
