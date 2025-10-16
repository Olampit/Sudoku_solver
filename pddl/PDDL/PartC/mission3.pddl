;; Mission 3 (extension): astronauts, internal areas, and constraints
(define (problem mission-3)
  (:domain lunar)
  (:objects
    rover1 rover2 lander1 lander2 - object
    way1 way2 way3 way4 way5 way6 - object
    a1-dock a1-ctrl a2-dock a2-ctrl - object
    alice bob - object
  )

  (:init
    ;; lander positions (landers at waypoints)
    (lander-at lander1 way2)
    (lander-at lander2 way6)
    (assigned rover1 lander1)
    (assigned rover2 lander2)

    ;; rover1 already deployed at waypoint 2
    (deployed rover1)
    (rover-at rover1 way2)
    (memory-free rover1)
    (memory-free rover2)

    ;; samples present
    (sample-at way1)
    (sample-at way5)

    ;; Map connectivity (surface)
    (path way1 way2) (path way2 way1)
    (path way2 way3) (path way3 way2)
    (path way3 way4) (path way4 way3)
    (path way4 way5) (path way5 way4)
    (path way5 way6) (path way6 way5)
    (path way2 way5) (path way5 way2)
    (path way3 way6) (path way6 way3)

    ;; internal docking/control areas associated with landers:
    ;; we represent docking/control as locations; associate them by having them at the same lander location
    (docking a1-dock) (control a1-ctrl)
    (docking a2-dock) (control a2-ctrl)

    ;; Put astronauts in starting areas:
    ;; Alice is in the docking bay of Lander1 (which we represent as a1-dock)
    ;; Bob is in the control room of Lander2 (a2-ctrl)
    (astronaut-at alice a1-dock)
    (astronaut-at bob a2-ctrl)

    ;; Associate internal areas with lander location by placing them at same waypoint:
    ;; We treat landing internal locations as co-located with the lander waypoint for preconditions:
    ;; (lander-at lander1 way2) (thus deploy-with-astronaut requires astronaut-at ?loc and docking ?loc)
    ;; To keep model simple, we will treat a1-dock and a1-ctrl as being colocated at way2 implicitly:
    ;; (One can add additional predicates to assert that; planners accept preconditions based on matching locations.)
  )

  (:goal
    (and
      (image-saved rover1 way3)
      (scan-saved rover1 way4)
      (image-saved rover2 way2)
      (scan-saved rover2 way6)
      (sample-stored lander1)
      (sample-stored lander2)
    )
  )
)
