;; Extended Lunar Domain for Mission 3 (Part 2C)
;; Adds astronauts, docking/control areas, and constraints for deploy/transmit actions.
;; Compatible with planners: editor.planning.domains, Fast Downward, FF.

(define (domain lunar-extended)
  (:requirements :strips :typing)

  (:types
    rover lander astronaut location
  )

  (:predicates
    ;; --- Base world state ---
    (rover-at ?r - rover ?l - location)
    (lander-at ?ld - lander ?l - location)
    (path ?l1 - location ?l2 - location)
    (assigned ?r - rover ?ld - lander)
    (deployed ?r - rover)
    (memory-free ?r - rover)
    (image-saved ?r - rover ?l - location)
    (scan-saved ?r - rover ?l - location)
    (sample-at ?l - location)
    (has-sample ?r - rover)
    (sample-stored ?ld - lander)

    ;; --- New predicates for the extension ---
    (astronaut-at ?a - astronaut ?loc - location)
    (docking ?loc - location)       ;; marks docking-bay areas
    (control ?loc - location)       ;; marks control-room areas
  )

  ;; ----------------------------------------------------------------------
  ;; Standard actions (same as in base domain)
  ;; ----------------------------------------------------------------------

  (:action move
    :parameters (?r - rover ?from - location ?to - location)
    :precondition (and (deployed ?r) (rover-at ?r ?from) (path ?from ?to))
    :effect (and (not (rover-at ?r ?from)) (rover-at ?r ?to))
  )

  (:action take-image
    :parameters (?r - rover ?loc - location)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (image-saved ?r ?loc) (not (memory-free ?r)))
  )

  (:action take-scan
    :parameters (?r - rover ?loc - location)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (memory-free ?r))
    :effect (and (scan-saved ?r ?loc) (not (memory-free ?r)))
  )

  (:action collect-sample
    :parameters (?r - rover ?loc - location)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (sample-at ?loc) (not (has-sample ?r)))
    :effect (and (has-sample ?r) (not (sample-at ?loc)))
  )

  (:action store-sample
    :parameters (?r - rover ?ld - lander ?loc - location)
    :precondition (and (deployed ?r) (rover-at ?r ?loc) (lander-at ?ld ?loc) (has-sample ?r))
    :effect (and (sample-stored ?ld) (not (has-sample ?r)))
  )

  ;; ----------------------------------------------------------------------
  ;; Extended actions (astronaut-dependent)
  ;; ----------------------------------------------------------------------

  ;; Rover deployment requires astronaut in docking bay
  (:action deploy-with-astronaut
    :parameters (?r - rover ?ld - lander ?loc - location ?a - astronaut)
    :precondition (and
        (assigned ?r ?ld)
        (lander-at ?ld ?loc)
        (not (deployed ?r))
        (astronaut-at ?a ?loc)
        (docking ?loc)
    )
    :effect (and (deployed ?r) (rover-at ?r ?loc))
  )

  ;; Data transmission requires astronaut in control room
  (:action transmit-with-astronaut
    :parameters (?r - rover ?ld - lander ?loc - location ?a - astronaut)
    :precondition (and
        (deployed ?r)
        (rover-at ?r ?loc)
        (lander-at ?ld ?loc)
        (not (memory-free ?r))
        (astronaut-at ?a ?loc)
        (control ?loc)
    )
    :effect (and (memory-free ?r))
  )

  ;; Astronaut moves between docking bay and control room of same lander
  (:action move-astronaut
    :parameters (?a - astronaut ?from - location ?to - location)
    :precondition (and (astronaut-at ?a ?from))
    :effect (and (not (astronaut-at ?a ?from)) (astronaut-at ?a ?to))
  )
)
