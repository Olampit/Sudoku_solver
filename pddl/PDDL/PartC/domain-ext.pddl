(define (domain lunar-extended-fixed)
  (:requirements :strips)
  (:predicates
    (rover-at ?r ?l)
    (lander-at ?ld ?l)
    (path ?l1 ?l2)
    (assigned ?r ?ld)
    (deployed ?r)
    (memory-free ?r)
    (image-saved ?r ?l)
    (scan-saved ?r ?l)
    (sample-at ?l)
    (has-sample ?r)
    (sample-stored ?ld)
    (astronaut-in-dock ?a ?ld)
    (astronaut-in-control ?a ?ld)
  )

  (:action move
    :parameters (?r ?from ?to)
    :precondition (and (deployed ?r) (rover-at ?r ?from) (path ?from ?to))
    :effect (and (not (rover-at ?r ?from)) (rover-at ?r ?to))
  )

  (:action take-image
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (image-saved ?r ?loc) (not (memory-free ?r)))
  )

  (:action take-scan
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (scan-saved ?r ?loc) (not (memory-free ?r)))
  )

  (:action collect-sample
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (sample-at ?loc) (not (has-sample ?r)))
    :effect (and (has-sample ?r) (not (sample-at ?loc)))
  )

  (:action store-sample
    :parameters (?r ?ld ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc) (has-sample ?r))
    :effect (and (sample-stored ?ld) (not (has-sample ?r)))
  )

  (:action deploy-with-astronaut
    :parameters (?r ?ld ?loc ?a)
    :precondition (and (assigned ?r ?ld) (lander-at ?ld ?loc) (not (deployed ?r)) (astronaut-in-dock ?a ?ld))
    :effect (and (deployed ?r) (rover-at ?r ?loc))
  )

  (:action transmit-with-astronaut
    :parameters (?r ?ld ?loc ?a)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc) (not (memory-free ?r)) (astronaut-in-control ?a ?ld))
    :effect (and (memory-free ?r))
  )

  (:action astronaut-dock-to-control
    :parameters (?a ?ld)
    :precondition (astronaut-in-dock ?a ?ld)
    :effect (and (astronaut-in-control ?a ?ld) (not (astronaut-in-dock ?a ?ld)))
  )

  (:action astronaut-control-to-dock
    :parameters (?a ?ld)
    :precondition (astronaut-in-control ?a ?ld)
    :effect (and (astronaut-in-dock ?a ?ld) (not (astronaut-in-control ?a ?ld)))
  )
)
