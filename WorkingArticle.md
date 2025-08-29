# WorkingArticle
1% a day is all you need

an app to make and use timed todo list and recepies

## BIG BUGS
### Memory leaks
    - seems to be mostly at beggining

### look out for circular referencing and automatic stuff

## Scratch Pad

- add hip exercises and recover apple watch UI
- tasks aren't completable

- timer and notifications
    - wrap a state manager around a timer
        - it should all be main actor accessible
        - has on publish variable
        - UI treats it as an evironment
        
    - Timer needs to hold a state thats observable by the UI
        make timer 
        
    - it should trigger an update every x seconds

- basics testing
    - home view
        - if active
            - show parent at the top with tabs at top for other parents and up arrow for navigating levels
            - show lowest subactivities within parents
        - if none active
            - show possible activities, start with favorites
      
    - stable diffusion model code
        - Active Activity
        - Possible Activity

- Now its time to be able to add activities to other activities
    - add it to the editmanager
        - its there, now connect bound variable to it
        
- Home screen
    - favorites: Home subActivities
    
- make main activityview (top of find activityView)
    - wait after start
    - next
    - parent 
    - subclasses

- make edit/add view
    - Views I need
        - Activity Class
            - edit / add / detail
                - add classes where necessary
                - make add view flow
    
    


- make workable state for my burger/quick breakfast recepie
    - UI for Active activities
        - higher nodes!!!
        - number of completions

# Clean up
##unit tests

# Permenant notes
## UI
UI is a bit of a challenge due to its tree like nature, starting out with 
simple MVP like UI so I can iterate

### UI watch
can I do edits and creation on the watch
research apple watch background states

## Happy on complete!
consider how to reward user for finishing tasks
