;; domain.pddl
;; Simple STRIPS-style domain for lunar rover missions.
;; Predicates:
;; (rover-at ?r ?l)
;; (lander-at ?ld ?l)
;; (path ?l1 ?l2)    ;; bidirectional connections (add both directions in problem)
;; (assigned ?r ?ld) ;; rover belongs to lander
;; (deployed ?r)     ;; rover is deployed
;; (memory-free ?r)
;; (image-saved ?r ?l)
;; (scan-saved ?r ?l)
;; (sample-at ?l)    ;; sample present on ground at location
;; (has-sample ?r)
;; (sample-stored ?ld)
;; (astronaut-at ?a ?loc)  ;; extension
;; (docking ?loc)   ;; marks docking bay location (extension)
;; (control ?loc)   ;; marks control room location (extension)

(define (domain lunar)
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
    (astronaut-at ?a ?loc)
    (docking ?loc)
    (control ?loc)
  )

  ;; Move rover along a path
  (:action move
    :parameters (?r ?from ?to)
    :precondition (and (deployed ?r) (rover-at ?r ?from) (path ?from ?to))
    :effect (and (not (rover-at ?r ?from)) (rover-at ?r ?to))
  )

  ;; Deploy rover without astronaut (for Missions 1 & 2)
  (:action deploy
    :parameters (?r ?ld ?loc)
    :precondition (and (assigned ?r ?ld) (lander-at ?ld ?loc) (not (deployed ?r)))
    :effect (and (deployed ?r) (rover-at ?r ?loc))
  )

  ;; Deploy requiring astronaut in docking (for Mission 3)
  (:action deploy-with-astronaut
    :parameters (?r ?ld ?loc ?a)
    :precondition (and (assigned ?r ?ld) (lander-at ?ld ?loc) (not (deployed ?r))
                       (astronaut-at ?a ?loc) (docking ?loc))
    :effect (and (deployed ?r) (rover-at ?r ?loc))
  )

  ;; Take image (requires memory free)
  (:action take-image
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (image-saved ?r ?loc) (not (memory-free ?r)))
  )

  ;; Take scan (requires memory free)
  (:action take-scan
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (scan-saved ?r ?loc) (not (memory-free ?r)))
  )

  ;; Transmit data to lander (frees memory). Version without astronaut:
  (:action transmit
    :parameters (?r ?ld ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc) (not (memory-free ?r)))
    :effect (and (memory-free ?r))
  )

  ;; Transmit with astronaut in control room (Mission 3)
  (:action transmit-with-astronaut
    :parameters (?r ?ld ?loc ?a)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc) (not (memory-free ?r))
                       (astronaut-at ?a ?loc) (control ?loc))
    :effect (and (memory-free ?r))
  )

  ;; Collect sample at location if sample present
  (:action collect-sample
    :parameters (?r ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (sample-at ?loc) (not (has-sample ?r)))
    :effect (and (has-sample ?r) (not (sample-at ?loc)))
  )

  ;; Store sample at lander (rover at same lander location). After storing, lander has sample.
  (:action store-sample
    :parameters (?r ?ld ?loc)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc) (has-sample ?r))
    :effect (and (sample-stored ?ld) (not (has-sample ?r)))
  )

  ;; Astronaut moves between docking and control within same lander area (Mission 3)
  (:action move-astronaut
    :parameters (?a ?from ?to)
    :precondition (and (astronaut-at ?a ?from))
    :effect (and (not (astronaut-at ?a ?from)) (astronaut-at ?a ?to))
  )

)
