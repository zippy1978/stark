
cb := func () => void {
    
    shouldClose := 0    
    while(shouldClose == 0) {
        println("in")
        /*println("before")
        al_wait_for_event(queue, event)
        println("after")
        e := toAllegroEvent(event)
        if (e != null && e.type == "ALLEGRO_EVENT_DISPLAY_CLOSE") {
            shouldClose = true
        }*/
    }
}

cb()
