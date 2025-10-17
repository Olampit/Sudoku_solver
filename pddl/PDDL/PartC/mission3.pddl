;; File: lunar-mission3.pddl
;; Mission 3 problem file for domain lunar-extended
;; Two landers, two rovers, astronauts Alice and Bob, internal docking/control areas.
;; - Alice starts in Lander1 docking bay
;; - Bob starts in Lander2 control room
;; - Rover1 already deployed at waypoint way2 (its lander is at same site)
;; - Rover2 is undeployed at Lander2
;; Goals: images and scans as specified, and two samples collected and stored.

(define (problem lunar-mission-3)
  (:domain lunar-extended)

  (:objects
    ;; rovers and landers
    rover1 rover2 - rover
    lander1 lander2 - lander

    ;; astronauts
    alice bob - astronaut

    ;; surface waypoints
    way1 way2 way3 way4 way5 way6 - location

    ;; internal locations for landers (docking bays and control rooms)
    lander1-dock lander1-ctrl lander2-dock lander2-ctrl - location
  )

  (:init
    ;; --- Landers and assignments ---
    ;; Place landers at their docking internal location (internal-dock location)
    (lander-at lander1 lander1-dock)
    (lander-at lander2 lander2-dock)

    ;; associate rovers with landers
    (assigned rover1 lander1)
    (assigned rover2 lander2)

    ;; --- Rover initial states ---
    ;; Rover1 is already deployed at waypoint way2 (pre-deployed)
    (deployed rover1)
    (rover-at rover1 way2)

    ;; Rover2 is undeployed (not deployed by default)
    ;; Rover2 will require deploy-with-astronaut (or deploy) to be placed on surface.

    ;; memory free for both rovers initially
    (memory-free rover1)
    (memory-free rover2)

    ;; --- Samples on surface ---
    (sample-at way1)
    (sample-at way5)

    ;; --- Connectivity on surface (bidirectional edges) ---
    (path way1 way2) (path way2 way1)
    (path way2 way3) (path way3 way2)
    (path way3 way4) (path way4 way3)
    (path way4 way5) (path way5 way4)
    (path way5 way6) (path way6 way5)
    (path way2 way5) (path way5 way2)
    (path way3 way6) (path way6 way3)

    ;; --- Connect lander internal docking bays to their surface waypoint sites ---
    ;; This allows a deployed rover at the docking bay to move onto the surface waypoint and vice-versa
    (path lander1-dock way2) (path way2 lander1-dock)
    (path lander2-dock way6) (path way6 lander2-dock)

    ;; --- Connect docking bay <-> control room within each lander so astronauts can move ---
    (path lander1-dock lander1-ctrl) (path lander1-ctrl lander1-dock)
    (path lander2-dock lander2-ctrl) (path lander2-ctrl lander2-dock)

    ;; --- Mark internal areas as docking / control ---
    (docking lander1-dock)
    (control lander1-ctrl)
    (docking lander2-dock)
    (control lander2-ctrl)

    ;; --- Astronaut starting positions ---
    ;; Alice starts in Lander1 docking bay
    (astronaut-at alice lander1-dock)
    ;; Bob starts in Lander2 control room
    (astronaut-at bob lander2-ctrl)

    ;; Note: both docking/control internal locations are modeled as 'location' objects,
    ;; and linked to surface waypoints via path facts above.
  )

  (:goal
    (and
      ;; Mission 3 goals (same as Mission 2 goals plus astronauts constraints)
      (image-saved rover1 way3)
      (scan-saved rover1 way4)
      (image-saved rover2 way2)
      (scan-saved rover2 way6)
      (sample-stored lander1)
      (sample-stored lander2)
    )
  )
)
