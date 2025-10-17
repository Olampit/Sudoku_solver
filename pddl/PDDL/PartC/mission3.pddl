;; lunar-mission3-untyped.pddl
;; Problem using lunar-extended-untyped domain.
(define (problem lunar-mission-3-untyped)
  (:domain lunar-extended-untyped)

  (:objects
    rover1 rover2 lander1 lander2 alice bob
    way1 way2 way3 way4 way5 way6
    lander1-dock lander1-ctrl lander2-dock lander2-ctrl
  )

  (:init
    ;; landers positioned at their docking internal locations
    (lander-at lander1 lander1-dock)
    (lander-at lander2 lander2-dock)

    ;; assignments
    (assigned rover1 lander1)
    (assigned rover2 lander2)

    ;; rover1 pre-deployed on surface way2
    (deployed rover1)
    (rover-at rover1 way2)

    ;; rovers memory free
    (memory-free rover1)
    (memory-free rover2)

    ;; samples on surface
    (sample-at way1)
    (sample-at way5)

    ;; surface connectivity (bidirectional)
    (path way1 way2) (path way2 way1)
    (path way2 way3) (path way3 way2)
    (path way3 way4) (path way4 way3)
    (path way4 way5) (path way5 way4)
    (path way5 way6) (path way6 way5)
    (path way2 way5) (path way5 way2)
    (path way3 way6) (path way6 way3)

    ;; connect docking bays to surface waypoints
    (path lander1-dock way2) (path way2 lander1-dock)
    (path lander2-dock way6) (path way6 lander2-dock)

    ;; internal links docking <-> control
    (path lander1-dock lander1-ctrl) (path lander1-ctrl lander1-dock)
    (path lander2-dock lander2-ctrl) (path lander2-ctrl lander2-dock)

    ;; mark docking / control
    (docking lander1-dock)
    (control lander1-ctrl)
    (docking lander2-dock)
    (control lander2-ctrl)

    ;; astronaut starting positions
    (astronaut-at alice lander1-dock)
    (astronaut-at bob lander2-ctrl)
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
