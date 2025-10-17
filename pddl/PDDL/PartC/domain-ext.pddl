;; lunar-extended-untyped.pddl
;; Untyped STRIPS domain for Mission 3 (astronauts, docking/control)
;; Use with the matching untyped problem file.

(define (domain lunar-extended-untyped)
  (:requirements :strips)

  (:predicates
    ;; base predicates
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

    ;; extension predicates
    (astronaut-at ?a ?loc)
    (docking ?loc)
    (control ?loc)
  )

  ;; Rover moves along explicit path
  (:action move
    :parameters (?r ?from ?to)
    :precondition (and (deployed ?r) (rover-at ?r ?from) (path ?from ?to))
    :effect (and (not (rover-at ?r ?from)) (rover-at ?r ?to))
  )

  ;; Take image
  (:action take-image
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (image-saved ?r ?loc) (not (memory-free ?r)))
  )

  ;; Take scan
  (:action take-scan
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (scan-saved ?r ?loc) (not (memory-free ?r)))
  )

  ;; Collect a sample on the ground
  (:action collect-sample
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (sample-at ?loc) (not (has-sample ?r)))
    :effect (and (has-sample ?r) (not (sample-at ?loc)))
  )

  ;; Store a sample at a lander location (rover and lander must be co-located)
  (:action store-sample
    :parameters (?r ?ld ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc) (has-sample ?r))
    :effect (and (sample-stored ?ld) (not (has-sample ?r)))
  )

  ;; Deploy rover when astronaut present at docking bay
  (:action deploy-with-astronaut
    :parameters (?r ?ld ?loc ?a)
    :precondition (and (assigned ?r ?ld) (lander-at ?ld ?loc) (not (deployed ?r))
                       (astronaut-at ?a ?loc) (docking ?loc))
    :effect (and (deployed ?r) (rover-at ?r ?loc))
  )

  ;; Transmit data when astronaut present in control room (frees memory)
  (:action transmit-with-astronaut
    :parameters (?r ?ld ?loc ?a)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc)
                       (not (memory-free ?r)) (astronaut-at ?a ?loc) (control ?loc))
    :effect (and (memory-free ?r))
  )

  ;; Astronaut moves along path edges (must follow path)
  (:action move-astronaut
    :parameters (?a ?from ?to)
    :precondition (and (astronaut-at ?a ?from) (path ?from ?to))
    :effect (and (not (astronaut-at ?a ?from)) (astronaut-at ?a ?to))
  )

)
