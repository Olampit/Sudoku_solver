;; Mission 2: Two landers, two rovers, larger map.
(define (problem mission-2)
  (:domain lunar)
  (:objects
    rover1 rover2 lander1 lander2 - object
    way1 way2 way3 way4 way5 way6 - object
  )

  (:init
    ;; lander positions and associations
    (lander-at lander1 way2)
    (lander-at lander2 way6)
    (assigned rover1 lander1)
    (assigned rover2 lander2)

    ;; initial rover states:
    ;; rover1 starts deployed at waypoint 2 (already on surface)
    (deployed rover1)
    (rover-at rover1 way2)
    ;; rover2 undeployed at its lander (deploy needed)
    ;; rover2 will be deployed from lander2 at way6

    (memory-free rover1)
    (memory-free rover2)

    ;; samples present
    (sample-at way1)
    (sample-at way5)

    ;; connectivity (example map, make sure all goals reachable)
    (path way1 way2) (path way2 way1)
    (path way2 way3) (path way3 way2)
    (path way3 way4) (path way4 way3)
    (path way4 way5) (path way5 way4)
    (path way5 way6) (path way6 way5)
    (path way2 way5) (path way5 way2)
    (path way3 way6) (path way6 way3)
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
